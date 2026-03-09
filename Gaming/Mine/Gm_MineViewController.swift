//
//  Gm_MineViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_MineViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_menuItems = [
        ("Profile_edit", "Edit Profile"),
        ("Profile_videos", "My Videos"),
        ("Profile_heat", "Blacklist"),
        ("Profile_set", "Settings")
    ]
    
    // MARK: - UI
    
    private lazy var gm_scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    private lazy var gm_contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var gm_titleIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_profile")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_deafult_cell")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.text = "Raya"
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_idLb: UILabel = {
        let lb = UILabel()
        lb.text = "ID 254785297"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        return lb
    }()
    
    private lazy var gm_followingCountLb: UILabel = {
        let lb = UILabel()
        lb.text = "1900"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_followingLb: UILabel = {
        let lb = UILabel()
        lb.text = "Following"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_followingTapped))
        lb.addGestureRecognizer(tap)
        return lb
    }()
    
    private lazy var gm_followersCountLb: UILabel = {
        let lb = UILabel()
        lb.text = "0"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_followersLb: UILabel = {
        let lb = UILabel()
        lb.text = "Followers"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_followersTapped))
        lb.addGestureRecognizer(tap)
        return lb
    }()
    
    private lazy var gm_followingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(gm_followingTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_followersBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(gm_followersTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_coinsView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_coinsTapped))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    private lazy var gm_coinsBgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Profile_coins")
        iv.contentMode = .scaleToFill
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
        lb.text = "0"
        lb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_menuView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        v.layer.cornerRadius = 24
        return v
    }()
    
    private lazy var gm_logoutBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Log out", for: .normal)
        btn.setTitleColor(UIColor(red: 236/255, green: 132/255, blue: 132/255, alpha: 1.0), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.layer.cornerRadius = 30
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(red: 236/255, green: 132/255, blue: 132/255, alpha: 1.0).cgColor
        btn.addTarget(self, action: #selector(gm_logoutAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupMenuItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gm_loadUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Data
    
    private func gm_loadUserData() {
        let name = UserDefaults.standard.string(forKey: "gm_user_name") ?? "Raya"
        gm_nameLb.text = name
        
        if let avatarData = UserDefaults.standard.data(forKey: "gm_user_avatar"),
           let image = UIImage(data: avatarData) {
            gm_avatarIv.image = image
        }
        
        // 更新关注数量
        let followingCount = Gm_FollowStorage.shared.gm_getFollowingCount()
        gm_followingCountLb.text = "\(followingCount)"
        
        // 更新金币数量
        let coins = Gm_CoinsManager.shared.gm_getCoins()
        gm_coinsCountLb.text = "\(coins)"
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_scrollView)
        gm_scrollView.addSubview(gm_contentView)
        
        gm_contentView.addSubview(gm_titleIv)
        gm_contentView.addSubview(gm_avatarIv)
        gm_contentView.addSubview(gm_nameLb)
        gm_contentView.addSubview(gm_idLb)
        gm_contentView.addSubview(gm_followingBtn)
        gm_followingBtn.addSubview(gm_followingCountLb)
        gm_followingBtn.addSubview(gm_followingLb)
        gm_contentView.addSubview(gm_followersBtn)
        gm_followersBtn.addSubview(gm_followersCountLb)
        gm_followersBtn.addSubview(gm_followersLb)
        gm_contentView.addSubview(gm_coinsView)
        gm_coinsView.addSubview(gm_coinsBgIv)
        gm_coinsView.addSubview(gm_coinsLb)
        gm_coinsView.addSubview(gm_coinsCountLb)
        gm_contentView.addSubview(gm_menuView)
        gm_contentView.addSubview(gm_logoutBtn)
        
        gm_scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        
        gm_titleIv.snp.makeConstraints { make in
            make.top.equalTo(gm_contentView.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(145)
            make.height.equalTo(36)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(gm_titleIv.snp.bottom).offset(37)
            make.width.height.equalTo(124)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(12)
            make.top.equalTo(gm_avatarIv).offset(16)
            make.height.equalTo(25)
        }
        
        gm_idLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(12)
            make.top.equalTo(gm_nameLb.snp.bottom).offset(6)
            make.height.equalTo(18)
        }
        
        gm_followingBtn.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(12)
            make.top.equalTo(gm_idLb.snp.bottom).offset(23)
        }
        
        gm_followingCountLb.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        gm_followingLb.snp.makeConstraints { make in
            make.left.equalTo(gm_followingCountLb.snp.right).offset(2)
            make.centerY.equalTo(gm_followingCountLb)
            make.right.bottom.equalToSuperview()
        }
        
        gm_followersBtn.snp.makeConstraints { make in
            make.left.equalTo(gm_followingBtn.snp.right).offset(24)
            make.centerY.equalTo(gm_followingBtn)
        }
        
        gm_followersCountLb.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        gm_followersLb.snp.makeConstraints { make in
            make.left.equalTo(gm_followersCountLb.snp.right).offset(2)
            make.centerY.equalTo(gm_followersCountLb)
            make.right.bottom.equalToSuperview()
        }
        
        gm_coinsView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_avatarIv.snp.bottom).offset(24)
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
        
        gm_menuView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_coinsView.snp.bottom).offset(24)
            make.height.equalTo(216)
        }
        
        gm_logoutBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_menuView.snp.bottom).offset(24)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func gm_setupMenuItems() {
        var lastView: UIView?
        
        for (index, item) in gm_menuItems.enumerated() {
            let rowView = gm_createMenuRow(icon: item.0, title: item.1, tag: index)
            gm_menuView.addSubview(rowView)
            
            rowView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(48)
                if let last = lastView {
                    make.top.equalTo(last.snp.bottom)
                } else {
                    make.top.equalToSuperview().offset(12)
                }
            }
            
            lastView = rowView
        }
    }
    
    private func gm_createMenuRow(icon: String, title: String, tag: Int) -> UIView {
        let rowView = UIView()
        rowView.tag = tag
        rowView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_menuTapped(_:)))
        rowView.addGestureRecognizer(tap)
        
        let iconIv = UIImageView()
        iconIv.image = UIImage(named: icon)
        iconIv.contentMode = .scaleAspectFit
        rowView.addSubview(iconIv)
        
        let titleLb = UILabel()
        titleLb.text = title
        titleLb.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLb.textColor = .white
        rowView.addSubview(titleLb)
        
        let arrowIv = UIImageView()
        arrowIv.image = UIImage(named: "Gm_arrow")
        arrowIv.contentMode = .scaleAspectFit
        rowView.addSubview(arrowIv)
        
        iconIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconIv.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        arrowIv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        return rowView
    }
    
    // MARK: - Actions
    
    @objc private func gm_followingTapped() {
        let vc = Gm_FollowingViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_followersTapped() {
        let vc = Gm_FollowersViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_coinsTapped() {
        let vc = Gm_RechargeViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_menuTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        
        switch tag {
        case 0:
            let vc = Gm_EditProfileViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = Gm_MyVideosViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = Gm_BlacklistViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = Gm_SettingsViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @objc private func gm_logoutAction() {
        let vc = Gm_LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}
