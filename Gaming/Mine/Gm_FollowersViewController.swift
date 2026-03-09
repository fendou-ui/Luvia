//
//  Gm_FollowersViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_FollowersViewController: UIViewController {
    
    // MARK: - Data
    
    private var gm_followersList: [Gm_FollowModel] = []
    
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
        lb.text = "Followers"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(Gm_FollowingCell.self, forCellReuseIdentifier: "Gm_FollowingCell")
        return tv
    }()
    
    private lazy var gm_emptyView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()
    
    private lazy var gm_emptyIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_search")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_tableView)
        view.addSubview(gm_emptyView)
        gm_emptyView.addSubview(gm_emptyIv)
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        gm_emptyView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        gm_emptyIv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(189)
            make.width.height.equalTo(94)
        }
    }
    
    private func gm_loadData() {
        // Followers list is empty by default
        gm_followersList = []
        gm_updateEmptyState()
        gm_tableView.reloadData()
    }
    
    private func gm_updateEmptyState() {
        let isEmpty = gm_followersList.isEmpty
        gm_emptyView.isHidden = !isEmpty
        gm_tableView.isHidden = isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_FollowersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_followersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gm_FollowingCell", for: indexPath) as! Gm_FollowingCell
        let model = gm_followersList[indexPath.row]
        cell.gm_config(model: model)
        cell.gm_messageCallback = { [weak self] in
            print("gm_message_tapped: \(model.gm_name)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
