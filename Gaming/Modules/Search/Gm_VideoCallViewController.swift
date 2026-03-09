//
//  Gm_VideoCallViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_VideoCallViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_userId: String = ""
    var gm_userName: String = ""
    var gm_userAvatar: String = ""
    
    private var gm_isVoiceOn = false
    private var gm_isSpeakerOn = false
    private var gm_dotTimer: Timer?
    private var gm_currentDotIndex = 0
    
    // MARK: - UI
    
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
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
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_three_point"), for: .normal)
        btn.backgroundColor = UIColor(red: 232/255, green: 147/255, blue: 255/255, alpha: 1.0)
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(gm_moreAction), for: .touchUpInside)
        return btn
    }()
    
    // 右上角小窗口
    private lazy var gm_smallView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0)
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        return indicator
    }()
    
    // 三个点动画
    private lazy var gm_dotsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var gm_dots: [UIView] = []
    
    // 底部控制栏
    private lazy var gm_controlView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 40
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 255/255, green: 242/255, blue: 129/255, alpha: 1.0).cgColor,
            UIColor(red: 207/255, green: 56/255, blue: 224/255, alpha: 1.0).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    
    private lazy var gm_voiceBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "call_voice_end"), for: .normal)
        btn.addTarget(self, action: #selector(gm_voiceTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_speakerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "call_pao_end"), for: .normal)
        btn.addTarget(self, action: #selector(gm_speakerTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_endBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "call_end"), for: .normal)
        btn.addTarget(self, action: #selector(gm_endTapped), for: .touchUpInside)
        return btn
    }()
    
    // ActionBar
    private lazy var gm_maskView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_dismissActionBar))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    private lazy var gm_actionBar: Gm_ActionBarView = {
        let v = Gm_ActionBarView()
        v.gm_blockCallback = { [weak self] in
            self?.gm_handleBlock()
        }
        v.gm_reportCallback = { [weak self] in
            self?.gm_handleReport()
        }
        return v
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupData()
        gm_startDotAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gm_gradientLayer.frame = gm_controlView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        gm_dotTimer?.invalidate()
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_moreBtn)
        view.addSubview(gm_smallView)
        gm_smallView.addSubview(gm_loadingIndicator)
        view.addSubview(gm_dotsStackView)
        view.addSubview(gm_controlView)
        gm_controlView.layer.insertSublayer(gm_gradientLayer, at: 0)
        gm_controlView.addSubview(gm_voiceBtn)
        gm_controlView.addSubview(gm_speakerBtn)
        gm_controlView.addSubview(gm_endBtn)
        view.addSubview(gm_maskView)
        view.addSubview(gm_actionBar)
        
        // 创建三个点
        for _ in 0..<3 {
            let dot = UIView()
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            dot.layer.cornerRadius = 4
            gm_dots.append(dot)
            gm_dotsStackView.addArrangedSubview(dot)
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(8)
            }
        }
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(gm_backBtn)
            make.width.height.equalTo(40)
        }
        
        gm_smallView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_moreBtn.snp_bottomMargin).offset(43)
            make.width.equalTo(120)
            make.height.equalTo(160)
        }
        
        gm_loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        gm_dotsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(gm_controlView.snp.top).offset(-20)
        }
        
        gm_controlView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.width.equalTo(320)
            make.height.equalTo(80)
        }
        
        gm_voiceBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        gm_speakerBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        gm_endBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        gm_maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_actionBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(116)
            make.height.equalTo(116)
        }
    }
    
    private func gm_setupData() {
        gm_titleLb.text = gm_userName
        gm_bgIv.image = UIImage(named: gm_userAvatar)
    }
    
    // MARK: - Animation
    
    private func gm_startDotAnimation() {
        gm_dotTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.gm_updateDots()
        }
    }
    
    private func gm_updateDots() {
        for (index, dot) in gm_dots.enumerated() {
            if index == gm_currentDotIndex {
                dot.backgroundColor = .white
            } else {
                dot.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            }
        }
        gm_currentDotIndex = (gm_currentDotIndex + 1) % 3
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_voiceTapped() {
        gm_isVoiceOn.toggle()
        if gm_isVoiceOn {
            gm_voiceBtn.setImage(UIImage(named: "call_voice"), for: .normal)
        } else {
            gm_voiceBtn.setImage(UIImage(named: "call_voice_end"), for: .normal)
        }
    }
    
    @objc private func gm_speakerTapped() {
        gm_isSpeakerOn.toggle()
        if gm_isSpeakerOn {
            gm_speakerBtn.setImage(UIImage(named: "call_pao"), for: .normal)
        } else {
            gm_speakerBtn.setImage(UIImage(named: "call_pao_end"), for: .normal)
        }
    }
    
    @objc private func gm_endTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_moreAction() {
        gm_maskView.isHidden = false
        gm_maskView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.gm_maskView.alpha = 1
            self.gm_actionBar.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func gm_dismissActionBar() {
        UIView.animate(withDuration: 0.25) {
            self.gm_maskView.alpha = 0
            self.gm_actionBar.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(116)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.gm_maskView.isHidden = true
        }
    }
    
    private func gm_handleBlock() {
        Gm_BlockManager.shared.gm_blockUser(gm_userId, name: gm_userName, avatar: gm_userAvatar)
        gm_dismissActionBar()
        navigationController?.popViewController(animated: true)
    }
    
    private func gm_handleReport() {
        gm_dismissActionBar()
        let vc = Gm_ReportViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
