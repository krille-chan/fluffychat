//
//  NotificationService.swift
//  Notification Extension
//
//  Created by Christian Pauly on 26.08.25.
//

import UserNotifications
import os

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Uncomment to read the push message payload:
            // os_log("[FluffyChatPushHelper] New message received: %{public}@", log: .default, type: .error, bestAttemptContent.userInfo)
            os_log("[FluffyChatPushHelper] New message received")
            
            guard let roomId = bestAttemptContent.userInfo["room_id"] as? String,
                  let eventId = bestAttemptContent.userInfo["event_id"] as? String else {
                os_log("[FluffyChatPushHelper] Room ID or Event ID is missing!")
                let emptyContent = UNMutableNotificationContent()
                contentHandler(emptyContent)
                return
            }
            bestAttemptContent.threadIdentifier = roomId
            
            if
               let jsonString = bestAttemptContent.userInfo["counts"] as? String,
               let jsonData = jsonString.data(using: .utf8),
               let jsonMap = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let unread = jsonMap["unread"] as? Int {
                bestAttemptContent.title = String(
                    localized: "\(unread) unread messages",
                    comment: "Default notification title"
                )
                bestAttemptContent.badge = NSNumber(integerLiteral: unread)
            }
            
            // TODO: Download and decrypt event to display a better body:
            bestAttemptContent.body = String(
                localized: "New message - open app to read",
                comment: "Default notification body"
            )
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
