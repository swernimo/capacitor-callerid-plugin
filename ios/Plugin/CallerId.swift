import Foundation
import CallKit

@objc public class CallerId: NSObject {
    let extensionBundleId = "com.unanet.cosentialformobile.CallerId"
    
    @objc public func checkStatus(completionHandler: @escaping (CXCallDirectoryManager.EnabledStatus, Error?) -> Void) -> Void {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: self.extensionBundleId, completionHandler: completionHandler)
    }
}
