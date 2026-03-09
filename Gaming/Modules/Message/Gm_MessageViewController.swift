//
//  Gm_MessageViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_MessageViewController: UIViewController {
    
    // MARK: - Data
    
    private var gm_chatUsers: [Gm_ChatUser] = []
    
    // MARK: - UI
    
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gaming_bg")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var gm_titleIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "message_title")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_emptyLb: UILabel = {
        let lb = UILabel()
        lb.text = "No messages yet"
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.textAlignment = .center
        lb.isHidden = true
        return lb
    }()
    
    private lazy var gm_tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(Gm_MessageCell.self, forCellReuseIdentifier: Gm_MessageCell.gm_id)
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gm_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_titleIv)
        view.addSubview(gm_tableView)
        view.addSubview(gm_emptyLb)
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_titleIv.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(188)
            make.height.equalTo(36)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_titleIv.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        gm_emptyLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func gm_loadData() {
        gm_chatUsers = Gm_ChatStorage.shared.gm_getChatUsers()
        gm_emptyLb.isHidden = !gm_chatUsers.isEmpty
        gm_tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_chatUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Gm_MessageCell.gm_id, for: indexPath) as! Gm_MessageCell
        let user = gm_chatUsers[indexPath.row]
        cell.gm_config(avatar: user.gm_avatar, name: user.gm_name, content: user.gm_lastMessage, time: user.gm_lastTime)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = gm_chatUsers[indexPath.row]
        let vc = Gm_UserChatViewController()
        vc.gm_userId = user.gm_userId
        vc.gm_userName = user.gm_name
        vc.gm_userAvatar = user.gm_avatar
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
