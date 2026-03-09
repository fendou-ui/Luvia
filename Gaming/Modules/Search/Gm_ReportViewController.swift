//
//  Gm_ReportViewController.swift
//  Gaming

import UIKit
import SnapKit
import ZKProgressHUD

class Gm_ReportViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_reasons = [
        "Content error",
        "Language violence",
        "Religious discrimination",
        "Pornographic content",
        "Gender discrimination"
    ]
    
    private var gm_selectedIndex: Int? = nil
    
    // MARK: - UI
    
    private lazy var gm_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(gm_backAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
        lb.text = "Report"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(Gm_ReportCell.self, forCellReuseIdentifier: "Gm_ReportCell")
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private lazy var gm_submitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "Gm_post"), for: .normal)
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(gm_submitAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_tableView)
        view.addSubview(gm_submitBtn)
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_submitBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(64)
        }
        
        gm_tableView.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(gm_submitBtn.snp.top).offset(-20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_submitAction() {
        guard gm_selectedIndex != nil else {
            ZKProgressHUD.showError("Please select a reason")
            return
        }
        
        ZKProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ZKProgressHUD.showSuccess("Report submitted")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ZKProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension Gm_ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gm_reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gm_ReportCell", for: indexPath) as! Gm_ReportCell
        cell.gm_configure(text: gm_reasons[indexPath.row], isSelected: gm_selectedIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 + 12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gm_selectedIndex = indexPath.row
        tableView.reloadData()
    }
}

// MARK: - Gm_ReportCell

class Gm_ReportCell: UITableViewCell {
    
    private lazy var gm_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.cgColor
        return v
    }()
    
    private lazy var gm_reasonLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gm_setupUI() {
        contentView.addSubview(gm_containerView)
        gm_containerView.addSubview(gm_reasonLb)
        
        gm_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(65)
        }
        
        gm_reasonLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func gm_configure(text: String, isSelected: Bool) {
        gm_reasonLb.text = text
        
        if isSelected {
            gm_containerView.backgroundColor = UIColor(red: 232/255, green: 147/255, blue: 255/255, alpha: 1.0)
            gm_containerView.layer.borderColor = UIColor.white.cgColor
        } else {
            gm_containerView.backgroundColor = .clear
            gm_containerView.layer.borderColor = UIColor.white.cgColor
        }
    }
}
