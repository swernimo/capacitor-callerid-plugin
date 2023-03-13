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
        let contactsJSON = call.getArray("contacts") ?? []
        if contactsJSON.isEmpty {
            call.reject("Cannot Add Empty Array")
        }
        os_log("got array from plugin")
        let contacts: [CallerInfo] = []
        //TODO: convert contactsJSON to CallerInfo array
        for json in contactsJSON {
            os_log("decoding object and adding to array")
            //let contact = JSONDecoder().decode(CallerInfo.self, from: json)
        }
        implementation.addContacts(callers: contacts)
        //TODO: reload extension
        //TODO: resolve call
    }
}
