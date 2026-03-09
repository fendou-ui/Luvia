//
//  Gm_FeedModel.swift
//  Gaming

import Foundation

struct Gm_FeedModel: Codable {
    var gm_id: String
    var gm_cover: String
    var gm_title: String
    var gm_avatar: String
    var gm_name: String
    var gm_userId: String
    var gm_isLiked: Bool
    var gm_videoUrl: String
    
    static func gm_mockList() -> [Gm_FeedModel] {
        return [
            Gm_FeedModel(gm_id: "10086001", gm_cover: "game39fa", gm_title: "It's truly an amazing", gm_avatar: "moba_uu01", gm_name: "Janiz", gm_userId: "10000000001", gm_isLiked: false, gm_videoUrl: "game39fa"),
            Gm_FeedModel(gm_id: "10086004", gm_cover: "gamedcd2", gm_title: "Check out my new setup", gm_avatar: "moba_uu02", gm_name: "Mia", gm_userId: "10000000004", gm_isLiked: true, gm_videoUrl: "gamedcd2"),
            Gm_FeedModel(gm_id: "10086005", gm_cover: "gamet4", gm_title: "Epic win last night!", gm_avatar: "moba_uu03", gm_name: "Sophie", gm_userId: "10000000005", gm_isLiked: false, gm_videoUrl: "gamet4"),
            Gm_FeedModel(gm_id: "10086002", gm_cover: "game720w", gm_title: "It's truly an amazing", gm_avatar: "fps_vv01", gm_name: "Janiz", gm_userId: "10000000002", gm_isLiked: true, gm_videoUrl: "game720w"),
            Gm_FeedModel(gm_id: "10086003", gm_cover: "game1664", gm_title: "Best gaming moment ever", gm_avatar: "fps_vv02", gm_name: "Luna", gm_userId: "10000000003", gm_isLiked: false, gm_videoUrl: "game1664"),
            Gm_FeedModel(gm_id: "10086006", gm_cover: "game95845", gm_title: "New game review coming", gm_avatar: "Rts_kk01", gm_name: "Emma", gm_userId: "10000000006", gm_isLiked: false, gm_videoUrl: "game95845")
        ]
    }
}
