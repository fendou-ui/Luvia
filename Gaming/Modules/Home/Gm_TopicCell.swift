//
//  Gm_TopicCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_TopicCell: UITableViewCell {
    
    // MARK: - Callbacks
    
    var gm_reportCallback: (() -> Void)?
    var gm_likeCallback: (() -> Void)?
    var gm_avatarCallback: (() -> Void)?
    
    private var gm_isLiked = false
    
    // MARK: - UI
    
    private lazy var gm_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 40/255, green: 36/255, blue: 113/255, alpha: 1.0)
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_avatarTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .white
        return lb
    }()
    
    private lazy var gm_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_more"), for: .normal)
        btn.addTarget(self, action: #selector(gm_reportTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_likeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "search_love"), for: .normal)
        btn.setImage(UIImage(named: "search_love_101"), for: .selected)
        btn.addTarget(self, action: #selector(gm_likeTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_contentIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    private lazy var gm_contentLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = .white
        lb.numberOfLines = 2
        return lb
    }()
    
    private lazy var gm_contentBgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 132/255, green: 0/255, blue: 176/255, alpha: 0.2)
        v.layer.cornerRadius = 8
        return v
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
        gm_containerView.addSubview(gm_avatarIv)
        gm_containerView.addSubview(gm_nameLb)
        gm_containerView.addSubview(gm_reportBtn)
        gm_containerView.addSubview(gm_likeBtn)
        gm_containerView.addSubview(gm_contentIv)
        gm_containerView.addSubview(gm_contentBgView)
        gm_contentBgView.addSubview(gm_contentLb)
        
        gm_containerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(40)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(8)
            make.centerY.equalTo(gm_avatarIv)
        }
        
        gm_likeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(gm_avatarIv)
            make.width.height.equalTo(32)
        }
        
        gm_reportBtn.snp.makeConstraints { make in
            make.right.equalTo(gm_likeBtn.snp.left).offset(-8)
            make.centerY.equalTo(gm_avatarIv)
            make.width.height.equalTo(32)
        }
        
        gm_contentIv.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(gm_avatarIv.snp.bottom).offset(14)
            make.height.equalTo(193)
        }
        
        gm_contentBgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-18)
        }
        
        gm_contentLb.snp.makeConstraints { make in
            make.left.equalTo(gm_contentBgView).offset(10)
            make.right.equalTo(gm_contentBgView).offset(-10)
            make.top.equalTo(gm_contentBgView).offset(7)
            make.bottom.equalTo(gm_contentBgView).offset(-7)
        }
    }
    
    // MARK: - Config
    
    func gm_config(model: Gm_TopicModel) {
        gm_avatarIv.image = UIImage(named: model.gm_avatar)
        gm_nameLb.text = model.gm_name
        gm_contentIv.image = UIImage(named: model.gm_image)
        gm_contentLb.text = model.gm_content
        gm_isLiked = model.gm_isLiked
        gm_likeBtn.isSelected = gm_isLiked
    }
    
    // MARK: - Actions
    
    @objc private func gm_reportTapped() {
        gm_reportCallback?()
    }
    
    @objc private func gm_likeTapped() {
        gm_isLiked.toggle()
        gm_likeBtn.isSelected = gm_isLiked
        gm_likeCallback?()
    }
    
    @objc private func gm_avatarTapped() {
        gm_avatarCallback?()
    }
}
