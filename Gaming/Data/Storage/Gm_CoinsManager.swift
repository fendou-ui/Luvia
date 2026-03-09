//
//  Gm_CoinsManager.swift
//  Gaming

import Foundation

class Gm_CoinsManager {
    
    static let shared = Gm_CoinsManager()
    
    private let gm_coinsKey = "gm_user_coins"
    
    // 金币变化通知
    static let gm_coinsDidChangeNotification = Notification.Name("gm_coinsDidChangeNotification")
    
    private init() {}
    
    // 获取当前金币数
    func gm_getCoins() -> Int {
        return UserDefaults.standard.integer(forKey: gm_coinsKey)
    }
    
    // 设置金币数
    func gm_setCoins(_ coins: Int) {
        UserDefaults.standard.set(coins, forKey: gm_coinsKey)
        gm_postNotification()
    }
    
    // 增加金币
    func gm_addCoins(_ amount: Int) {
        let current = gm_getCoins()
        gm_setCoins(current + amount)
    }
    
    // 消费金币
    func gm_spendCoins(_ amount: Int) -> Bool {
        let current = gm_getCoins()
        if current >= amount {
            gm_setCoins(current - amount)
            return true
        }
        return false
    }
    
    // 检查是否有足够金币
    func gm_hasEnoughCoins(_ amount: Int) -> Bool {
        return gm_getCoins() >= amount
    }
    
    // 发送通知
    private func gm_postNotification() {
        NotificationCenter.default.post(name: Gm_CoinsManager.gm_coinsDidChangeNotification, object: nil)
    }
}
