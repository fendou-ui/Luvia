//
//  Gm_MessageModel.swift
//  Gaming

import Foundation

struct Gm_MessageModel: Codable {
    var gm_id: String
    var gm_avatar: String
    var gm_name: String
    var gm_content: String
    var gm_time: String
    var gm_userId: String
    
    static func gm_mockList() -> [Gm_MessageModel] {
        return [
            Gm_MessageModel(gm_id: "msg001", gm_avatar: "Gm_deafult_header", gm_name: "Janiz", gm_content: "Hello, I'm Janiz~", gm_time: "12:08PM", gm_userId: "10000000001"),
            Gm_MessageModel(gm_id: "msg002", gm_avatar: "Gm_deafult_header", gm_name: "Luna", gm_content: "Let's play together!", gm_time: "11:30AM", gm_userId: "10000000002"),
            Gm_MessageModel(gm_id: "msg003", gm_avatar: "Gm_deafult_header", gm_name: "Mia", gm_content: "GG! That was fun~", gm_time: "10:15AM", gm_userId: "10000000003"),
            Gm_MessageModel(gm_id: "msg004", gm_avatar: "Gm_deafult_header", gm_name: "Sophie", gm_content: "Are you online?", gm_time: "Yesterday", gm_userId: "10000000004"),
            Gm_MessageModel(gm_id: "msg005", gm_avatar: "Gm_deafult_header", gm_name: "Emma", gm_content: "Check out my new stream!", gm_time: "Yesterday", gm_userId: "10000000005")
        ]
    }
}
