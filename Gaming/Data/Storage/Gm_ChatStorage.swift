//
//  Gm_ChatStorage.swift
//  Gaming

import Foundation

struct Gm_ChatUser: Codable {
    var gm_userId: String
    var gm_name: String
    var gm_avatar: String
    var gm_lastMessage: String
    var gm_lastTime: String
}

class Gm_ChatStorage {
    
    static let shared = Gm_ChatStorage()
    
    private let gm_key = "gm_chat_messages"
    private let gm_userKey = "gm_chat_users"
    
    private init() {}
    
    // MARK: - Chat Users
    
    // 获取所有聊天用户
    func gm_getChatUsers() -> [Gm_ChatUser] {
        guard let data = UserDefaults.standard.data(forKey: gm_userKey) else {
            return []
        }
        
        do {
            let users = try JSONDecoder().decode([Gm_ChatUser].self, from: data)
            return users
        } catch {
            return []
        }
    }
    
    // 保存聊天用户
    func gm_saveChatUser(userId: String, name: String, avatar: String, lastMessage: String, lastTime: String) {
        var users = gm_getChatUsers()
        
        // 移除已存在的用户
        users.removeAll { $0.gm_userId == userId }
        
        // 添加到最前面
        let user = Gm_ChatUser(gm_userId: userId, gm_name: name, gm_avatar: avatar, gm_lastMessage: lastMessage, gm_lastTime: lastTime)
        users.insert(user, at: 0)
        
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: gm_userKey)
        } catch {
            print("gm_save_chat_user_error: \(error)")
        }
    }
    
    // 移除聊天用户
    func gm_removeChatUser(userId: String) {
        var users = gm_getChatUsers()
        users.removeAll { $0.gm_userId == userId }
        
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: gm_userKey)
        } catch {
            print("gm_remove_chat_user_error: \(error)")
        }
    }
    
    // MARK: - Chat Messages
    
    // 获取某个用户的聊天记录
    func gm_getMessages(userId: String) -> [Gm_ChatMessage] {
        guard let data = UserDefaults.standard.data(forKey: "\(gm_key)_\(userId)") else {
            return []
        }
        
        do {
            let messages = try JSONDecoder().decode([Gm_ChatMessage].self, from: data)
            return messages
        } catch {
            return []
        }
    }
    
    // 保存某个用户的聊天记录
    func gm_saveMessages(userId: String, messages: [Gm_ChatMessage]) {
        do {
            let data = try JSONEncoder().encode(messages)
            UserDefaults.standard.set(data, forKey: "\(gm_key)_\(userId)")
        } catch {
            print("gm_save_chat_error: \(error)")
        }
    }
    
    // 添加一条消息
    func gm_addMessage(userId: String, message: Gm_ChatMessage) {
        var messages = gm_getMessages(userId: userId)
        messages.append(message)
        gm_saveMessages(userId: userId, messages: messages)
    }
    
    // 清空某个用户的聊天记录
    func gm_clearMessages(userId: String) {
        UserDefaults.standard.removeObject(forKey: "\(gm_key)_\(userId)")
    }
}
