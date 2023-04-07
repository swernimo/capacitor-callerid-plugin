//
//  CallerInfo.swift
//  Plugin
//
//  Created by Sean Wernimont on 3/30/23.
//  Copyright © 2023 Max Lynch. All rights reserved.
//

import Foundation

public class CallerInfo: NSObject, Codable {
    public var DisplayName: String
    public var PhoneNumber: Int64
    public var LastUpdated: Date
    public var CompanyName: String
    
    init(DisplayName: String, PhoneNumber: Int64, LastUpdated: Date, CompanyName: String) {
        self.DisplayName = DisplayName
        self.PhoneNumber = PhoneNumber
        self.LastUpdated = LastUpdated
        self.CompanyName = CompanyName
    }
}
