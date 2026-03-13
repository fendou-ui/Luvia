//
//  Gm_ChatViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_ChatViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_gamerModel: Gm_GamerModel?
    private var gm_messageList: [Gm_ChatMessage] = []
    
    private let gm_aiResponses = [
        "Hey! Ready to team up for some ranked games tonight? 🎮",
        "I've been practicing my aim all day, feeling pretty confident now!",
        "What's your favorite game to play? I'm always looking for new recommendations!",
        "Just finished an epic match! My heart is still racing from that clutch play!",
        "Do you prefer playing support or carry? I love being the team's backbone!",
        "Gaming with you is always so much fun! When's our next session?",
        "I heard there's a new update coming out. So excited to try the new features!",
        "Sometimes I just want to chill and play some casual games. You in?",
        "That last game was intense! We make such a great duo together! 💕",
        "I've been streaming lately. Would love it if you stopped by sometime!"
    ]
    
    // MARK: - UI
    
    private lazy var gm_avatarIv: UIImageView = {
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
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
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
        tv.register(Gm_ChatCell.self, forCellReuseIdentifier: "Gm_ChatCell")
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    private lazy var gm_inputBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        return v
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
    
    private lazy var gm_gradientView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var gm_gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 5/255, green: 11/255, blue: 22/255, alpha: 0).cgColor,
            UIColor(red: 5/255, green: 11/255, blue: 22/255, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    
    private lazy var gm_hotIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_hot")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_hotLb: UILabel = {
        let lb = UILabel()
        lb.text = "91%"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_setupData()
        gm_loadMockMessages()
        gm_addKeyboardObservers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_dismissKeyboard))
        tap.cancelsTouchesInView = false
        gm_tableView.addGestureRecognizer(tap)
        
        // 首次进入弹出AI信息收集提示
        let agreedKey = "gm_ai_privacy_agreed"
        let hasAgreed = UserDefaults.standard.bool(forKey: agreedKey)
        if !hasAgreed {
            let alertView = Gm_CoinAlertView(useBgImage: false)
            alertView.gm_titleText = "To provide AI chat functionality, the text content you enter in chat and your user identifier (such as user ID) will be transmitted to a third-party AI service provider for processing to generate responses.\n\nThis data is used solely for generating chat replies and will not be used for other purposes."
            alertView.gm_noCallback = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            alertView.gm_yesCallback = {
                UserDefaults.standard.set(true, forKey: agreedKey)
            }
            alertView.gm_show(in: self.view)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gm_gradientLayer.frame = gm_gradientView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_avatarIv)
        view.addSubview(gm_gradientView)
        gm_gradientView.layer.addSublayer(gm_gradientLayer)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_tableView)
        view.addSubview(gm_hotIv)
        gm_hotIv.addSubview(gm_hotLb)
        view.addSubview(gm_inputBgView)
        gm_inputBgView.addSubview(gm_inputTf)
        gm_inputBgView.addSubview(gm_sendBtn)
        
        gm_avatarIv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(411)
        }
        
        gm_gradientView.snp.makeConstraints { make in
            make.edges.equalTo(gm_avatarIv)
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
        
        gm_inputBgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(73)
        }
        
        gm_hotIv.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(gm_inputBgView.snp.top).offset(-85)
            make.width.height.equalTo(63)
        }
        
        gm_hotLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(3)
//            make.center.equalToSuperview()
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
    }
    
    private func gm_setupData() {
        guard let model = gm_gamerModel else { return }
        gm_avatarIv.image = UIImage(named: model.gm_cover)
        gm_titleLb.text = model.gm_name
    }
    
    private func gm_loadMockMessages() {
        guard let model = gm_gamerModel else { return }
        gm_messageList = Gm_ChatStorage.shared.gm_getMessages(userId: model.gm_id)
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
    
    @objc private func gm_dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func gm_sendAction() {
        guard let text = gm_inputTf.text, !text.isEmpty else { return }
        guard let model = gm_gamerModel else { return }
        
        let message = Gm_ChatMessage(gm_content: text, gm_isMe: true, gm_time: gm_currentTime())
        gm_messageList.append(message)
        Gm_ChatStorage.shared.gm_saveMessages(userId: model.gm_id, messages: gm_messageList)
        gm_tableView.reloadData()
        gm_inputTf.text = ""
        
        gm_scrollToBottom()
        
        // AI auto reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.gm_sendAIReply()
        }
    }
    
    private func gm_sendAIReply() {
        guard let model = gm_gamerModel else { return }
        let randomIndex = Int.random(in: 0..<gm_aiResponses.count)
        let aiMessage = Gm_ChatMessage(gm_content: gm_aiResponses[randomIndex], gm_isMe: false, gm_time: gm_currentTime())
        gm_messageList.append(aiMessage)
        Gm_ChatStorage.shared.gm_saveMessages(userId: model.gm_id, messages: gm_messageList)
        gm_tableView.reloadData()
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

extension Gm_ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension Gm_ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gm_sendAction()
        return true
    }
}

// MARK: - Gm_ChatMessage

struct Gm_ChatMessage: Codable {
    var gm_content: String
    var gm_isMe: Bool
    var gm_time: String
}

// MARK: - Gm_ChatCell

class Gm_ChatCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var gm_bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        return v
    }()
    
    private lazy var gm_contentLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    }()
    
    private lazy var gm_timeLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        return lb
    }()
    
    private var gm_isMe = false
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        contentView.addSubview(gm_bubbleView)
        gm_bubbleView.addSubview(gm_contentLb)
        contentView.addSubview(gm_timeLb)
    }
    
    // MARK: - Config
    
    func gm_config(message: Gm_ChatMessage) {
        gm_isMe = message.gm_isMe
        gm_contentLb.text = message.gm_content
        gm_timeLb.text = message.gm_time
        
        gm_bubbleView.snp.remakeConstraints { make in
            if gm_isMe {
                make.right.equalToSuperview().offset(-16)
            } else {
                make.left.equalToSuperview().offset(16)
            }
            make.top.equalToSuperview().offset(8)
            make.width.lessThanOrEqualTo(280)
        }
        
        gm_contentLb.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        gm_timeLb.snp.remakeConstraints { make in
            if gm_isMe {
                make.right.equalToSuperview().offset(-16)
            } else {
                make.left.equalToSuperview().offset(16)
            }
            make.top.equalTo(gm_bubbleView.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        if gm_isMe {
            gm_bubbleView.backgroundColor = UIColor(red: 49/255, green: 193/255, blue: 123/255, alpha: 1.0)
        } else {
            gm_bubbleView.backgroundColor = UIColor(red: 89/255, green: 70/255, blue: 208/255, alpha: 1.0)
        }
    }
}
