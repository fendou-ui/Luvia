//
//  Gm_EditProfileViewController.swift
//  Gaming

import UIKit
import SnapKit
import ZKProgressHUD

class Gm_EditProfileViewController: UIViewController {
    
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
        lb.text = "Edit Profile"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_avatarIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_deafult_cell")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gm_avatarTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private lazy var gm_nameTf: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        tf.layer.cornerRadius = 30
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textAlignment = .center
        tf.text = "Pink Scorpio"
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        return tf
    }()
    
    private lazy var gm_saveBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.setBackgroundImage(UIImage(named: "Gm_post"), for: .normal)
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_saveAction), for: .touchUpInside)
        return btn
    }()
    
    private var gm_selectedImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 23/255, green: 25/255, blue: 31/255, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
        gm_loadUserData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_avatarIv)
        view.addSubview(gm_nameTf)
        view.addSubview(gm_saveBtn)
        
        gm_backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.height.equalTo(40)
        }
        
        gm_titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(gm_backBtn)
        }
        
        gm_avatarIv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gm_backBtn.snp.bottom).offset(50)
            make.width.height.equalTo(180)
        }
        
        gm_nameTf.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(gm_avatarIv.snp.bottom).offset(40)
            make.height.equalTo(60)
        }
        
        gm_saveBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(60)
        }
    }
    
    private func gm_loadUserData() {
        let name = UserDefaults.standard.string(forKey: "gm_user_name") ?? "Pink Scorpio"
        gm_nameTf.text = name
        
        if let avatarData = UserDefaults.standard.data(forKey: "gm_user_avatar"),
           let image = UIImage(data: avatarData) {
            gm_avatarIv.image = image
        }
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_avatarTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self?.present(picker, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            picker.sourceType = .photoLibrary
            self?.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func gm_saveAction() {
        guard let name = gm_nameTf.text, !name.isEmpty else {
            ZKProgressHUD.showError("Please enter your name")
            return
        }
        
        UserDefaults.standard.set(name, forKey: "gm_user_name")
        
        if let image = gm_selectedImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "gm_user_avatar")
        }
        
        ZKProgressHUD.showSuccess("Saved successfully")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension Gm_EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            gm_selectedImage = image
            gm_avatarIv.image = image
        } else if let image = info[.originalImage] as? UIImage {
            gm_selectedImage = image
            gm_avatarIv.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
