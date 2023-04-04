//
//  CallDirectoryHandler.swift
//  CallerIdExtension
//
//  Created by Sean Wernimont on 4/3/23.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        print("Inside Call Directory Handler: Begin Request")
        // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
        // and identification entries which have been added or removed since the last time this extension's data was loaded.
        // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
        // and identification phone numbers if the request is not incremental.
        
        addAllIdentificationPhoneNumbers(to: context)
        context.completeRequest()
    }

    private func getCallers() throws -> [CallerInfo]  {
        print("Call Directory Handler get callers")
        var callers: [CallerInfo] = []
        if let saved = UserDefaults.standard.data(forKey: "Contacts") {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                callers = try decoder.decode([CallerInfo].self, from: saved)
                print("successfully decoded saved data")
                UserDefaults.standard.removeObject(forKey: "Contacts")
            } catch let error {
                print(String(describing: error))
                throw error
            }
        }
        return callers
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        print("Call Directory Handler: add all phone numbers")
        if let callers = try? self.getCallers() {
            print("Call Directory Handler: got callers array")
            for caller in callers {
                context.addIdentificationEntry(withNextSequentialPhoneNumber: caller.PhoneNumber, label: caller.DisplayName)
            }
        }
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
