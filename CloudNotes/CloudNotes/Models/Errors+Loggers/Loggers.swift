//
//  Loggers.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation
import os

enum Loggers {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let data = Logger(subsystem: subsystem, category: "Data")
    static let ui = Logger(subsystem: subsystem, category: "UI")
}
