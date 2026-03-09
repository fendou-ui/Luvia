//
//  Gm_GuideViewController.swift
//  Gaming
//
//  引导页 - 3页滑动引导

import UIKit
import SnapKit

class Gm_GuideViewController: UIViewController {
    
    // MARK: - Data
    
    private let gm_pages: [String] = ["Gm_9490", "Gm_9491", "Gm_9492"]
    
    private var gm_currentIndex = 0
    
    // MARK: - UI
    
    private lazy var gm_scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = false
        sv.delegate = self
        return sv
    }()
    
    private lazy var gm_contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var gm_pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = gm_pages.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    private lazy var gm_nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "Gm_next"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(gm_nextAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gm_setupUI()
        gm_setupPages()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func gm_setupUI() {
        view.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(gm_scrollView)
        gm_scrollView.addSubview(gm_contentView)
        view.addSubview(gm_pageControl)
        view.addSubview(gm_nextBtn)
        
        gm_scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gm_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(gm_scrollView)
            make.width.equalTo(gm_scrollView).multipliedBy(gm_pages.count)
        }
        
        gm_nextBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-35)
            make.width.equalTo(163)
            make.height.equalTo(64)
        }
        
        gm_pageControl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(gm_nextBtn)
        }
    }
    
    private func gm_setupPages() {
        for (index, imageName) in gm_pages.enumerated() {
            let pageView = gm_createPageView(image: imageName)
            gm_contentView.addSubview(pageView)
            
            pageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(gm_scrollView)
                make.left.equalToSuperview().offset(CGFloat(index) * UIScreen.main.bounds.width)
            }
        }
    }
    
    private func gm_createPageView(image: String) -> UIView {
        let container = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        container.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func gm_nextAction() {
        if gm_currentIndex < gm_pages.count - 1 {
            gm_currentIndex += 1
            let offsetX = CGFloat(gm_currentIndex) * gm_scrollView.bounds.width
            gm_scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            gm_pageControl.currentPage = gm_currentIndex
        } else {
            // 最后一页，进入主页
            gm_enterMainPage()
        }
    }
    
    private func gm_enterMainPage() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let tabBarVC = Gm_MainTabBarController()
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension Gm_GuideViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        gm_currentIndex = page
        gm_pageControl.currentPage = page
    }
}
