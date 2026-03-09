//
//  Gm_MessageCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_MessageCell: UITableViewCell {
    
    static let gm_id = "Gm_MessageCell"
    
    // MARK: - UI
    
    private lazy var gm_containerView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "message_cell_bg")
        iv.contentMode = .scaleToFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 28
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_contentLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_timeLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.textAlignment = .right
        return lb
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(gm_containerView)
        gm_containerView.addSubview(gm_avatarIv)
        gm_containerView.addSubview(gm_nameLb)
        gm_containerView.addSubview(gm_contentLb)
        gm_containerView.addSubview(gm_timeLb)
        
        gm_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(56)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(8)
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(20)
            make.right.lessThanOrEqualTo(gm_timeLb.snp.left).offset(-8)
        }
        
        gm_contentLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(8)
            make.top.equalTo(gm_nameLb.snp.bottom).offset(12)
            make.height.equalTo(18)
            make.right.equalToSuperview().offset(-16)
        }
        
        gm_timeLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(15)
        }
    }
    
    // MARK: - Config
    
    func gm_config(avatar: String, name: String, content: String, time: String) {
        gm_avatarIv.image = UIImage(named: avatar)
        gm_nameLb.text = name
        gm_contentLb.text = content
        gm_timeLb.text = time
    }
}
