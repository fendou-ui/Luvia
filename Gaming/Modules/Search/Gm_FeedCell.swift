//
//  Gm_FeedCell.swift
//  Gaming

import UIKit
import SnapKit

class Gm_FeedCell: UICollectionViewCell {
    
    static let gm_id = "Gm_FeedCell"
    
    var gm_moreCallback: (() -> Void)?
    var gm_likeCallback: (() -> Void)?
    var gm_profileCallback: (() -> Void)?
    
    private var gm_isLiked = false
    
    // MARK: - UI
    
    private lazy var gm_coverIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return iv
    }()
    
    private lazy var gm_moreBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_more"), for: .normal)
        btn.addTarget(self, action: #selector(gm_moreTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_likeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "search_love"), for: .normal)
        btn.setImage(UIImage(named: "search_love_101"), for: .selected)
        btn.addTarget(self, action: #selector(gm_likeTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_titleLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = .white
        lb.numberOfLines = 1
        return lb
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var gm_nameLb: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = .white
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private lazy var gm_playIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_player")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        gm_setupUI()
        gm_setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        contentView.addSubview(gm_coverIv)
        contentView.addSubview(gm_playIv)
        contentView.addSubview(gm_moreBtn)
        contentView.addSubview(gm_likeBtn)
        contentView.addSubview(gm_titleLb)
        contentView.addSubview(gm_avatarIv)
        contentView.addSubview(gm_nameLb)
        
        gm_coverIv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        gm_playIv.snp.makeConstraints { make in
            make.center.equalTo(gm_coverIv)
            make.width.height.equalTo(28)
        }
        
        gm_moreBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalToSuperview().offset(6)
            make.width.height.equalTo(32)
        }
        
        gm_likeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-6)
            make.top.equalToSuperview().offset(6)
            make.width.height.equalTo(32)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.top.equalTo(gm_coverIv.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(15)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.top.equalTo(gm_titleLb.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(16)
        }
        
        gm_nameLb.snp.makeConstraints { make in
            make.left.equalTo(gm_avatarIv.snp.right).offset(2)
            make.centerY.equalTo(gm_avatarIv)
        }
    }
    
    private func gm_setupGestures() {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(gm_profileTapped))
        gm_avatarIv.addGestureRecognizer(avatarTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(gm_profileTapped))
        gm_nameLb.addGestureRecognizer(nameTap)
    }
    
    // MARK: - Config
    
    func gm_config(cover: String, title: String, avatar: String, name: String, isLiked: Bool) {
        gm_coverIv.image = UIImage(named: cover)
        gm_titleLb.text = title
        gm_avatarIv.image = UIImage(named: avatar)
        gm_nameLb.text = name
        gm_isLiked = isLiked
        gm_likeBtn.isSelected = isLiked
    }
    
    // MARK: - Actions
    
    @objc private func gm_moreTapped() {
        gm_moreCallback?()
    }
    
    @objc private func gm_likeTapped() {
        gm_isLiked.toggle()
        gm_likeBtn.isSelected = gm_isLiked
        gm_likeCallback?()
    }
    
    @objc private func gm_profileTapped() {
        gm_profileCallback?()
    }
}
