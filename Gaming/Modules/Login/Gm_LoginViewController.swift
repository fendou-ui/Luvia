//
//  Gm_LoginViewController.swift
//  Gaming
//
//  登录页面 - 背景图 + 登录按钮 + 协议

import UIKit
import SnapKit
import ZKProgressHUD

class Gm_LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// 背景图
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_online")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    /// 登录按钮
    private lazy var gm_loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_get"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(gm_loginAction), for: .touchUpInside)
        return btn
    }()
    
    /// 协议勾选框
    private lazy var gm_checkBox: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(gm_toggleCheck), for: .touchUpInside)
        return btn
    }()
    
    /// 协议文本
    private lazy var gm_agreementLb: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.isUserInteractionEnabled = true
        
        let fullText = "I have read and agree to the Terms of Service and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // 基础样式
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ]
        attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: fullText.count))
        
        // Terms of Service 高亮
        if let range = fullText.range(of: "Terms of Service") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .foregroundColor: UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        // Privacy Policy 高亮
        if let range = fullText.range(of: "Privacy Policy") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .foregroundColor: UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        
        lb.attributedText = attributedString
        return lb
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gm_setupUI()
        gm_setupGestures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(gm_bgIv)
        view.addSubview(gm_loginBtn)
        view.addSubview(gm_checkBox)
        view.addSubview(gm_agreementLb)
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_loginBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(64)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        gm_checkBox.snp.makeConstraints { make in
            make.left.equalTo(gm_loginBtn)
            make.top.equalTo(gm_loginBtn.snp.bottom).offset(16)
            make.width.height.equalTo(20)
        }
        
        gm_agreementLb.snp.makeConstraints { make in
            make.left.equalTo(gm_checkBox.snp.right).offset(8)
            make.centerY.equalTo(gm_checkBox)
            make.right.equalTo(gm_loginBtn)
        }
    }
    
    private func gm_setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_agreementTapped(_:)))
        gm_agreementLb.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc private func gm_loginAction() {
        guard gm_checkBox.isSelected else {
            gm_showAgreementAlert()
            return
        }
        
        // 显示加载动画
        ZKProgressHUD.show()
        
        // 模拟登录延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            ZKProgressHUD.dismiss()
            
            // 登录成功，进入引导页
            let guideVC = Gm_GuideViewController()
            guideVC.modalPresentationStyle = .fullScreen
            self?.present(guideVC, animated: true)
        }
    }
    
    @objc private func gm_toggleCheck() {
        gm_checkBox.isSelected.toggle()
    }
    
    @objc private func gm_agreementTapped(_ gesture: UITapGestureRecognizer) {
        guard let text = gm_agreementLb.text else { return }
        
        let userAgreementRange = (text as NSString).range(of: "Terms of Service")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        let tapLocation = gesture.location(in: gm_agreementLb)
        let textStorage = NSTextStorage(attributedString: gm_agreementLb.attributedText!)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: gm_agreementLb.bounds.size)
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(characterIndex, userAgreementRange) {
            gm_showUserAgreement()
        } else if NSLocationInRange(characterIndex, privacyRange) {
            gm_showPrivacyPolicy()
        }
    }
    
    // MARK: - Private Methods
    
    private func gm_showAgreementAlert() {
        let alert = UIAlertController(title: "Notice", message: "Please read and agree to the Terms of Service and Privacy Policy", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func gm_showUserAgreement() {
        print("gm_nav: 打开用户协议")
        // TODO: 跳转用户协议页面
    }
    
    private func gm_showPrivacyPolicy() {
        print("gm_nav: 打开隐私政策")
        // TODO: 跳转隐私政策页面
    }
}
