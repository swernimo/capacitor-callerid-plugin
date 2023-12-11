import Foundation
import Capacitor
import OSLog
import NotificationCenter
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
            NotificationCenter.default.post(name: Notification.Name("callerid"), object: nil, userInfo: ["contacts": contactsJSON])
            call.resolve()
        } else {
            return call.reject("Error occured trying to get contacts")
        }
    }
    
    @objc func checkStatus(_ call: CAPPluginCall) {
        bridge?.saveCall(call)
        statusCallId = call.callbackId
        implementation.checkStatus(completionHandler: {(status, error) -> Void in
            guard let savedCall = self.bridge?.savedCall(withID: self.statusCallId!) else {
                return call.reject("Error retrieving saved capacitor call for caller id: check status")
            }
            
            guard error == nil else {
                self.bridge?.releaseCall(savedCall)
                return savedCall.reject("Error checking status \(String(describing: error))", nil, error)
            }
            
            self.bridge?.releaseCall(savedCall)
            return savedCall.resolve([
                "value": status == .enabled
            ])
        })
    }
}
