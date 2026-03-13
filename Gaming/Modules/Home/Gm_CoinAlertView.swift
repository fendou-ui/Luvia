//
//  Gm_CoinAlertView.swift
//  Gaming

import UIKit
import SnapKit

class Gm_CoinAlertView: UIView {
    
    // MARK: - Callbacks
    
    var gm_noCallback: (() -> Void)?
    var gm_yesCallback: (() -> Void)?
    
    var gm_titleText: String? {
        didSet {
            gm_contentLb.text = gm_titleText
        }
    }
    
    // MARK: - UI
    
    private lazy var gm_overlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    }()
    
    private lazy var gm_cardView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_coins_bg")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // 顶部标题（仅plain模式显示）
    private lazy var gm_headerLb: UILabel = {
        let lb = UILabel()
        lb.text = "Notice"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1.0)
        lb.textAlignment = .center
        lb.isHidden = true
        return lb
    }()
    
    private lazy var gm_contentLb: UILabel = {
        let lb = UILabel()
        lb.text = "Are you sure you want to spend 99\ncoins to unlock this AI?"
        lb.font = UIFont(name: "Lexend-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        lb.textColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1.0)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var gm_noBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_NO"), for: .normal)
        btn.addTarget(self, action: #selector(gm_noAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_yesBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_YES"), for: .normal)
        btn.addTarget(self, action: #selector(gm_yesAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init
    
    /// useBgImage: true = 使用Gm_coins_bg背景图(金币弹窗), false = 白色背景+标题(隐私弹窗)
    init(useBgImage: Bool = true) {
        super.init(frame: .zero)
        gm_setupUI(useBgImage: useBgImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gm_setupUI(useBgImage: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI(useBgImage: Bool) {
        addSubview(gm_overlayView)
        addSubview(gm_cardView)
        
        if useBgImage {
            gm_cardView.addSubview(gm_bgIv)
        } else {
            gm_cardView.backgroundColor = UIColor(red: 0x89/255.0, green: 0xBE/255.0, blue: 0xEE/255.0, alpha: 1.0)
            gm_cardView.layer.cornerRadius = 16
        }
        
        gm_cardView.addSubview(gm_headerLb)
        gm_cardView.addSubview(gm_contentLb)
        gm_cardView.addSubview(gm_noBtn)
        gm_cardView.addSubview(gm_yesBtn)
        
        gm_overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if useBgImage {
            // 金币弹窗：固定高度
            gm_cardView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(326)
                make.height.equalTo(267)
            }
            
            gm_bgIv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            gm_contentLb.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(95)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        } else {
            // 隐私弹窗：自适应高度，白色背景
            gm_headerLb.isHidden = false
            gm_contentLb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            gm_contentLb.textAlignment = .left
            
            gm_cardView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(326)
            }
            
            gm_headerLb.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            gm_contentLb.snp.makeConstraints { make in
                make.top.equalTo(gm_headerLb.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
        }
        
        gm_noBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(27)
            make.top.equalTo(gm_contentLb.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-26)
            make.width.equalTo(129)
            make.height.equalTo(54)
        }
        
        gm_yesBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-27)
            make.bottom.equalToSuperview().offset(-26)
            make.width.equalTo(129)
            make.height.equalTo(54)
        }
        
        // Tap overlay to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_noAction))
        gm_overlayView.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc private func gm_noAction() {
        gm_dismiss()
        gm_noCallback?()
    }
    
    @objc private func gm_yesAction() {
        gm_dismiss()
        gm_yesCallback?()
    }
    
    // MARK: - Show / Dismiss
    
    func gm_show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.alpha = 0
        gm_cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            self.gm_cardView.transform = .identity
        }
    }
    
    private func gm_dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.gm_cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
