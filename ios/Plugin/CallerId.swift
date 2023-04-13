import Foundation
import CallKit

@objc public class CallerId: NSObject {
    let extensionBundleId = "com.unanet.cosentialformobile.CallerId"
 
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        guard let encoded = try? encoder.encode(callers) else { return }
        let groupName = "group.com.unanet.cosentialformobile"
        let fileName = "callers.json"
        if let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) {
            var fileUrl: URL
            if #available(iOS 16, *) {
                fileUrl = baseURL.appending(path: fileName)
            } else {
                fileUrl = baseURL.appendingPathComponent(fileName)
            }
            if (FileManager.default.fileExists(atPath: fileUrl.relativePath)) {
                try? FileManager.default.removeItem(atPath: fileUrl.relativePath)
            }
            FileManager.default.createFile(atPath: fileUrl.relativePath, contents: encoded)
        }
        
        self.checkStatus(completionHandler: {(status, error) -> Void in
                if let error = error {
                    print(String(describing: error))
                }
                else {
                    if (status == .enabled) {
                        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: self.extensionBundleId, completionHandler: { (error) in
                            if let error = error {
                                print(String(describing: "Error reloading extension: \(error)"))
                            }
                        })
                    }
                }
        })
        return
    }
    
    @objc public func checkStatus(completionHandler: @escaping (CXCallDirectoryManager.EnabledStatus, Error?) -> Void) -> Void {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: self.extensionBundleId, completionHandler: completionHandler)
    }
}
