//
//  InputError.swift
//  NumberBaseball
//
//  Created by Mangdi on 2023/03/22.
//

import Foundation

enum InputError: Error {
    case countError(message: String)
    case numberError(message: String)
    case rangeError(message: String)
}
