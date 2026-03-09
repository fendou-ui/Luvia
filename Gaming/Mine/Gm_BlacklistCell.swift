//
//  Gm_BlacklistCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_BlacklistCell: UITableViewCell {
    
    var gm_removeCallback: (() -> Void)?
    
    // MARK: - UI
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_removeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Profile_remove"), for: .normal)
        btn.addTarget(self, action: #selector(gm_removeTapped), for: .touchUpInside)
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
        contentView.addSubview(gm_avatarIv)
        contentView.addSubview(gm_nameLb)
        contentView.addSubview(gm_removeBtn)
        
        gm_avatarIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        gm_removeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - Config
    
    func gm_config(model: Gm_BlockedUser) {
        gm_avatarIv.image = UIImage(named: model.gm_avatar)
        gm_nameLb.text = model.gm_name
    }
    
    // MARK: - Actions
    
    @objc private func gm_removeTapped() {
        gm_removeCallback?()
    }
}
