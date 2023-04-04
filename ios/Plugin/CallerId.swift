import Foundation
import CallKit

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        print("Caller Id Plugin: Add Contacts")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        guard let encoded = try? encoder.encode(callers) else { return }
        UserDefaults.standard.set(encoded, forKey: "Contacts")
        print("Added contacts to user defaults")
        let extensionBundleId = "com.unanet.cosentialformobile.CallerId"
//        if #available(iOS 13.4, *) {
//            CXCallDirectoryManager.sharedInstance.openSettings { (error) in
//                if let error = error {
//                    print("Error opening caller id settings: \(error.localizedDescription)")
//                } else {
//                    print("Successfully opened settings")
//                }
//            }
//        }
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
