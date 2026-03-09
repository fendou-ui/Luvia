//
//  Gm_TipsViewController.swift
//  Gaming

import UIKit
import SnapKit

class Gm_TipsViewController: UIViewController {
    
    // MARK: - Data
    
    private var gm_tipsList: [Gm_TipModel] = []
    
    // MARK: - UI
    
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_tech")
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
        lb.text = "Game Tips"
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
        tv.register(Gm_TipCell.self, forCellReuseIdentifier: "Gm_TipCell")
        return tv
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
        view.addSubview(gm_bgIv)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_tableView)
        
        gm_bgIv.snp.makeConstraints { make in
            make.bottom.top.left.right.equalToSuperview()
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
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(268)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func gm_loadData() {
        gm_tipsList = Gm_TipModel.gm_mockList()
        gm_tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_TipsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_tipsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gm_TipCell", for: indexPath) as! Gm_TipCell
        let model = gm_tipsList[indexPath.row]
        cell.gm_config(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - Gm_TipModel

struct Gm_TipModel {
    var gm_id: String
    var gm_title: String
    var gm_content: String
    
    static func gm_mockList() -> [Gm_TipModel] {
        return [
            Gm_TipModel(gm_id: "1", gm_title: "Last-Hit Timing", gm_content: "Attack minions at the last moment to secure gold while denying the enemy."),
            Gm_TipModel(gm_id: "2", gm_title: "Bait & Punish", gm_content: "Pretend to make a mistake to lure out key enemy skills, then counter-attack."),
            Gm_TipModel(gm_id: "3", gm_title: "High Ground Control", gm_content: "Always fight from elevated terrain to gain vision and attack range advantage."),
            Gm_TipModel(gm_id: "4", gm_title: "Pre-Aiming", gm_content: "Keep your crosshair at head level where enemies are likely to appear."),
            Gm_TipModel(gm_id: "5", gm_title: "Silent Walk", gm_content: "Use walk mode instead of running to mask your footsteps while gathering information."),
            Gm_TipModel(gm_id: "6", gm_title: "Resource Denial", gm_content: "Continuously harass enemy workers or steal their resources to cripple their economy."),
            Gm_TipModel(gm_id: "7", gm_title: "Feint Attack", gm_content: "Fake an attack on one front to draw enemy forces, then strike elsewhere."),
            Gm_TipModel(gm_id: "8", gm_title: "Building Wall", gm_content: "Place structures strategically to create chokepoints and delay enemy advances.")
        ]
    }
}

// MARK: - Gm_TipCell

class Gm_TipCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var gm_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 214/255, green: 73/255, blue: 153/255, alpha: 1.0)
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.cgColor
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_contentLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        lb.numberOfLines = 2
        return lb
    }()
    
    private lazy var gm_infoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_info"), for: .normal)
        return btn
    }()
    
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
        contentView.addSubview(gm_containerView)
        gm_containerView.addSubview(gm_titleLb)
        gm_containerView.addSubview(gm_contentLb)
        gm_containerView.addSubview(gm_infoBtn)
        
        gm_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        gm_infoBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        gm_contentLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_titleLb.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Config
    
    func gm_config(model: Gm_TipModel) {
        gm_titleLb.text = model.gm_title
        gm_contentLb.text = model.gm_content
    }
}
