//
//  Gm_FollowStorage.swift
//  Gaming

import Foundation

struct Gm_FollowModel: Codable {
    var gm_id: String
    var gm_name: String
    var gm_avatar: String
}

class Gm_FollowStorage {
    
    static let shared = Gm_FollowStorage()
    
    private let gm_followingKey = "gm_following_list"
    
    static let gm_followDidChangeNotification = Notification.Name("gm_followDidChangeNotification")
    
    private init() {}
    
    // MARK: - Following
    
    func gm_getFollowingList() -> [Gm_FollowModel] {
        guard let data = UserDefaults.standard.data(forKey: gm_followingKey) else {
            return []
        }
        
        do {
            let list = try JSONDecoder().decode([Gm_FollowModel].self, from: data)
            return list
        } catch {
            return []
        }
    }
    
    func gm_saveFollowingList(_ list: [Gm_FollowModel]) {
        do {
            let data = try JSONEncoder().encode(list)
            UserDefaults.standard.set(data, forKey: gm_followingKey)
            gm_postNotification()
        } catch {
            print("gm_save_following_error: \(error)")
        }
    }
    
    func gm_addFollowing(_ model: Gm_FollowModel) {
        var list = gm_getFollowingList()
        if !list.contains(where: { $0.gm_id == model.gm_id }) {
            list.append(model)
            gm_saveFollowingList(list)
        }
    }
    
    func gm_removeFollowing(_ userId: String) {
        var list = gm_getFollowingList()
        list.removeAll { $0.gm_id == userId }
        gm_saveFollowingList(list)
    }
    
    func gm_isFollowing(_ userId: String) -> Bool {
        let list = gm_getFollowingList()
        return list.contains { $0.gm_id == userId }
    }
    
    func gm_getFollowingCount() -> Int {
        return gm_getFollowingList().count
    }
    
    // MARK: - Mock Data
    
    private func gm_mockFollowingList() -> [Gm_FollowModel] {
        return [
            Gm_FollowModel(gm_id: "1", gm_name: "Janiz", gm_avatar: "Gm_deafult_cell"),
            Gm_FollowModel(gm_id: "2", gm_name: "Janiz", gm_avatar: "Gm_deafult_cell"),
            Gm_FollowModel(gm_id: "3", gm_name: "Janiz", gm_avatar: "Gm_deafult_cell")
        ]
    }
    
    // MARK: - Notification
    
    private func gm_postNotification() {
        NotificationCenter.default.post(name: Gm_FollowStorage.gm_followDidChangeNotification, object: nil)
    }
}
