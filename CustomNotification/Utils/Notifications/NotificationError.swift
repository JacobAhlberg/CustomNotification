//
//  NotificationError.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import Foundation

enum NotificationError: LocalizedError {
    case denied
    case invalidContent
    case failedToInitializeData
    case failedToDecode
    case failedToEncode
    case undefined(Error)

    var errorDescription: String? {
        switch self {
        case .denied: return "Notification settings are disabled"
        case .failedToInitializeData: return "Couldn't find a location, please try again with different coordinate."
        case .undefined(let error): return "Error: \(error.localizedDescription)"
        case .invalidContent: return "Coordinate is invalid. Adjust the coordinate and try again."
        case .failedToDecode, .failedToEncode: return "Something went wrong, please try again."
        }
    }
}
