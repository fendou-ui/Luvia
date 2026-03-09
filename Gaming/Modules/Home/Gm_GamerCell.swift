//
//  Gm_GamerCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_GamerCell: UITableViewCell {
    
    static let gm_id = "Gm_GamerCell"
    
    // MARK: - UI
    
    private lazy var gm_cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 4
        v.layer.borderColor = UIColor(red: 0.85, green: 0.68, blue: 0.2, alpha: 1.0).cgColor
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_coverIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // 左上角徽章容器
    private lazy var gm_badgeView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.layer.cornerRadius = 19
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_zuanIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_zuan")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_scoreLb: UILabel = {
        let lb = UILabel()
        lb.text = "99"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = UIColor(red: 0.76, green: 0.57, blue: 0.15, alpha: 1.0)
        return lb
    }()
    
    // 右下角聊天按钮
    private lazy var gm_chatBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_pao"), for: .normal)
        btn.addTarget(self, action: #selector(gm_chatAction), for: .touchUpInside)
        return btn
    }()
    
    // 底部信息容器
    private lazy var gm_infoView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_ageLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 198/255, alpha: 1.0)
        lb.layer.cornerRadius = 8
        lb.clipsToBounds = true
        return lb
    }()
    
    private lazy var gm_tagLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.backgroundColor = UIColor(red: 255/255, green: 112/255, blue: 198/255, alpha: 1.0)
        lb.layer.cornerRadius = 8
        lb.clipsToBounds = true
        return lb
    }()
    
    private lazy var gm_descLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.8)
        lb.numberOfLines = 2
        return lb
    }()
    
    var gm_chatCallback: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        gm_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        contentView.addSubview(gm_cardView)
        gm_cardView.addSubview(gm_coverIv)
        gm_cardView.addSubview(gm_badgeView)
        gm_badgeView.addSubview(gm_zuanIv)
        gm_badgeView.addSubview(gm_scoreLb)
        gm_cardView.addSubview(gm_chatBtn)
        gm_cardView.addSubview(gm_infoView)
        gm_infoView.addSubview(gm_nameLb)
        gm_infoView.addSubview(gm_ageLb)
        gm_infoView.addSubview(gm_tagLb)
        gm_infoView.addSubview(gm_descLb)
        
        gm_cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        gm_coverIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_badgeView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(83)
            make.height.equalTo(38)
        }
        
        gm_zuanIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        gm_scoreLb.snp.makeConstraints { make in
            make.left.equalTo(gm_zuanIv.snp.right).offset(2)
            make.centerY.equalToSuperview()
        }
        
        gm_chatBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-23)
            make.bottom.equalToSuperview().offset(-125)
            make.width.height.equalTo(49)
        }
        
        gm_infoView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(4)
            make.height.equalTo(104)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        
        gm_ageLb.snp.makeConstraints { make in
            make.left.equalTo(gm_nameLb.snp.right).offset(14)
            make.centerY.equalTo(gm_nameLb)
            make.width.equalTo(33)
            make.height.equalTo(23)
        }
        
        gm_tagLb.snp.makeConstraints { make in
            make.left.equalTo(gm_ageLb.snp.right).offset(6)
            make.centerY.equalTo(gm_nameLb)
            make.height.equalTo(23)
            make.width.equalTo(100)
        }
        
        gm_descLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(gm_nameLb.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Config
    
    func gm_config(model: Gm_GamerModel) {
        gm_nameLb.text = model.gm_name
        gm_descLb.text = model.gm_desc
        gm_coverIv.image = UIImage(named: model.gm_cover)
        gm_ageLb.text = "\(model.gm_age)"
        gm_tagLb.text = model.gm_tag
        gm_scoreLb.text = "\(model.gm_score)"
        
        // 更新 tagLb 宽度约束（文本宽度 + 26）
        let tagWidth = model.gm_tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12, weight: .medium)]).width + 26
        gm_tagLb.snp.updateConstraints { make in
            make.width.equalTo(tagWidth)
        }
    }
    
    // MARK: - Actions
    
    @objc private func gm_chatAction() {
        gm_chatCallback?()
    }
}
