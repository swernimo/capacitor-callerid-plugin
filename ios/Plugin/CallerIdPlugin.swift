import Foundation
import Capacitor
import OSLog

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CallerIdPlugin)
public class CallerIdPlugin: CAPPlugin {
    private let implementation = CallerId()
    private var statusCallId: String?
    
    @objc func addContacts(_ call: CAPPluginCall) {
        if let contactsJSON = call.getAny("contacts") as? [[String: AnyObject]] {
            if(contactsJSON.isEmpty) {
                return call.reject("Cannot Add Empty Array")
            }
            let dateFormatter = ISO8601DateFormatter()
            var contacts: [CallerInfo] = []
            for json in contactsJSON {
                if let number = json["phonenumber"] as? Int64 {
                    let displayName = json["displayname"] as! String
                    let companyname = json["companyname"] as? String ?? ""
                    let lastUpdatedStr = json["lastupdated"] as? String ?? ""
                    guard let lastUpdated = dateFormatter.date(from: lastUpdatedStr) else { return  }
                    let contact = CallerInfo(DisplayName: displayName, PhoneNumber: number, LastUpdated: lastUpdated, CompanyName: companyname)
                    contacts.append(contact)
                }
            }
            
            implementation.addContacts(callers: contacts)
            return call.resolve()
        } else {
            return call.reject("Error occured trying to get contacts")
        }
    }
    
    @objc func checkStatus(_ call: CAPPluginCall) {
        bridge?.saveCall(call)
        statusCallId = call.callbackId
        implementation.checkStatus(completionHandler: {(status, error) -> Void in
            guard let savedCall = self.bridge?.savedCall(withID: self.statusCallId!) else {
                return call.reject("Error retrieving saved capacitor call")
            }
            
            guard error == nil else {
                print(String(describing: error))
                return savedCall.reject("Error checking status")
            }
            
            self.bridge?.releaseCall(savedCall)
            return savedCall.resolve([
                "value": status == .enabled
            ])
        })
    }
}
