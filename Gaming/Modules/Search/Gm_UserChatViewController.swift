//
//  Gm_UserChatViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_UserChatViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_userId: String = ""
    var gm_userName: String = ""
    var gm_userAvatar: String = ""
    
    private var gm_messageList: [Gm_ChatMessage] = []
    
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
    
    private lazy var gm_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(Gm_ChatCell.self, forCellReuseIdentifier: "Gm_ChatCell")
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private lazy var gm_inputBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        return v
    }()
    
//    private lazy var gm_photoBtn: UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "search_photo"), for: .normal)
//        btn.addTarget(self, action: #selector(gm_photoAction), for: .touchUpInside)
//        return btn
//    }()
    
    private lazy var gm_videoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "search_video"), for: .normal)
        btn.addTarget(self, action: #selector(gm_videoAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_inputTf: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        tf.layer.cornerRadius = 10
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Type...",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.returnKeyType = .send
        tf.delegate = self
        return tf
    }()
    
    private lazy var gm_sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_sent"), for: .normal)
        btn.addTarget(self, action: #selector(gm_sendAction), for: .touchUpInside)
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
    
    private lazy var gm_actionBarView: Gm_ActionBarView = {
        let v = Gm_ActionBarView()
        return v
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupData()
        gm_loadMessages()
        gm_addKeyboardObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_moreBtn)
        view.addSubview(gm_tableView)
        view.addSubview(gm_inputBgView)
//        gm_inputBgView.addSubview(gm_photoBtn)
        gm_inputBgView.addSubview(gm_videoBtn)
        gm_inputBgView.addSubview(gm_inputTf)
        gm_inputBgView.addSubview(gm_sendBtn)
        view.addSubview(gm_maskView)
        view.addSubview(gm_actionBarView)
        
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
        
        gm_inputBgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(110)
        }
        
//        gm_photoBtn.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(16)
//            make.top.equalToSuperview().offset(10)
//            make.width.height.equalTo(28)
//        }
        
        gm_videoBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(28)
        }
        
        gm_sendBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(42)
            make.height.equalTo(51)
        }
        
        gm_inputTf.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalTo(gm_sendBtn.snp.left).offset(-6)
            make.height.equalTo(51)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(gm_inputBgView.snp.top)
        }
        
        gm_maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_actionBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(116)
            make.height.equalTo(116)
        }
        
        gm_actionBarView.gm_blockCallback = { [weak self] in
            self?.gm_blockUser()
        }
        
        gm_actionBarView.gm_reportCallback = { [weak self] in
            self?.gm_dismissActionBar()
            let vc = Gm_ReportViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func gm_dismissActionBar() {
        UIView.animate(withDuration: 0.25) {
            self.gm_maskView.alpha = 0
            self.gm_actionBarView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(116)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.gm_maskView.isHidden = true
        }
    }
    
    private func gm_setupData() {
        gm_titleLb.text = gm_userName
    }
    
    private func gm_loadMessages() {
        gm_messageList = Gm_ChatStorage.shared.gm_getMessages(userId: gm_userId)
        gm_tableView.reloadData()
        if gm_messageList.count > 0 {
            gm_scrollToBottom()
        }
    }
    
    private func gm_addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gm_keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gm_keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            self.gm_actionBarView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func gm_photoAction() {
        print("gm_photo_action")
    }
    
    @objc private func gm_videoAction() {
        let vc = Gm_VideoCallViewController()
        vc.gm_userId = gm_userId
        vc.gm_userName = gm_userName
        vc.gm_userAvatar = gm_userAvatar
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func gm_sendAction() {
        guard let text = gm_inputTf.text, !text.isEmpty else { return }
        
        let message = Gm_ChatMessage(gm_content: text, gm_isMe: true, gm_time: gm_currentTime())
        gm_messageList.append(message)
        Gm_ChatStorage.shared.gm_saveMessages(userId: gm_userId, messages: gm_messageList)
        
        // 保存聊天用户到消息列表
        Gm_ChatStorage.shared.gm_saveChatUser(
            userId: gm_userId,
            name: gm_userName,
            avatar: gm_userAvatar,
            lastMessage: text,
            lastTime: gm_currentTime()
        )
        
        gm_tableView.reloadData()
        gm_inputTf.text = ""
        
        gm_scrollToBottom()
    }
    
    private func gm_currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: Date()).lowercased()
    }
    
    private func gm_scrollToBottom() {
        guard gm_messageList.count > 0 else { return }
        let indexPath = IndexPath(row: gm_messageList.count - 1, section: 0)
        gm_tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func gm_blockUser() {
        Gm_BlockManager.shared.gm_blockUser(gm_userId, name: gm_userName, avatar: gm_userAvatar)
        gm_dismissActionBar()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        
        gm_inputBgView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func gm_keyboardWillHide(_ notification: Notification) {
        gm_inputBgView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_UserChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gm_ChatCell", for: indexPath) as! Gm_ChatCell
        let message = gm_messageList[indexPath.row]
        cell.gm_config(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UITextFieldDelegate

extension Gm_UserChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gm_sendAction()
        return true
    }
}
