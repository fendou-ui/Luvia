//
//  Gm_ActionBarView.swift
//  Gaming

import UIKit
import SnapKit

class Gm_ActionBarView: UIView {
    
    // MARK: - Callbacks
    
    var gm_blockCallback: (() -> Void)?
    var gm_reportCallback: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var gm_blockBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(gm_blockTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_blockIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_people")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_blockLb: UILabel = {
        let lb = UILabel()
        lb.text = "Block"
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(gm_reportTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_reportIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_report")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_reportLb: UILabel = {
        let lb = UILabel()
        lb.text = "Report"
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        lb.textAlignment = .center
        return lb
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        addSubview(gm_blockBtn)
        gm_blockBtn.addSubview(gm_blockIv)
        gm_blockBtn.addSubview(gm_blockLb)
        
        addSubview(gm_reportBtn)
        gm_reportBtn.addSubview(gm_reportIv)
        gm_reportBtn.addSubview(gm_reportLb)
        
        gm_blockIv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        gm_blockLb.snp.makeConstraints { make in
            make.top.equalTo(gm_blockIv.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        gm_blockBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
        
        gm_reportIv.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        gm_reportLb.snp.makeConstraints { make in
            make.top.equalTo(gm_reportIv.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        gm_reportBtn.snp.makeConstraints { make in
            make.left.equalTo(gm_blockBtn.snp.right).offset(59)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
        }
    }
    
    // MARK: - Actions
    
    @objc private func gm_blockTapped() {
        gm_blockCallback?()
    }
    
    @objc private func gm_reportTapped() {
        gm_reportCallback?()
    }
}
