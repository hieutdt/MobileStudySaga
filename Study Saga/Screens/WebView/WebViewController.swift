//
//  WebViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 20/06/2021.
//

import Foundation
import UIKit
import Masonry
import WebKit


class WebViewController: UIViewController {
    
    var headerView = UIView()
    var dismissBtn = UIButton()
    var titleLabel = UILabel()
    
    var webView = WKWebView()
    
    var feed: FeedModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.hide()
        
        self.setUpHeaderBar()
        
        self.view.addSubview(webView)
        webView.mas_makeConstraints { make in
            make?.top.equalTo()(self.headerView.mas_bottom)
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        if let url = URL(string: self.feed.url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.createViewBackgroundWithAppGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = feed.title
    }
    
    func setUpHeaderBar() {
        self.view.addSubview(headerView)
        headerView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(self.view.mas_top)
            make?.height.equalTo()(50 + getStatusBarHeight())
        }
        
        headerView.addSubview(dismissBtn)
        dismissBtn.addTarget(self, action: #selector(dismissBtnDidTap), for: .touchUpInside)
        let systemImageName = self.navigationController != nil ? "chevron.left" : "xmark"
        dismissBtn.setImage(UIImage(systemName: systemImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        dismissBtn.tintColor = .white
        dismissBtn.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(10)
            make?.size.equalTo()(30)
            make?.bottom.equalTo()(headerView.mas_bottom)?.offset()(-10)
        }
        
        headerView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLabel.textAlignment = .center
        titleLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(headerView.mas_leading)?.offset()(50)
            make?.trailing.equalTo()(headerView.mas_trailing)?.offset()(-10)
            make?.centerY.equalTo()(dismissBtn.mas_centerY)
        }
    }
    
    @objc func dismissBtnDidTap() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
