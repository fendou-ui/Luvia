//
//  Gm_RechargeViewController.swift
//  Gaming

import UIKit
import SnapKit
import StoreKit
import ZKProgressHUD

class Gm_RechargeViewController: UIViewController {
    
    // MARK: - Data
    
    private var gm_rechargeItems: [(coins: String, price: String, productId: String)] = [
        ("200", "$0.99", Gm_IAPProducts.gm_coins20),
        ("500", "$1.99", Gm_IAPProducts.gm_coins50),
        ("2000", "$4.99", Gm_IAPProducts.gm_coins100),
        ("5000", "$9.99", Gm_IAPProducts.gm_coins200),
        ("12000", "$19.99", Gm_IAPProducts.gm_coins500),
        ("49999", "$39.99", Gm_IAPProducts.gm_coins1000)
    ]
    
    private var gm_selectedIndex: Int = 0
    
    // MARK: - UI
    
    private lazy var gm_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.backgroundColor = UIColor(red: 232/255, green: 147/255, blue: 255/255, alpha: 1.0)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(gm_backAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
        lb.text = "Recharge"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_coinsView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var gm_coinsBgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Profile_coins")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var gm_coinsLb: UILabel = {
        let lb = UILabel()
        lb.text = "My coins"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_coinsCountLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(Gm_RechargeCell.self, forCellWithReuseIdentifier: "Gm_RechargeCell")
        return cv
    }()
    
    private lazy var gm_continueBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.setBackgroundImage(UIImage(named: "Gm_post"), for: .normal)
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_continueAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupIAP()
        gm_updateCoinsDisplay()
        gm_addObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_coinsView)
        gm_coinsView.addSubview(gm_coinsBgIv)
        gm_coinsView.addSubview(gm_coinsLb)
        gm_coinsView.addSubview(gm_coinsCountLb)
        view.addSubview(gm_collectionView)
        view.addSubview(gm_continueBtn)
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_coinsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_backBtn.snp.bottom).offset(24)
            make.height.equalTo(102)
        }
        
        gm_coinsBgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_coinsLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(24)
        }
        
        gm_coinsCountLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.top.equalTo(gm_coinsLb.snp.bottom).offset(6)
        }
        
        gm_continueBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(60)
        }
        
        gm_collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_coinsView.snp.bottom).offset(16)
            make.bottom.equalTo(gm_continueBtn.snp.top).offset(-20)
        }
    }
    
    private func gm_setupIAP() {
        Gm_IAPManager.shared.delegate = self
        Gm_IAPManager.shared.gm_loadProducts()
    }
    
    private func gm_addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(gm_coinsDidChange),
            name: Gm_CoinsManager.gm_coinsDidChangeNotification,
            object: nil
        )
    }
    
    private func gm_updateCoinsDisplay() {
        let coins = Gm_CoinsManager.shared.gm_getCoins()
        gm_coinsCountLb.text = "\(coins)"
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_continueAction() {
        guard gm_selectedIndex < gm_rechargeItems.count else { return }
        
        let item = gm_rechargeItems[gm_selectedIndex]
        let productId = item.productId
        
        ZKProgressHUD.show()
        Gm_IAPManager.shared.gm_purchase(productId: productId)
    }
    
    @objc private func gm_coinsDidChange() {
        gm_updateCoinsDisplay()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension Gm_RechargeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gm_rechargeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gm_RechargeCell", for: indexPath) as! Gm_RechargeCell
        let item = gm_rechargeItems[indexPath.item]
        cell.gm_config(coins: item.coins, price: item.price, isSelected: indexPath.item == gm_selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32 - 24) / 3
        return CGSize(width: width, height: 134)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gm_selectedIndex = indexPath.item
        collectionView.reloadData()
    }
}

// MARK: - Gm_IAPManagerDelegate

extension Gm_RechargeViewController: Gm_IAPManagerDelegate {
    
    func gm_iapProductsLoaded(_ products: [SKProduct]) {
        // 更新价格显示
        for product in products {
            let price = Gm_IAPManager.shared.gm_formatPrice(product)
            
            for (index, item) in gm_rechargeItems.enumerated() {
                if item.productId == product.productIdentifier {
                    gm_rechargeItems[index].price = price
                }
            }
        }
        gm_collectionView.reloadData()
    }
    
    func gm_iapPurchaseSuccess(_ productId: String) {
        ZKProgressHUD.dismiss()
        ZKProgressHUD.showSuccess("Purchase successful!")
        gm_updateCoinsDisplay()
    }
    
    func gm_iapPurchaseFailed(_ error: String) {
        ZKProgressHUD.dismiss()
        if error != "Purchase cancelled" {
            ZKProgressHUD.showError(error)
        }
    }
    
    func gm_iapRestoreSuccess() {
        ZKProgressHUD.dismiss()
        ZKProgressHUD.showSuccess("Restore successful!")
    }
    
    func gm_iapRestoreFailed(_ error: String) {
        ZKProgressHUD.dismiss()
        ZKProgressHUD.showError(error)
    }
}
