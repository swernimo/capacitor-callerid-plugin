import Foundation
import Capacitor
import OSLog
import CoreData

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CallerIdPlugin)
public class CallerIdPlugin: CAPPlugin {
    private let implementation = CallerId()
    
    @objc func addContacts(_ call: CAPPluginCall) {
        if let contactsJSON = call.getAny("contacts") as? [Data] {
            if(contactsJSON.isEmpty) {
                return call.reject("Cannot Add Empty Array")
            }
//            let dateFormatter = ISO8601DateFormatter()
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            //UserDefaults.standard.removeObject(forKey: <#T##String#>)
            var contacts: [CallerInfo] = []
            for json in contactsJSON {
                guard let caller = try? decoder.decode(CallerInfo.self, from: json) else {
                    return call.reject("Invalid JSON supplied to plugin")
                }
                contacts.append(caller)
//                    let displayName = json["displayname"] as! String
//                    let number = Int64.init(json["phonenumber"] as! String)!
//                    let lastUpdatedStr = json["lastupdated"] as? String ?? ""
//                    let lastUpdated = dateFormatter.date(from: lastUpdatedStr)
//                    let contact = CallerInfo()
//                    contact.displayname = displayName
//                    contact.phonenumber = number
//                    contact.lastupdated = lastUpdated
//                    contacts.append(contact)
                    os_log("")
            }
            if(!contacts.isEmpty) {
                implementation.addContacts(callers: contacts)
                //TODO: reload extension
                return call.resolve()
            }
        } else {
            return call.reject("Error occured trying to get contacts")
        }
    }
}
