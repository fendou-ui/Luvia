//
//  Gm_HomeViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_HomeViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_categories = ["MOBA", "FPS", "RTS", "Competitive"]
    private var gm_selectedIndex = 0
    private var gm_categoryBtns: [UIButton] = []
    
    private var gm_allData: [Gm_GamerModel] = []
    private var gm_filteredData: [Gm_GamerModel] = []
    
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
        iv.image = UIImage(named: "Gamer_Girl")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_videoFeedBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "video_feed"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_videoFeedAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_tipsBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_tips"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_tipsAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_topsBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_Tops"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_topsAction), for: .touchUpInside)
        return btn
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
        tv.register(Gm_GamerCell.self, forCellReuseIdentifier: Gm_GamerCell.gm_id)
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupCategoryBtns()
        gm_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_titleIv)
        view.addSubview(gm_videoFeedBtn)
        view.addSubview(gm_tipsBtn)
        view.addSubview(gm_topsBtn)
        view.addSubview(gm_categoryScrollView)
        gm_categoryScrollView.addSubview(gm_categoryStackView)
        view.addSubview(gm_tableView)
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_titleIv.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(203)
            make.height.equalTo(36)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth - 16 - 16 - 14) / 2
        
        gm_videoFeedBtn.snp.makeConstraints { make in
            make.top.equalTo(gm_titleIv.snp.bottom).offset(23)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(172)
        }
        
        gm_tipsBtn.snp.makeConstraints { make in
            make.top.equalTo(gm_titleIv.snp.bottom).offset(23)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(80)
        }
        
        gm_topsBtn.snp.makeConstraints { make in
            make.top.equalTo(gm_tipsBtn.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(80)
        }
        
        gm_categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(gm_videoFeedBtn.snp.bottom).offset(31)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        gm_categoryStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_categoryScrollView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func gm_setupCategoryBtns() {
        for (index, title) in gm_categories.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            btn.layer.cornerRadius = 22
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
    
    // MARK: - Actions
    
    @objc private func gm_categoryTapped(_ sender: UIButton) {
        gm_selectedIndex = sender.tag
        gm_updateCategoryUI()
        gm_scrollToCenter(index: sender.tag)
        gm_filterData()
    }
    
    private func gm_loadData() {
        gm_allData = Gm_GamerModel.gm_mockList()
        gm_filterData()
    }
    
    private func gm_filterData() {
        let category = gm_categories[gm_selectedIndex]
        gm_filteredData = gm_allData.filter { $0.gm_category == category }
        gm_tableView.reloadData()
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
    
    @objc private func gm_videoFeedAction() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc private func gm_tipsAction() {
        let vc = Gm_TipsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_topsAction() {
        let vc = Gm_TopicsViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Gm_GamerCell.gm_id, for: indexPath) as! Gm_GamerCell
        let model = gm_filteredData[indexPath.row]
        cell.gm_config(model: model)
        cell.gm_chatCallback = { [weak self] in
            print("gm_chat: \(model.gm_name)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = gm_filteredData[indexPath.row]
        
        // 检查是否已支付过该用户
        let paidKey = "gm_paid_user_\(model.gm_id)"
        let hasPaid = UserDefaults.standard.bool(forKey: paidKey)
        
        if !hasPaid {
            // 首次点击需要支付99金币
            if Gm_CoinsManager.shared.gm_hasEnoughCoins(99) {
                // 扣除金币
                _ = Gm_CoinsManager.shared.gm_spendCoins(99)
                // 标记已支付
                UserDefaults.standard.set(true, forKey: paidKey)
                // 进入聊天页面
                gm_pushToChatVC(model: model)
            } else {
                // 金币不足，跳转充值页面
                let vc = Gm_RechargeViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // 已支付过，直接进入
            gm_pushToChatVC(model: model)
        }
    }
    
    private func gm_pushToChatVC(model: Gm_GamerModel) {
        let vc = Gm_ChatViewController()
        vc.gm_gamerModel = model
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
