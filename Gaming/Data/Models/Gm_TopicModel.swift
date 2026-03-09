//
//  Gm_TopicModel.swift
//  Gaming

import Foundation

struct Gm_TopicModel {
    var gm_id: String
    var gm_userId: String
    var gm_avatar: String
    var gm_name: String
    var gm_content: String
    var gm_image: String
    var gm_isLiked: Bool
    var gm_category: String
    
    static func gm_mockList() -> [Gm_TopicModel] {
        return [
            Gm_TopicModel(
                gm_id: "t001",
                gm_userId: "u001",
                gm_avatar: "avatar_1",
                gm_name: "Janiz",
                gm_content: "I'm so lucky to have witnessed such a wonderful match!",
                gm_image: "topic_1",
                gm_isLiked: false,
                gm_category: "MOBA"
            ),
            Gm_TopicModel(
                gm_id: "t002",
                gm_userId: "u002",
                gm_avatar: "avatar_2",
                gm_name: "Janiz",
                gm_content: "I'm so lucky to have witnessed such a wonderful match!",
                gm_image: "topic_2",
                gm_isLiked: true,
                gm_category: "FPS"
            ),
            Gm_TopicModel(
                gm_id: "t003",
                gm_userId: "u003",
                gm_avatar: "avatar_3",
                gm_name: "Alex",
                gm_content: "Amazing gameplay today!",
                gm_image: "topic_1",
                gm_isLiked: false,
                gm_category: "RTS"
            )
        ]
    }
    
    static func gm_mockListByCategory(_ category: String) -> [Gm_TopicModel] {
        switch category {
        case "MOBA":
            return [
                Gm_TopicModel(gm_id: "m001", gm_userId: "u001", gm_avatar: "moba_uu01", gm_name: "Janiz", gm_content: "The Enlightenment After All-night Ranked", gm_image: "topis_moba_3586", gm_isLiked: false, gm_category: "MOBA"),
                Gm_TopicModel(gm_id: "m002", gm_userId: "u002", gm_avatar: "moba_uu02", gm_name: "Luna", gm_content: "Got My GF Into the Game, Now She's Addicted", gm_image: "topis_moba_3787", gm_isLiked: true, gm_category: "MOBA"),
                Gm_TopicModel(gm_id: "m003", gm_userId: "u003", gm_avatar: "moba_uu03", gm_name: "Alex", gm_content: "From “clueless” to “getting there”, thanks for all those nights. On to the next 1000.", gm_image: "topis_moba_901", gm_isLiked: false, gm_category: "MOBA")
            ]
        case "FPS":
            return [
                Gm_TopicModel(gm_id: "f001", gm_userId: "u004", gm_avatar: "fps_vv01", gm_name: "Mike", gm_content: "New Mousepad, Feeling Godlike \nPlacebo? Maybe. Happy? Definitely.", gm_image: "fps_902", gm_isLiked: true, gm_category: "FPS"),
                Gm_TopicModel(gm_id: "f002", gm_userId: "u005", gm_avatar: "fps_vv02", gm_name: "Sarah", gm_content: "Met My Foreign Teammate IRL!", gm_image: "fps_369", gm_isLiked: false, gm_category: "FPS")
            ]
        case "RTS":
            return [
                Gm_TopicModel(gm_id: "r001", gm_userId: "u006", gm_avatar: "Rts_kk01", gm_name: "Tom", gm_content: "A Must-Watch Series for All RTS Players", gm_image: "rts_2359", gm_isLiked: false, gm_category: "RTS"),
                Gm_TopicModel(gm_id: "r002", gm_userId: "u007", gm_avatar: "Rts_kk02", gm_name: "Emma", gm_content: "Got a Fish Tank, Realized It's Like Macro", gm_image: "rts_906", gm_isLiked: true, gm_category: "RTS")
            ]
        case "Competitive":
            return [
                Gm_TopicModel(gm_id: "c001", gm_userId: "u008", gm_avatar: "comp_tiv01", gm_name: "Pro", gm_content: "Watching Esports is More Nerve-Wracking Than Playing", gm_image: "comp_1547", gm_isLiked: true, gm_category: "Competitive"),
                Gm_TopicModel(gm_id: "c002", gm_userId: "u009", gm_avatar: "comp_tiv02", gm_name: "Gamer", gm_content: "Whether stomping or getting stomped, end with “GG WP”. The strong aren't arrogant, the defeated keep grace. That's sportsmanship.", gm_image: "comp_1891", gm_isLiked: false, gm_category: "Competitive")
            ]
        default:
            return gm_mockList()
        }
    }
}
