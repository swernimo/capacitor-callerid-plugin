import Foundation
import CallKit

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        print("Caller Id Plugin: Add Contacts")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        guard let encoded = try? encoder.encode(callers) else { return }
        print("Saving \(callers.count) callers")
        let extensionBundleId = "com.unanet.cosentialformobile.CallerId"
        let groupName = "group.com.unanet.cosentialformobile"
        let fileName = "callers.json"
        if let baseURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName) {
            print("base URL for \(groupName) is \(baseURL)")
            var fileUrl: URL
            if #available(iOS 16, *) {
                fileUrl = baseURL.appending(path: fileName)
            } else {
                fileUrl = baseURL.appendingPathComponent(fileName)
            }
            if (FileManager.default.fileExists(atPath: fileUrl.relativePath)) {
                print("Callers.json already exists. Recreating")
                try? FileManager.default.removeItem(atPath: fileUrl.relativePath)
            }
            FileManager.default.createFile(atPath: fileUrl.relativePath, contents: encoded)
            print("Successfully created file at: \(fileUrl.relativePath)")
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
