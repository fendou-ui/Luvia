//
//  Gm_BlockManager.swift
//  Gaming

import Foundation

struct Gm_BlockedUser: Codable {
    var gm_userId: String
    var gm_name: String
    var gm_avatar: String
}

class Gm_BlockManager {
    
    static let shared = Gm_BlockManager()
    
    private let gm_key = "gm_blocked_users"
    private let gm_detailKey = "gm_blocked_users_detail"
    
    private init() {}
    
    // 获取黑名单ID列表
    func gm_getBlockedUserIds() -> [String] {
        return UserDefaults.standard.stringArray(forKey: gm_key) ?? []
    }
    
    // 获取黑名单详情列表
    func gm_getBlockedUsers() -> [Gm_BlockedUser] {
        guard let data = UserDefaults.standard.data(forKey: gm_detailKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Gm_BlockedUser].self, from: data)
        } catch {
            return []
        }
    }
    
    // 添加用户到黑名单
    func gm_blockUser(_ userId: String, name: String = "User", avatar: String = "Gm_deafult_cell") {
        var ids = gm_getBlockedUserIds()
        if !ids.contains(userId) {
            ids.append(userId)
            UserDefaults.standard.set(ids, forKey: gm_key)
            
            var users = gm_getBlockedUsers()
            users.append(Gm_BlockedUser(gm_userId: userId, gm_name: name, gm_avatar: avatar))
            gm_saveBlockedUsers(users)
        }
    }
    
    // 从黑名单移除用户
    func gm_unblockUser(_ userId: String) {
        var ids = gm_getBlockedUserIds()
        ids.removeAll { $0 == userId }
        UserDefaults.standard.set(ids, forKey: gm_key)
        
        var users = gm_getBlockedUsers()
        users.removeAll { $0.gm_userId == userId }
        gm_saveBlockedUsers(users)
    }
    
    // 检查用户是否在黑名单
    func gm_isBlocked(_ userId: String) -> Bool {
        return gm_getBlockedUserIds().contains(userId)
    }
    
    // 保存黑名单详情
    private func gm_saveBlockedUsers(_ users: [Gm_BlockedUser]) {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: gm_detailKey)
        } catch {
            print("gm_save_blocked_error: \(error)")
        }
    }
}
