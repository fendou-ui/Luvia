//
//  Gm_GamerModel.swift
//  Gaming

import Foundation

struct Gm_GamerModel: Codable {
    var gm_id: String
    var gm_name: String
    var gm_age: Int
    var gm_score: Int
    var gm_tag: String
    var gm_desc: String
    var gm_cover: String
    var gm_category: String
    var gm_isOnline: Bool
    
    // 年龄图片
    var gm_ageImage: String {
        return "Gm_age\(gm_age)"
    }
    
    // 标签图片
    var gm_tagImage: String {
        return "Gm_\(gm_tag)"
    }
    
    // MARK: - Mock
    
    static func gm_mockList() -> [Gm_GamerModel] {
        return [
            Gm_GamerModel(gm_id: "1", gm_name: "Vera", gm_age: 29, gm_score: 99, gm_tag: "Calm & Analytical", gm_desc: "Former caster. Excels at drafting and teamfight analysis. She uses data to predict outcomes.", gm_cover: "Vera_covert", gm_category: "MOBA", gm_isOnline: true),
            Gm_GamerModel(gm_id: "2", gm_name: "Mirage", gm_age: 24, gm_score: 88, gm_tag: "Cunning & Agile", gm_desc: "Master of small-scale fights. Her creed: create local numerical advantages.", gm_cover: "Mirage_covert", gm_category: "MOBA", gm_isOnline: true),
            Gm_GamerModel(gm_id: "3", gm_name: "Stella", gm_age: 26, gm_score: 95, gm_tag: "Strict & Meticulous", gm_desc: "Focuses on laning details. Helps you dominate your opponent through trading and wave control.", gm_cover: "Stella_covert", gm_category: "MOBA", gm_isOnline: false),
            
            Gm_GamerModel(gm_id: "4", gm_name: "Anvil", gm_age: 22, gm_score: 76, gm_tag: "Steadfast & Reliable", gm_desc: "Believes in the art of defense. Masters cover and crossfire to lock down sites.", gm_cover: "Anvil_covert", gm_category: "FPS", gm_isOnline: true),
            Gm_GamerModel(gm_id: "5", gm_name: "Spark", gm_age: 27, gm_score: 92, gm_tag: "Aggressive & Fiery", gm_desc: "A relentless aggressor. Excels at intercepting rotations and setting up deadly ambushes.", gm_cover: "Spark_covert", gm_category: "FPS", gm_isOnline: true),
            
            Gm_GamerModel(gm_id: "6", gm_name: "Nexus", gm_age: 23, gm_score: 85, gm_tag: "Curious & Visionary", gm_desc: "Obsessed with tech progression. Believes victory belongs to the civilization with future tech.", gm_cover: "Nexus_covert", gm_category: "RTS", gm_isOnline: false),
            Gm_GamerModel(gm_id: "7", gm_name: "Phalanx", gm_age: 25, gm_score: 91, gm_tag: "Orderly & Precise", gm_desc: "Believes formation is power. Masters unit positioning to win engagements with minimal losses.", gm_cover: "Phalanx_covert", gm_category: "RTS", gm_isOnline: true),
            
            Gm_GamerModel(gm_id: "8", gm_name: "Champion", gm_age: 21, gm_score: 78, gm_tag: "Inspiring & Motivating", gm_desc: "Focuses on competitive mindset: pressure management, concentration, and post-match analysis.", gm_cover: "Champion_covert", gm_category: "Competitive", gm_isOnline: true),
            Gm_GamerModel(gm_id: "9", gm_name: "Ada", gm_age: 28, gm_score: 97, gm_tag: "Resourceful & Flexible", gm_desc: "Has no fixed playbook. Analyzes opponents and meta in real-time to generate counter-strategies.", gm_cover: "Ada_covert", gm_category: "Competitive", gm_isOnline: false)
        ]
    }
}
