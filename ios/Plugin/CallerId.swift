import Foundation
import CallKit

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        guard let encoded = try? encoder.encode(callers) else { return }
        let extensionBundleId = "com.unanet.cosentialformobile.CallerId"
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
                print(String(describing: error))
            }
            else {
                if (status == .enabled) {
                    CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: extensionBundleId, completionHandler: { (error) in
                        if let error = error {
                            print(String(describing: "Error reloading extension: \(error)"))
                        }
                    })
                }
            }
        })
        return
    }
}
