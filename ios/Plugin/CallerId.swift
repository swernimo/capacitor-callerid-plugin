import Foundation

@objc public class CallerId: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
