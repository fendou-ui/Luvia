//
//  Gm_TopicsViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_TopicsViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_categories = ["MOBA", "FPS", "RTS", "Competitive"]
    private var gm_selectedIndex = 0
    private var gm_categoryBtns: [UIButton] = []
    private var gm_topicList: [Gm_TopicModel] = []
    private var gm_currentModel: Gm_TopicModel?
    
    // MARK: - UI
    
    private lazy var gm_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(gm_backAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
        lb.text = "Game Topics"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_categoryScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.backgroundColor = .clear
        sv.bounces = true
        return sv
    }()
    
    private lazy var gm_categoryStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var gm_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(Gm_TopicCell.self, forCellReuseIdentifier: "Gm_TopicCell")
        return tv
    }()
    
    private lazy var gm_postBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Post", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(gm_postAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_postGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 253/255, green: 167/255, blue: 224/255, alpha: 1.0).cgColor,
            UIColor(red: 177/255, green: 102/255, blue: 242/255, alpha: 1.0).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.cornerRadius = 23
        return layer
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
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupCategoryBtns()
        gm_loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gm_loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gm_postGradientLayer.frame = gm_postBtn.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_categoryScrollView)
        gm_categoryScrollView.addSubview(gm_categoryStackView)
        view.addSubview(gm_tableView)
        view.addSubview(gm_postBtn)
        gm_postBtn.layer.insertSublayer(gm_postGradientLayer, at: 0)
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        gm_categoryStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        gm_postBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.width.equalTo(98)
            make.height.equalTo(46)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_categoryScrollView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(gm_maskView)
        view.addSubview(gm_actionBar)
        
        gm_maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_actionBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(116)
            make.height.equalTo(116)
        }
    }
    
    private func gm_setupCategoryBtns() {
        for (index, title) in gm_categories.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            btn.layer.cornerRadius = 12
            btn.clipsToBounds = true
            btn.tag = index
            btn.addTarget(self, action: #selector(gm_categoryTapped(_:)), for: .touchUpInside)
            
            btn.snp.makeConstraints { make in
                make.width.equalTo(96)
                make.height.equalTo(44)
            }
            
            gm_categoryBtns.append(btn)
            gm_categoryStackView.addArrangedSubview(btn)
        }
        
        gm_updateCategoryUI()
    }
    
    private func gm_updateCategoryUI() {
        for (index, btn) in gm_categoryBtns.enumerated() {
            if index == gm_selectedIndex {
                btn.setTitleColor(UIColor(red: 0.84, green: 0.43, blue: 0.97, alpha: 1.0), for: .normal)
                btn.backgroundColor = .white
            } else {
                btn.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
                btn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
        }
    }
    
    private func gm_loadData() {
        let category = gm_categories[gm_selectedIndex]
        let allTopics = Gm_TopicModel.gm_mockListByCategory(category)
        // 过滤掉已拉黑的用户
        gm_topicList = allTopics.filter { !Gm_BlockManager.shared.gm_isBlocked($0.gm_userId) }
        gm_tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_categoryTapped(_ sender: UIButton) {
        gm_selectedIndex = sender.tag
        gm_updateCategoryUI()
        gm_scrollToCenter(index: sender.tag)
        gm_loadData()
    }
    
    private func gm_scrollToCenter(index: Int) {
        guard index < gm_categoryBtns.count else { return }
        
        let btn = gm_categoryBtns[index]
        let btnFrame = btn.convert(btn.bounds, to: gm_categoryScrollView)
        let scrollViewWidth = gm_categoryScrollView.bounds.width
        let contentWidth = gm_categoryScrollView.contentSize.width
        
        var targetX = btnFrame.midX - scrollViewWidth / 2
        
        if targetX < 0 {
            targetX = 0
        } else if targetX > contentWidth - scrollViewWidth {
            targetX = max(0, contentWidth - scrollViewWidth)
        }
        
        gm_categoryScrollView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
    }
    
    @objc private func gm_postAction() {
        let vc = Gm_PostViewController()
        vc.gm_isVideoMode = false
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gm_showActionBar() {
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
        guard let model = gm_currentModel else { return }
        Gm_BlockManager.shared.gm_blockUser(model.gm_userId, name: model.gm_name, avatar: model.gm_avatar)
        gm_topicList.removeAll { $0.gm_userId == model.gm_userId }
        gm_tableView.reloadData()
        gm_dismissActionBar()
    }
    
    private func gm_handleReport() {
        gm_dismissActionBar()
        let vc = Gm_ReportViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_TopicsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_topicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gm_TopicCell", for: indexPath) as! Gm_TopicCell
        let model = gm_topicList[indexPath.row]
        cell.gm_config(model: model)
        cell.gm_reportCallback = { [weak self] in
            self?.gm_currentModel = model
            self?.gm_showActionBar()
        }
        cell.gm_avatarCallback = { [weak self] in
            self?.gm_goToProfile(model: model)
        }
        return cell
    }
    
    private func gm_goToProfile(model: Gm_TopicModel) {
        let feedModel = Gm_FeedModel(
            gm_id: model.gm_id,
            gm_cover: model.gm_avatar,
            gm_title: "",
            gm_avatar: model.gm_avatar,
            gm_name: model.gm_name,
            gm_userId: model.gm_userId,
            gm_isLiked: model.gm_isLiked,
            gm_videoUrl: ""
        )
        
        let vc = Gm_ProfileViewController()
        vc.gm_feedModel = feedModel
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 289
    }
}
