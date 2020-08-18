//
//  NotificationManager.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import Foundation
import UserNotifications

enum NotificationError: Error {
    case denied
    case undefined(Error)
}

class NotificationManager {
    static var current = NotificationManager()

    private let notificationCenter: UNUserNotificationCenter
    private let notificationIdentifier = "customNotification"

    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }

    static func set(delegate: UNUserNotificationCenterDelegate) {
        current.notificationCenter.delegate = delegate
    }

    func requestAuthorizationIfNeeded(callback: @escaping (Result<Bool, Error>) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            callback(.success(didAllow))
        }
    }

    func sendNotification(callback: @escaping (Result<Void, NotificationError>) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized ||
                    settings.authorizationStatus == .ephemeral else {
                callback(.failure(.denied))
                return
            }
            self.sendLocalNotification(callback: callback)
        }
    }

    private func sendLocalNotification(callback: @escaping (Result<Void, NotificationError>) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                callback(.failure(.undefined(error)))
                return
            }
            callback(.success(()))
        }
    }
}
