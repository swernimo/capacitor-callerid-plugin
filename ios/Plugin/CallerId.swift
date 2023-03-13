import Foundation
import CoreData
import OSLog

@objc public class CallerId: NSObject {
    @objc public func addContacts(callers: [CallerInfo]) -> Void {
        os_log("Caller Id Plugin: Add Contacts")
        os_log("Need to save contacts to core data")
        return
    }
}
