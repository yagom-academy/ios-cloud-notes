//
//  OSLog+Extension.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation
import OSLog

extension OSLog {
    static let objectCFormatSpecifier: StaticString = "%@"
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let data = OSLog(subsystem: subsystem, category: "Data")
    static let ui = OSLog(subsystem: subsystem, category: "UI")
}
