//
//  NotificationService.swift
//  Notification Extension
//
//  Created by Christian Pauly on 26.08.25.
//

import FMDB
import Foundation
import UserNotifications
import os

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler:
            @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent =
            (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else { return }

        // Uncomment to read the push message payload:
        // os_log("[FluffyChatPushHelper] New message received: %{public}@", log: .default, type: .error, bestAttemptContent.userInfo)
        os_log("[FluffyChatPushHelper] New message received")

        // Check if notification contains room ID and event ID:
        guard let roomId = bestAttemptContent.userInfo["room_id"] as? String,
            let eventId = bestAttemptContent.userInfo["event_id"] as? String
        else {
            os_log("[FluffyChatPushHelper] Room ID or Event ID is missing!")
            let emptyContent = UNMutableNotificationContent()
            contentHandler(emptyContent)
            return
        }

        // Set thread identifier and fallback body:
        bestAttemptContent.threadIdentifier = roomId
        bestAttemptContent.body = String(
            localized: "New message - open app to read",
            comment: "Default notification body"
        )

        var unread: Int?
        if let countsJson = bestAttemptContent.userInfo["counts"] as? String,
            let counts = try? JSONDecoder().decode(
                NotificationCounts.self,
                from: countsJson.data(using: .utf8)!
            )
        {
            unread = counts.unread
        }

        // Set badge and fallback title:
        bestAttemptContent.title = String(
            localized: "\(unread ?? 1) unread messages",
            comment: "Default notification title"
        )
        if let unread = unread {
            bestAttemptContent.badge = NSNumber(integerLiteral: unread)
        }

        // Fetch the client_name:
        guard
            let devicesJson = bestAttemptContent.userInfo["devices"] as? String,
            let devices = try? JSONDecoder().decode(
                [NotificationDevice].self,
                from: devicesJson.data(using: .utf8)!
            ),
            let clientName = devices.first?.data.client_name
        else {
            bestAttemptContent.title = "Unable to find client name"
            os_log(
                "[FluffyChatPushHelper] No client_name found in Push Notification!"
            )
            contentHandler(bestAttemptContent)
            return
        }

        // Open database:
        guard let key = getDatabaseKey() else {
            bestAttemptContent.title = "Unable to get database key"
            os_log("[FluffyChatPushHelper] Unable to get database key!")
            contentHandler(bestAttemptContent)
            return
        }
        guard let path = getDatabasePath(clientName: clientName) else {
            bestAttemptContent.title = "Unable to get database path"
            os_log("[FluffyChatPushHelper] Unable to get database path!")
            contentHandler(bestAttemptContent)
            return
        }
        guard let database = getDatabase(key: key, path: path) else {
            // getDatabase already logged the concrete SQLite error
            bestAttemptContent.title = "Unable to open database!"
            bestAttemptContent.body = path
            contentHandler(bestAttemptContent)
            return
        }

        // Get room name:
        var roomName = getRoomNameFromDatabase(
            database: database,
            roomId: roomId
        )

        // Fall back to room heroes if no explicit room name
        if roomName == nil {
            bestAttemptContent.title = "Room name is null!"
            if let heroes = getRoomheroesFromDatabase(
                database: database,
                roomId: roomId
            ) {
                if !heroes.isEmpty {
                    roomName =
                        roomName
                        ?? heroes.map { hero in
                            hero.content.displayname
                                ?? String(localized: "FluffyChat User")
                        }.joined(separator: ", ")
                } else {
                    bestAttemptContent.title = "Heroes list is empty!"
                    roomName = roomName ?? String(localized: "Empty chat")
                }
            } else {
                bestAttemptContent.title = "No heroes found!"
                roomName = roomName ?? String(localized: "New chat")
            }
        }

        if let roomName = roomName {
            bestAttemptContent.title = roomName
        }

        contentHandler(bestAttemptContent)

    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler,
            let bestAttemptContent = bestAttemptContent
        {
            contentHandler(bestAttemptContent)
        }
    }

    func getDatabaseKey() -> String? {
        // Fetch database key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "flutter_secure_storage_service",
            kSecAttrAccount as String: "database_password",
            kSecReturnData as String: true,
            kSecAttrAccessGroup as String: "group.im.fluffychat.app",
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
            let data = item as? Data,
            let key = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return key
    }

    func getDatabasePath(clientName: String) -> String? {
        guard
            let libraryPath = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.im.fluffychat.app"
            )
        else { return nil }

        // Use URL.path (not path()) — path(percentEncoded:) can break FileManager paths.
        return libraryPath.appendingPathComponent("\(clientName).sqlite").path
    }

    func getDatabase(key: String, path: String) -> FMDatabase? {
        guard FileManager.default.fileExists(atPath: path) else { return nil }

        let database = FMDatabase(path: path)
        // SQLCipher + WAL cannot reliably open with SQLITE_OPEN_READONLY.
        // SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX
        let flags: Int32 = 0x0000_0002 | 0x0001_0000
        guard database.open(withFlags: flags) else {
            os_log(
                "[FluffyChatPushHelper] sqlite open failed: %{public}@",
                database.lastErrorMessage()
            )
            return nil
        }

        // Match Flutter / matrix-dart-sdk: PRAGMA KEY='…' (passphrase), not raw key bytes.
        let escapedKey = key.replacingOccurrences(of: "'", with: "''")
        guard database.executeStatements("PRAGMA key = '\(escapedKey)';") else {
            os_log(
                "[FluffyChatPushHelper] PRAGMA key failed: %{public}@",
                database.lastErrorMessage()
            )
            database.close()
            return nil
        }

        guard database.goodConnection else {
            os_log(
                "[FluffyChatPushHelper] bad connection after key: %{public}@",
                database.lastErrorMessage()
            )
            database.close()
            return nil
        }

        return database
    }

    func getUserFromDatabase(
        database: FMDatabase,
        userId: String,
        roomId: String
    ) -> UserEventJson? {
        do {
            let roomMemberDatabaseKey = [roomId, userId].joined(separator: "|")
            let roomMemberResult = try database.executeQuery(
                "SELECT * FROM box_room_members WHERE k=?",
                values: [roomMemberDatabaseKey]
            )
            if roomMemberResult.next(),
                let event = roomMemberResult.string(forColumn: "v")
            {
                let userEvent = try! JSONDecoder().decode(
                    UserEventJson.self,
                    from: event.data(using: .utf8)!
                )
                return userEvent
            }
        } catch {
            os_log(
                "[FluffyChatPushHelper] DB query failed: %{public}@",
                log: .default,
                type: .error,
                error.localizedDescription
            )
        }
        return nil
    }

    func getRoomNameFromDatabase(database: FMDatabase, roomId: String)
        -> String?
    {
        do {
            // Database key format: "roomId|eventType|stateKey"
            let roomNameDatabaseKey = [roomId, "m.room.name", ""].joined(
                separator: "|"
            )
            let roomNameResult = try database.executeQuery(
                "SELECT * FROM box_preload_room_states WHERE k=?",
                values: [roomNameDatabaseKey]
            )
            if roomNameResult.next(),
                let event = roomNameResult.string(forColumn: "v")
            {
                let roomNameEvent = try! JSONDecoder().decode(
                    RoomNameEventJson.self,
                    from: event.data(using: .utf8)!
                )
                if let name = roomNameEvent.content.name, !name.isEmpty {
                    return name
                }
            }
        } catch {
            os_log(
                "[FluffyChatPushHelper] DB query failed: %{public}@",
                log: .default,
                type: .error,
                error.localizedDescription
            )
        }
        return nil
    }

    func getRoomheroesFromDatabase(database: FMDatabase, roomId: String)
        -> [UserEventJson]?
    {
        do {
            let roomResult = try database.executeQuery(
                "SELECT * FROM box_rooms WHERE k=?",
                values: [roomId]
            )
            if roomResult.next(),
                let roomJson = roomResult.string(forColumn: "v")
            {
                let room = try JSONDecoder().decode(
                    RoomJson.self,
                    from: roomJson.data(using: .utf8)!
                )
                let heroes = room.summary.heroes.map { hero in
                    return getUserFromDatabase(
                        database: database,
                        userId: hero,
                        roomId: roomId
                    )
                }.compactMap { $0 }
                return heroes
            } else {
                return nil
            }
        } catch is DecodingError {
            return []
        } catch {
            os_log(
                "[FluffyChatPushHelper] DB query failed: %{public}@",
                log: .default,
                type: .error,
                error.localizedDescription
            )
        }
        return []
    }
}

struct UserEventJson: Decodable {
    struct UserEventContentJson: Decodable {
        let displayname: String?
        let avatar_url: String?
    }
    let content: UserEventContentJson
}

struct RoomNameEventJson: Decodable {
    struct RoomNameEventContentJson: Decodable {
        let name: String?
    }
    let content: RoomNameEventContentJson
}

struct RoomJson: Decodable {
    struct RoomSummaryJson: Decodable {
        let heroes: [String]
        enum CodingKeys: String, CodingKey {
            case heroes = "m.heroes"
        }
    }
    let summary: RoomSummaryJson
}

struct NotificationDevice: Decodable {
    struct NotificationDeviceData: Decodable {
        let client_name: String?
    }
    let data: NotificationDeviceData
}
struct NotificationCounts: Decodable {
    let unread: Int?
}
