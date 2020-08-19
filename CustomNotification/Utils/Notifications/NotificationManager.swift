//
//  NotificationManager.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import Foundation
import UserNotifications

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

    func sendNotification(with metadata: NotificationMetadata, callback: @escaping (Result<Void, NotificationError>) -> Void) {
        notificationCenter.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized ||
                    settings.authorizationStatus == .ephemeral else {
                DispatchQueue.main.async { callback(.failure(.denied)) }
                return
            }
            self.sendLocalNotification(with: metadata, callback: callback)
        }
    }

    private func sendLocalNotification(with metadata: NotificationMetadata, callback: @escaping (Result<Void, NotificationError>) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = metadata.title
        content.body = "Pull down the notification to see more information."

        guard let data = try? JSONEncoder().encode(metadata) else {
            callback(.failure(.failedToEncode))
            return
        }
        content.userInfo = ["data" : data]
        content.categoryIdentifier = metadata.type.rawValue

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                DispatchQueue.main.async { callback(.failure(.undefined(error))) }
                return
            }
            DispatchQueue.main.async { callback(.success(())) }
        }
    }
}
