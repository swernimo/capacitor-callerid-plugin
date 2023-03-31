import Foundation
import CallKit
import OSLog

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        os_log("Caller Id Plugin: Add Contacts")
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(callers) else { return }
        UserDefaults.standard.set(encoded, forKey: "Contacts")
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "com.unanet.cosentialformobile.calleridextension", completionHandler: { (error) in
            if let error = error {
                print("Error reloading extension: \(error.localizedDescription)")
            }
        })
        os_log("Successfully reloaded call directory extension")
        return
    }
}
