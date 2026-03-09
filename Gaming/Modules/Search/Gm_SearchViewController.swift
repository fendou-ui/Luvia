//
//  Gm_SearchViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_SearchViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_tabs = ["For you", "Following"]
    private var gm_selectedTab = 0
    private var gm_tabBtns: [UIButton] = []
    
    private let gm_avatars = ["Gm_avatar1", "Gm_avatar2", "Gm_avatar3", "Gm_avatar4", "Gm_avatar5"]
    private var gm_feedList: [Gm_FeedModel] = []
    
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
        iv.image = UIImage(named: "search_title")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_avatarScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = true
        return sv
    }()
    
    private lazy var gm_avatarStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 14
        sv.alignment = .center
        return sv
    }()
    
    private lazy var gm_tabContainer: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var gm_underline: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0)
        v.layer.cornerRadius = 2.5
        return v
    }()
    
    private lazy var gm_collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (UIScreen.main.bounds.width - 16 - 16 - 16) / 2
        layout.itemSize = CGSize(width: itemWidth, height: 256)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(Gm_FeedCell.self, forCellWithReuseIdentifier: Gm_FeedCell.gm_id)
        return cv
    }()
    
    private lazy var gm_postBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Post", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 23
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_postAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_postGradient: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.colors = [
            UIColor(red: 253/255, green: 167/255, blue: 224/255, alpha: 1.0).cgColor,
            UIColor(red: 177/255, green: 102/255, blue: 242/255, alpha: 1.0).cgColor
        ]
        gl.startPoint = CGPoint(x: 0.5, y: 0)
        gl.endPoint = CGPoint(x: 0.5, y: 1)
        return gl
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
    
    private var gm_currentModel: Gm_FeedModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupAvatars()
        gm_setupTabs()
        gm_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_titleIv)
        view.addSubview(gm_avatarScrollView)
        gm_avatarScrollView.addSubview(gm_avatarStackView)
        view.addSubview(gm_tabContainer)
        view.addSubview(gm_underline)
        view.addSubview(gm_collectionView)
        view.addSubview(gm_postBtn)
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_titleIv.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(196)
            make.height.equalTo(36)
        }
        
        gm_avatarScrollView.snp.makeConstraints { make in
            make.top.equalTo(gm_titleIv.snp.bottom).offset(23)
            make.left.right.equalToSuperview()
            make.height.equalTo(92)
        }
        
        gm_avatarStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(92)
        }
        
        gm_tabContainer.snp.makeConstraints { make in
            make.top.equalTo(gm_avatarScrollView.snp.bottom).offset(21)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }
        
        gm_collectionView.snp.makeConstraints { make in
            make.top.equalTo(gm_tabContainer.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        gm_postBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(98)
            make.height.equalTo(46)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gm_postGradient.frame = gm_postBtn.bounds
        if gm_postGradient.superlayer == nil {
            gm_postBtn.layer.insertSublayer(gm_postGradient, at: 0)
        }
    }
    
    private func gm_setupAvatars() {
        let feedList = Gm_FeedModel.gm_mockList()
        for model in feedList {
            let container = UIView()
            container.isUserInteractionEnabled = true
            
            let avatarIv = UIImageView()
            avatarIv.image = UIImage(named: model.gm_avatar)
            avatarIv.contentMode = .scaleAspectFill
            avatarIv.clipsToBounds = true
            avatarIv.layer.cornerRadius = 46
            avatarIv.layer.borderWidth = 1
            avatarIv.layer.borderColor = UIColor.white.cgColor
            
            container.addSubview(avatarIv)
            
            container.snp.makeConstraints { make in
                make.width.height.equalTo(92)
            }
            
            avatarIv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(gm_avatarTapped(_:)))
            container.addGestureRecognizer(tap)
            container.tag = gm_avatarStackView.arrangedSubviews.count
            
            gm_avatarStackView.addArrangedSubview(container)
        }
    }
    
    @objc private func gm_avatarTapped(_ gesture: UITapGestureRecognizer) {
        guard let container = gesture.view else { return }
        let index = container.tag
        let feedList = Gm_FeedModel.gm_mockList()
        guard index < feedList.count else { return }
        
        let model = feedList[index]
        let vc = Gm_ProfileViewController()
        vc.gm_feedModel = model
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gm_setupTabs() {
        var lastBtn: UIButton?
        
        for (index, title) in gm_tabs.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            btn.tag = index
            btn.addTarget(self, action: #selector(gm_tabTapped(_:)), for: .touchUpInside)
            
            gm_tabContainer.addSubview(btn)
            gm_tabBtns.append(btn)
            
            btn.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let last = lastBtn {
                    make.left.equalTo(last.snp.right).offset(26)
                } else {
                    make.left.equalToSuperview()
                }
                if index == gm_tabs.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            
            lastBtn = btn
        }
        
        view.layoutIfNeeded()
        gm_updateTabUI(animated: false)
    }
    
    private func gm_updateTabUI(animated: Bool = true) {
        for (index, btn) in gm_tabBtns.enumerated() {
            if index == gm_selectedTab {
                btn.setTitleColor(.white, for: .normal)
            } else {
                btn.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            }
        }
        
        guard gm_selectedTab < gm_tabBtns.count else { return }
        let selectedBtn = gm_tabBtns[gm_selectedTab]
        
        gm_underline.snp.remakeConstraints { make in
            make.top.equalTo(selectedBtn.snp.bottom)
            make.centerX.equalTo(selectedBtn)
            make.width.equalTo(27)
            make.height.equalTo(5)
        }
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    private func gm_loadData() {
        var list = Gm_FeedModel.gm_mockList()
        // 过滤掉黑名单用户的动态
        let blockedUserIds = Gm_BlockManager.shared.gm_getBlockedUserIds()
        list = list.filter { !blockedUserIds.contains($0.gm_userId) }
        gm_feedList = list
        gm_collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func gm_tabTapped(_ sender: UIButton) {
        gm_selectedTab = sender.tag
        gm_updateTabUI(animated: true)
    }
    
    @objc private func gm_postAction() {
        let vc = Gm_PostViewController()
        vc.gm_isVideoMode = true
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func gm_showActionBar(model: Gm_FeedModel) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        gm_currentModel = model
        
        window.addSubview(gm_maskView)
        window.addSubview(gm_actionBar)
        
        gm_maskView.frame = window.bounds
        gm_maskView.isHidden = false
        gm_maskView.alpha = 0
        
        gm_actionBar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: 116)
        
        UIView.animate(withDuration: 0.25) {
            self.gm_maskView.alpha = 1
            self.gm_actionBar.frame = CGRect(x: 0, y: window.bounds.height - 116, width: window.bounds.width, height: 116)
        }
    }
    
    @objc private func gm_dismissActionBar() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        UIView.animate(withDuration: 0.25) {
            self.gm_maskView.alpha = 0
            self.gm_actionBar.frame = CGRect(x: 0, y: window.bounds.height, width: window.bounds.width, height: 116)
        } completion: { _ in
            self.gm_maskView.isHidden = true
            self.gm_maskView.removeFromSuperview()
            self.gm_actionBar.removeFromSuperview()
        }
    }
    
    private func gm_handleBlock() {
        gm_dismissActionBar()
        guard let model = gm_currentModel else { return }
        
        // 添加到黑名单
        Gm_BlockManager.shared.gm_blockUser(model.gm_userId)
        
        // 移除该用户的所有动态
        gm_feedList.removeAll { $0.gm_userId == model.gm_userId }
        gm_collectionView.reloadData()
        
        print("gm_block_user: \(model.gm_userId)")
    }
    
    private func gm_handleReport() {
        gm_dismissActionBar()
        let vc = Gm_ReportViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension Gm_SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gm_feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Gm_FeedCell.gm_id, for: indexPath) as! Gm_FeedCell
        let model = gm_feedList[indexPath.item]
        cell.gm_config(cover: model.gm_cover, title: model.gm_title, avatar: model.gm_avatar, name: model.gm_name, isLiked: model.gm_isLiked)
        
        cell.gm_moreCallback = { [weak self] in
            self?.gm_showActionBar(model: model)
        }
        
        cell.gm_likeCallback = { [weak self] in
            self?.gm_feedList[indexPath.item].gm_isLiked.toggle()
        }
        
        cell.gm_profileCallback = { [weak self] in
            let vc = Gm_ProfileViewController()
            vc.gm_feedModel = model
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = gm_feedList[indexPath.item]
        let vc = Gm_VideoPlayerViewController()
        vc.gm_feedModel = model
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
