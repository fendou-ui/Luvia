//
//  Gm_IAPManager.swift
//  Gaming

import Foundation
import StoreKit

// 内购产品ID
struct Gm_IAPProducts {/// cskboibyenpgpmws
    static let gm_coins20 = "new_1000"
    static let gm_coins50 = "iupegqvtwyzimdbt"
    static let gm_coins100 = "pzatanvkndrydlgc"
    static let gm_coins200 = "ipyupjnsakxjptho"
    static let gm_coins500 = "hkshgidniqmwfnbt"
    static let gm_coins1000 = "icrjiyuggvpklyiy"
    static let gm_coins2000 = "rfppkdsjkefimbvq"
    
    static let gm_allProducts: Set<String> = [
        gm_coins20, gm_coins50, gm_coins100,
        gm_coins200, gm_coins500, gm_coins1000
    ]
}

protocol Gm_IAPManagerDelegate: AnyObject {
    func gm_iapProductsLoaded(_ products: [SKProduct])
    func gm_iapPurchaseSuccess(_ productId: String)
    func gm_iapPurchaseFailed(_ error: String)
    func gm_iapRestoreSuccess()
    func gm_iapRestoreFailed(_ error: String)
}

class Gm_IAPManager: NSObject {
    
    static let shared = Gm_IAPManager()
    
    weak var delegate: Gm_IAPManagerDelegate?
    
    private var gm_products: [SKProduct] = []
    private var gm_productRequest: SKProductsRequest?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - 加载产品
    
    func gm_loadProducts() {
        guard SKPaymentQueue.canMakePayments() else {
            delegate?.gm_iapPurchaseFailed("In-app purchases are not available")
            return
        }
        
        gm_productRequest?.cancel()
        gm_productRequest = SKProductsRequest(productIdentifiers: Gm_IAPProducts.gm_allProducts)
        gm_productRequest?.delegate = self
        gm_productRequest?.start()
    }
    
    // MARK: - 购买产品
    
    func gm_purchase(productId: String) {
        guard SKPaymentQueue.canMakePayments() else {
            delegate?.gm_iapPurchaseFailed("In-app purchases are not available")
            return
        }
        
        guard let product = gm_products.first(where: { $0.productIdentifier == productId }) else {
            delegate?.gm_iapPurchaseFailed("Product not found")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - 恢复购买
    
    func gm_restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - 获取产品
    
    func gm_getProduct(productId: String) -> SKProduct? {
        return gm_products.first(where: { $0.productIdentifier == productId })
    }
    
    func gm_getAllProducts() -> [SKProduct] {
        return gm_products
    }
    
    // MARK: - 格式化价格
    
    func gm_formatPrice(_ product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "$\(product.price)"
    }
}

// MARK: - SKProductsRequestDelegate

extension Gm_IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.gm_products = response.products
            self?.delegate?.gm_iapProductsLoaded(response.products)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.gm_iapPurchaseFailed(error.localizedDescription)
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension Gm_IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                gm_handlePurchased(transaction)
            case .failed:
                gm_handleFailed(transaction)
            case .restored:
                gm_handleRestored(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.gm_iapRestoreSuccess()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.gm_iapRestoreFailed(error.localizedDescription)
        }
    }
    
    // MARK: - 处理交易
    
    private func gm_handlePurchased(_ transaction: SKPaymentTransaction) {
        let productId = transaction.payment.productIdentifier
        
        // 发放金币
        gm_deliverCoins(productId: productId)
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.gm_iapPurchaseSuccess(productId)
        }
    }
    
    private func gm_handleFailed(_ transaction: SKPaymentTransaction) {
        var errorMsg = "Purchase failed"
        if let error = transaction.error as? SKError {
            switch error.code {
            case .paymentCancelled:
                errorMsg = "Purchase cancelled"
            case .paymentInvalid:
                errorMsg = "Invalid payment"
            case .paymentNotAllowed:
                errorMsg = "Payment not allowed"
            default:
                errorMsg = error.localizedDescription
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.gm_iapPurchaseFailed(errorMsg)
        }
    }
    
    private func gm_handleRestored(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // MARK: - 发放金币
    
    private func gm_deliverCoins(productId: String) {
        var coinsToAdd = 0
        
        switch productId {
        case Gm_IAPProducts.gm_coins20:
            coinsToAdd = 200
        case Gm_IAPProducts.gm_coins50:
            coinsToAdd = 500
        case Gm_IAPProducts.gm_coins100:
            coinsToAdd = 2000
        case Gm_IAPProducts.gm_coins200:
            coinsToAdd = 5000
        case Gm_IAPProducts.gm_coins500:
            coinsToAdd = 12000
        case Gm_IAPProducts.gm_coins1000:
            coinsToAdd = 49999
        default:
            break
        }
        
        if coinsToAdd > 0 {
            Gm_CoinsManager.shared.gm_addCoins(coinsToAdd)
        }
    }
}
