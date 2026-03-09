//
//  Gm_RechargeCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_RechargeCell: UICollectionViewCell {
    
    private lazy var gm_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        return v
    }()
    
    private lazy var gm_coinIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_zuan")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_coinsLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_priceBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.8)
        v.layer.cornerRadius = 12
        return v
    }()
    
    private lazy var gm_priceLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gm_setupUI() {
        contentView.addSubview(gm_containerView)
        gm_containerView.addSubview(gm_coinIv)
        gm_containerView.addSubview(gm_coinsLb)
        gm_containerView.addSubview(gm_priceBgView)
        gm_priceBgView.addSubview(gm_priceLb)
        
        gm_containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_coinIv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        gm_coinsLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gm_coinIv.snp.bottom).offset(8)
        }
        
        gm_priceBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.width.equalTo(70)
            make.height.equalTo(24)
        }
        
        gm_priceLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func gm_config(coins: String, price: String, isSelected: Bool) {
        gm_coinsLb.text = coins
        gm_priceLb.text = price
        
        if isSelected {
            gm_containerView.backgroundColor = UIColor(red: 232/255, green: 147/255, blue: 255/255, alpha: 1.0)
            gm_containerView.layer.borderColor = UIColor.white.cgColor
            gm_containerView.layer.borderWidth = 2
            gm_priceBgView.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 100/255, alpha: 1.0)
            gm_priceLb.textColor = UIColor(red: 100/255, green: 50/255, blue: 0/255, alpha: 1.0)
        } else {
            gm_containerView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
            gm_containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            gm_containerView.layer.borderWidth = 1
            gm_priceBgView.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.8)
            gm_priceLb.textColor = .white
        }
    }
}
