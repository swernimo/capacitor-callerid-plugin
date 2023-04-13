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
    private var statusCallId: String
    
    public override init() {
        self.statusCallId = ""
        super.init()
    }
    
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
            
            if(!contacts.isEmpty) {
                let groups = Dictionary(grouping: contacts, by: { $0.PhoneNumber })
                contacts = []
                let sorted = groups.sorted(by: { $0.key < $1.key})
                sorted.forEach({ key, value in
                    if (value.count == 1) {
                        let contact = CallerInfo(DisplayName: value[0].DisplayName, PhoneNumber: key, LastUpdated: value[0].LastUpdated, CompanyName: value[0].CompanyName)
                        contacts.append(contact)
                    } else {
                        let personnelGroup = Dictionary(grouping: value, by: { $0.DisplayName})
                        let companyGroups = Dictionary(grouping: value, by: { $0.CompanyName})
                        let companyCount = companyGroups.count
                        if (personnelGroup.count == 1) {
                            if(companyCount == 1) {
                                let person = personnelGroup.keys.first!
                                let contact = CallerInfo(DisplayName: person, PhoneNumber: key, LastUpdated: value.first!.LastUpdated, CompanyName: "Multiple Companies")
                                contacts.append(contact)
                            } else {
                                let contact = CallerInfo(DisplayName: "Multiple Contacts", PhoneNumber: key, LastUpdated: value.first!.LastUpdated, CompanyName: "Multiple Companies")
                                contacts.append(contact)
                            }
                        } else {
                            if (companyCount == 1) {
                                let contact = CallerInfo(DisplayName: "Multiple Contacts", PhoneNumber: key, LastUpdated: value.first!.LastUpdated, CompanyName: companyGroups.keys.first!)
                                contacts.append(contact)
                            } else {
                                let contact = CallerInfo(DisplayName: "Multiple Contacts", PhoneNumber: key, LastUpdated: value.first!.LastUpdated, CompanyName: "Multiple Companies")
                                contacts.append(contact)
                            }
                        }
                    }
                })
                
                implementation.addContacts(callers: contacts)
                return call.resolve()
            }
            return call.reject("Invalid contacts")
        } else {
            return call.reject("Error occured trying to get contacts")
        }
    }
    
    @objc func checkStatus(_ call: CAPPluginCall) {
        print("Check Status Begin")
        bridge?.saveCall(call)
        statusCallId = call.callbackId
        implementation.checkStatus(completionHandler: {(status, error) -> Void in
            print("Inside check status completion handler")
            guard let savedCall = self.bridge?.savedCall(withID: self.statusCallId) else {
                return call.reject("Error retrieving saved capacitor call")
            }
            
            guard error != nil else {
                print(String(describing: error))
                return savedCall.reject("Error checking status")
            }
            
            self.bridge?.releaseCall(savedCall)
            print("Extension Status: \(status)")
            print("Resolving saved call")
            return savedCall.resolve([
                "value": status
            ])
        })
        print("Check Status End")
    }
}
