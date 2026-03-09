//
//  Gm_VideoPlayerViewController.swift
//  Gaming

import UIKit
import SnapKit
import AVFoundation

class Gm_VideoPlayerViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_feedModel: Gm_FeedModel?
    private var gm_player: AVPlayer?
    private var gm_playerLayer: AVPlayerLayer?
    private var gm_isPlaying = false
    
    // MARK: - UI
    
    private lazy var gm_playerView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        return v
    }()
    
    private lazy var gm_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(gm_backAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_three_point"), for: .normal)
        btn.addTarget(self, action: #selector(gm_moreAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_player"), for: .normal)
        btn.addTarget(self, action: #selector(gm_playAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    private lazy var gm_descLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_avatarAction))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_avatarAction))
        lb.addGestureRecognizer(tap)
        return lb
    }()
    
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
        gm_setupPlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gm_playerLayer?.frame = gm_playerView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gm_player?.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        gm_player?.pause()
        gm_player = nil
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_playerView)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_moreBtn)
        view.addSubview(gm_playBtn)
        view.addSubview(gm_descLb)
        view.addSubview(gm_avatarIv)
        view.addSubview(gm_nameLb)
        view.addSubview(gm_maskView)
        view.addSubview(gm_actionBar)
        
        gm_playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(gm_backBtn)
            make.width.height.equalTo(40)
        }
        
        gm_playBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        gm_descLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-21)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(gm_descLb.snp.top).offset(-16)
            make.width.height.equalTo(44)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(2)
            make.centerY.equalTo(gm_avatarIv)
        }
        
        gm_maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_actionBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(116)
            make.height.equalTo(116)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gm_togglePlay))
        gm_playerView.addGestureRecognizer(tapGesture)
    }
    
    private func gm_setupData() {
        guard let model = gm_feedModel else { return }
        gm_avatarIv.image = UIImage(named: model.gm_avatar)
        gm_nameLb.text = model.gm_name
        gm_descLb.text = model.gm_title
    }
    
    private func gm_setupPlayer() {
        guard let model = gm_feedModel else {
            print("gm_model_not_found")
            return
        }
        
        var videoUrl: URL?
        
        // 优先使用本地视频（gm_videoUrl 作为本地文件名）
        let videoName = model.gm_videoUrl.replacingOccurrences(of: ".mp4", with: "")
        if let localPath = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            videoUrl = URL(fileURLWithPath: localPath)
        } else if let localPath = Bundle.main.path(forResource: model.gm_videoUrl, ofType: nil) {
            videoUrl = URL(fileURLWithPath: localPath)
        }
        
        guard let url = videoUrl else {
            print("gm_video_not_found: \(model.gm_videoUrl)")
            return
        }
        
        gm_player = AVPlayer(url: url)
        
        gm_playerLayer = AVPlayerLayer(player: gm_player)
        gm_playerLayer?.videoGravity = .resizeAspectFill
        gm_playerLayer?.frame = gm_playerView.bounds
        gm_playerView.layer.addSublayer(gm_playerLayer!)
        
        // 循环播放
        NotificationCenter.default.addObserver(self, selector: #selector(gm_playerDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: gm_player?.currentItem)
        
        gm_player?.play()
        gm_isPlaying = true
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
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
        guard let model = gm_feedModel else { return }
        Gm_BlockManager.shared.gm_blockUser(model.gm_userId)
        gm_dismissActionBar()
        navigationController?.popViewController(animated: true)
    }
    
    private func gm_handleReport() {
        gm_dismissActionBar()
        let vc = Gm_ReportViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_playAction() {
        gm_togglePlay()
    }
    
    @objc private func gm_togglePlay() {
        if gm_isPlaying {
            gm_player?.pause()
            gm_playBtn.isHidden = false
        } else {
            gm_player?.play()
            gm_playBtn.isHidden = true
        }
        gm_isPlaying.toggle()
    }
    
    @objc private func gm_playerDidFinish() {
        gm_player?.seek(to: .zero)
        gm_player?.play()
    }
    
    @objc private func gm_avatarAction() {
        guard let model = gm_feedModel else { return }
        print("gm_profile: \(model.gm_userId)")
        // TODO: 跳转用户详情页
    }
}
