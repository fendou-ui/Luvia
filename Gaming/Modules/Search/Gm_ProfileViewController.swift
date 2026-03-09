//
//  Gm_ProfileViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_ProfileViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_feedModel: Gm_FeedModel?
    private var gm_isFollowed = false
    
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
        btn.addTarget(self, action: #selector(gm_backAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_three_point"), for: .normal)
        btn.addTarget(self, action: #selector(gm_moreAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_idLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        return lb
    }()
    
    private lazy var gm_followingCountLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lb.textColor = .white
        lb.text = "3"
        return lb
    }()
    
    private lazy var gm_followingLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.text = "Following"
        return lb
    }()
    
    private lazy var gm_followersCountLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lb.textColor = .white
        lb.text = "5"
        return lb
    }()
    
    private lazy var gm_followersLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.text = "Followers"
        return lb
    }()
    
    private lazy var gm_followBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "Gm_follow"), for: .normal)
        btn.addTarget(self, action: #selector(gm_followAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_videoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_video"), for: .normal)
        btn.addTarget(self, action: #selector(gm_videoAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_messBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_mess"), for: .normal)
        btn.addTarget(self, action: #selector(gm_messAction), for: .touchUpInside)
        return btn
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_moreBtn)
        view.addSubview(gm_nameLb)
        view.addSubview(gm_idLb)
        view.addSubview(gm_followingLb)
        view.addSubview(gm_followingCountLb)
        view.addSubview(gm_followersLb)
        view.addSubview(gm_followersCountLb)
        view.addSubview(gm_followBtn)
        view.addSubview(gm_videoBtn)
        view.addSubview(gm_messBtn)
        view.addSubview(gm_maskView)
        view.addSubview(gm_actionBar)
        
        gm_bgIv.snp.makeConstraints { make in
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
        
        gm_followingLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-19)
            make.height.equalTo(15)
        }
        
        gm_followingCountLb.snp.makeConstraints { make in
            make.centerX.equalTo(gm_followingLb)
            make.bottom.equalTo(gm_followingLb.snp.top).offset(-4)
            make.height.equalTo(20)
        }
        
        gm_followersLb.snp.makeConstraints { make in
            make.left.equalTo(gm_followingLb.snp.right).offset(44)
            make.centerY.equalTo(gm_followingLb)
            make.height.equalTo(15)
        }
        
        gm_followersCountLb.snp.makeConstraints { make in
            make.centerX.equalTo(gm_followersLb)
            make.centerY.equalTo(gm_followingCountLb)
            make.height.equalTo(20)
        }
        
        gm_videoBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-14)
            make.width.height.equalTo(50)
        }
        
        gm_messBtn.snp.makeConstraints { make in
            make.right.equalTo(gm_videoBtn.snp.left).offset(-16)
            make.centerY.equalTo(gm_videoBtn)
            make.width.height.equalTo(50)
        }
        
        gm_followBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(gm_videoBtn.snp.top).offset(-26)
            make.width.equalTo(89)
            make.height.equalTo(37)
        }
        
        gm_idLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(gm_followingCountLb.snp.top).offset(-25)
            make.height.equalTo(18)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(gm_idLb.snp.top).offset(-6)
            make.height.equalTo(25)
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
        guard let model = gm_feedModel else { return }
        gm_bgIv.image = UIImage(named: model.gm_avatar)
        gm_nameLb.text = model.gm_name
        gm_idLb.text = "ID \(model.gm_userId)"
        
        // Check if already following
        gm_isFollowed = Gm_FollowStorage.shared.gm_isFollowing(model.gm_userId)
        if gm_isFollowed {
            gm_followBtn.setBackgroundImage(UIImage(named: "Gm_following"), for: .normal)
        } else {
            gm_followBtn.setBackgroundImage(UIImage(named: "Gm_follow"), for: .normal)
        }
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
        Gm_BlockManager.shared.gm_blockUser(model.gm_userId, name: model.gm_name, avatar: model.gm_avatar)
        gm_dismissActionBar()
        navigationController?.popViewController(animated: true)
    }
    
    private func gm_handleReport() {
        gm_dismissActionBar()
        let vc = Gm_ReportViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_followAction() {
        guard let model = gm_feedModel else { return }
        gm_isFollowed.toggle()
        if gm_isFollowed {
            gm_followBtn.setBackgroundImage(UIImage(named: "Gm_following"), for: .normal)
            let followModel = Gm_FollowModel(gm_id: model.gm_userId, gm_name: model.gm_name, gm_avatar: model.gm_avatar)
            Gm_FollowStorage.shared.gm_addFollowing(followModel)
        } else {
            gm_followBtn.setBackgroundImage(UIImage(named: "Gm_follow"), for: .normal)
            Gm_FollowStorage.shared.gm_removeFollowing(model.gm_userId)
        }
    }
    
//    @objc private func gm_followingBtnAction() {
//        print("gm_following_btn_action")
//    }
    
    @objc private func gm_videoAction() {
        guard let model = gm_feedModel else { return }
        let vc = Gm_VideoCallViewController()
        vc.gm_userId = model.gm_userId
        vc.gm_userName = model.gm_name
        vc.gm_userAvatar = model.gm_avatar
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_messAction() {
        guard let model = gm_feedModel else { return }
        let vc = Gm_UserChatViewController()
        vc.gm_userId = model.gm_userId
        vc.gm_userName = model.gm_name
        vc.gm_userAvatar = model.gm_avatar
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
