//
//  Gm_PostViewController.swift
//  Gaming

import UIKit
import SnapKit
import AVFoundation
import Photos
import ZKProgressHUD

class Gm_PostViewController: UIViewController {
    
    // MARK: - Data
    
    var gm_isVideoMode: Bool = true // true: 选择视频, false: 选择图片
    
    private var gm_selectedVideoUrl: URL?
    private var gm_selectedImage: UIImage?
    private lazy var gm_imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    // MARK: - UI
    
    private lazy var gm_bgIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gaming_bg")
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
        lb.text = "Post"
        lb.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .white
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var gm_addVideoBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_add_video"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(gm_addVideoAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_videoContainer: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()
    
    private lazy var gm_videoIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var gm_playIv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Gm_play")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var gm_deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_delete"), for: .normal)
        btn.addTarget(self, action: #selector(gm_deleteVideoAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gm_contentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 247/255, alpha: 0.2)
        v.layer.cornerRadius = 20
        return v
    }()
    
    private lazy var gm_textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .white
        tv.delegate = self
        tv.text = "Please enter the content..."
        tv.textColor = UIColor.white.withAlphaComponent(0.5)
        return tv
    }()
    
    private lazy var gm_countLb: UILabel = {
        let lb = UILabel()
        lb.text = "0/300"
        lb.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lb.textColor = UIColor.white.withAlphaComponent(0.5)
        lb.textAlignment = .right
        return lb
    }()
    
    private lazy var gm_postBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "Gm_post"), for: .normal)
        btn.setTitle("Post", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(gm_submitAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        gm_setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.addSubview(gm_bgIv)
        view.addSubview(gm_backBtn)
        view.addSubview(gm_titleLb)
        view.addSubview(gm_addVideoBtn)
        view.addSubview(gm_videoContainer)
        gm_videoContainer.addSubview(gm_videoIv)
        gm_videoContainer.addSubview(gm_playIv)
        gm_videoContainer.addSubview(gm_deleteBtn)
        view.addSubview(gm_contentView)
        gm_contentView.addSubview(gm_textView)
        gm_contentView.addSubview(gm_countLb)
        view.addSubview(gm_postBtn)
        
        gm_bgIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        gm_addVideoBtn.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(218)
            make.height.equalTo(262)
        }
        
        gm_videoContainer.snp.makeConstraints { make in
            make.top.equalTo(gm_backBtn.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(218)
            make.height.equalTo(262)
        }
        
        gm_videoIv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_playIv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        gm_deleteBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
        
        gm_contentView.snp.makeConstraints { make in
            make.top.equalTo(gm_addVideoBtn.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(200)
        }
        
        gm_textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        gm_countLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        gm_postBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(64)
        }
    }
    
    // MARK: - Actions
    
    @objc private func gm_backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func gm_addVideoAction() {
        if gm_isVideoMode {
            gm_imagePicker.mediaTypes = ["public.movie"]
            gm_imagePicker.videoQuality = .typeHigh
        } else {
            gm_imagePicker.mediaTypes = ["public.image"]
        }
        gm_imagePicker.sourceType = .photoLibrary
        present(gm_imagePicker, animated: true)
    }
    
    private func gm_generateThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("gm_thumbnail_error: \(error)")
            return nil
        }
    }
    
    @objc private func gm_deleteVideoAction() {
        gm_selectedVideoUrl = nil
        gm_selectedImage = nil
        gm_videoContainer.isHidden = true
        gm_addVideoBtn.isHidden = false
        gm_playIv.isHidden = false
    }
    
    @objc private func gm_submitAction() {
        // 判断是否选择图片或视频
        if gm_selectedImage == nil && gm_selectedVideoUrl == nil {
            ZKProgressHUD.showError("Please select a video or image")
            return
        }
        
        // 判断是否有文本内容
        let content = gm_textView.text ?? ""
        if content.isEmpty || content == "Please enter the content..." {
            ZKProgressHUD.showError("Please enter the content")
            return
        }
        
        // 发布加载动画
        ZKProgressHUD.show()
        
        // 模拟发布延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            ZKProgressHUD.dismiss()
            ZKProgressHUD.showSuccess("Post successful")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Public
    
    func gm_setVideo(url: URL, cover: UIImage?) {
        gm_selectedVideoUrl = url
        gm_selectedImage = cover
        gm_videoIv.image = cover
        gm_videoContainer.isHidden = false
        gm_addVideoBtn.isHidden = true
        gm_playIv.isHidden = false
    }
    
    func gm_setImage(_ image: UIImage) {
        gm_selectedImage = image
        gm_selectedVideoUrl = nil
        gm_videoIv.image = image
        gm_videoContainer.isHidden = false
        gm_addVideoBtn.isHidden = true
        gm_playIv.isHidden = true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension Gm_PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if gm_isVideoMode {
            guard let videoUrl = info[.mediaURL] as? URL else { return }
            let thumbnail = gm_generateThumbnail(from: videoUrl)
            gm_setVideo(url: videoUrl, cover: thumbnail)
        } else {
            if let editedImage = info[.editedImage] as? UIImage {
                gm_setImage(editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                gm_setImage(originalImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension Gm_PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.white.withAlphaComponent(0.5) {
            textView.text = ""
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter the content..."
            textView.textColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count <= 300 {
            gm_countLb.text = "\(updatedText.count)/300"
            return true
        }
        return false
    }
}
