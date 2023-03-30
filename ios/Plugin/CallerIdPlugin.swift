import Foundation
import CallKit
import Capacitor
import OSLog

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CallerIdPlugin)
public class CallerIdPlugin: CAPPlugin {
    private let implementation = CallerId()
    
    @objc func addContacts(_ call: CAPPluginCall) {
        if let contactsJSON = call.getAny("contacts") as? [[String: AnyObject]] {
            if(contactsJSON.isEmpty) {
                return call.reject("Cannot Add Empty Array")
            }
            let dateFormatter = ISO8601DateFormatter()
            var contacts: [CallerInfo] = []
            for json in contactsJSON {
                    let displayName = json["displayname"] as! String
                    let number = Int64.init(json["phonenumber"] as! String)!
                    let lastUpdatedStr = json["lastupdated"] as? String ?? ""
                guard let lastUpdated = dateFormatter.date(from: lastUpdatedStr) else { return  }
                    let contact = CallerInfo(DisplayName: displayName, PhoneNumber: number, LastUpdated: lastUpdated)
                    contacts.append(contact)
            }
            if(!contacts.isEmpty) {
                implementation.addContacts(callers: contacts)
                CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.unanet.cosentialformobile.calleridextension", completionHandler: { (error) in
                    if let error = error {
                        print("Error reloading extension: \(error.localizedDescription)")
                    }
                })
                os_log("Successfully reloaded call directory extension")
                return call.resolve()
            }
            return call.reject("Invalid contacts")
        } else {
            return call.reject("Error occured trying to get contacts")
        }
    }
}
