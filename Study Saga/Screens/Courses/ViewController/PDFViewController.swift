//
//  PDFViewController.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 05/06/2021.
//

import Foundation
import UIKit
import PDFKit


class PDFViewController: UIViewController {
    
    let headerBar = UIView()
    let titleLbl = UILabel()
    let backBtn = UIButton()
    let pdfView = PDFView()
    
    var documentUrl: String = ""
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(headerBar)
        headerBar.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(self.view.mas_top)
            make?.height.equalTo()(60 + getStatusBarHeight())
        }
        headerBar.backgroundColor = .primary
        headerBar.addSubview(backBtn)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        backBtn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.mas_makeConstraints { make in
            make?.leading.equalTo()(headerBar.mas_leading)?.offset()(10)
            make?.bottom.equalTo()(headerBar.mas_bottom)?.offset()(-10)
            make?.size.equalTo()(30)
        }
        
        headerBar.addSubview(titleLbl)
        titleLbl.textColor = .white
        titleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleLbl.text = self.titleText
        titleLbl.mas_makeConstraints { make in
            make?.leading.equalTo()(headerBar.mas_leading)?.offset()(50)
            make?.trailing.equalTo()(headerBar.mas_trailing)?.offset()(-50)
            make?.centerY.equalTo()(backBtn.mas_centerY)
        }
        
        self.view.addSubview(pdfView)
        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.autoScales = true
        pdfView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.view.mas_leading)
            make?.trailing.equalTo()(self.view.mas_trailing)
            make?.top.equalTo()(headerBar.mas_bottom)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        if let documentUrl = URL(string: self.documentUrl) {
            let document = PDFDocument(url: documentUrl)
            self.pdfView.document = document
        }
    }
    
    @objc func backBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerBar.createViewBackgroundWithAppGradient()
    }
}
