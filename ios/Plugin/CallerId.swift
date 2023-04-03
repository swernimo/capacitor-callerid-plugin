import Foundation
import CallKit
import OSLog

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        os_log("Caller Id Plugin: Add Contacts")
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(callers) else { return }
        UserDefaults.standard.set(encoded, forKey: "Contacts")
        
        let extensionBundleId = "com.unanet.cosentialformobile.calleridextension"
        
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: extensionBundleId, completionHandler: {(status, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if (status == .enabled) {
                    print("Extension is enabled")
                    CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: extensionBundleId, completionHandler: { (error) in
                        if let error = error {
                            print("Error reloading extension: \(error.localizedDescription)")
                        }
                        else {
                            print("Success reloading extension")
                        }
                    })
                }
            }
        })
        return
    }
}
