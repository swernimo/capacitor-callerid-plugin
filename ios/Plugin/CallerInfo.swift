//
//  CallerInfo.swift
//  Plugin
//
//  Created by Sean Wernimont on 3/30/23.
//  Copyright © 2023 Max Lynch. All rights reserved.
//

import Foundation

public class CallerInfo: NSObject, Codable {
    var DisplayName: String
    var PhoneNumber: Int64
    var LastUpdated: Date
    
    init(DisplayName: String, PhoneNumber: Int64, LastUpdated: Date) {
        self.DisplayName = DisplayName
        self.PhoneNumber = PhoneNumber
        self.LastUpdated = LastUpdated
    }
}
