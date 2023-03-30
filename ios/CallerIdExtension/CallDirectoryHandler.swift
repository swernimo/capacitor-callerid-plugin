//
//  CallDirectoryHandler.swift
//  CallerIdExtension
//
//  Created by Sean Wernimont on 3/10/23.
//  Copyright © 2023 Max Lynch. All rights reserved.
//

import Foundation
import CallKit
import OSLog
import Plugin

class CallDirectoryHandler: CXCallDirectoryProvider {

    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        os_log("Inside Call Directory Handler: Begin Request")
        // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
        // and identification entries which have been added or removed since the last time this extension's data was loaded.
        // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
        // and identification phone numbers if the request is not incremental.
        
        addAllIdentificationPhoneNumbers(to: context)
        context.completeRequest()
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        os_log("Call Directory Handler: add all phone numbers")
        if let callers = try? self.getCallers() {
            os_log("Call Directory Handler: got callers array")
            for caller in callers {
                context.addIdentificationEntry(withNextSequentialPhoneNumber: caller.PhoneNumber, label: caller.DisplayName)
            }
        }
        UserDefaults.standard.removeObject(forKey: "Contacts")
    }
    
    private func getCallers() throws -> [CallerInfo]  {
        os_log("Call Directory Handler get callers")
        let callers: [CallerInfo] = []
        guard let saved = UserDefaults.standard.array(forKey: "Contacts") else {
            return []
        }
        let decoder = JSONDecoder()
        for data in saved {
            os_log("")
//            let caller = decoder.decode(CallerInfo.self, from: da)
//            callers.append(caller)
        }
//        let fetchRequest:NSFetchRequest<CallerInfo> = CallerInfo.fetchRequest()
//        let callers = try fetchRequest.execute()
        return callers
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
