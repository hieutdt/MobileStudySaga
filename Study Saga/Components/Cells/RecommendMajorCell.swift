//
//  RecommendMajorCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 12/06/2021.
//

import Foundation
import UIKit
import AlamofireImage
import Masonry


class RecommendMajorCell: UICollectionViewCell {
    
    static let reuseId = "RecommendMajorCellReuseId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: Major? {
        didSet {
            if let model = self.model {
                self.label.text = model.name
                if let url = URL(string: model.thumbUrl) {
                    self.thumbImageView.af.setImage(withURL: url)
                }
            }
        }
    }
    
    // UI properties
    var thumbImageView = UIImageView()
    var label = UILabel()
    var labelContainer = UIView()
    var gradientLayer: CAGradientLayer?
    
    func customInit() {
        
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.backgroundColor = .systemBlue
        self.contentView.addSubview(thumbImageView)
        thumbImageView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)
            make?.trailing.equalTo()(self.contentView.mas_trailing)
            make?.top.equalTo()(self.contentView.mas_top)
            make?.bottom.equalTo()(self.contentView.mas_bottom)
        }
        
        labelContainer.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        labelContainer.layer.cornerRadius = 5
        self.contentView.addSubview(labelContainer)
        labelContainer.mas_makeConstraints { make in
            make?.leading.equalTo()(self.contentView.mas_leading)?.offset()(10)
            make?.bottom.equalTo()(self.contentView.mas_bottom)?.offset()(-10)
        }
        
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        labelContainer.addSubview(label)
        label.mas_makeConstraints { make in
            make?.top.equalTo()(labelContainer.mas_top)?.offset()(4)
            make?.bottom.equalTo()(labelContainer.mas_bottom)?.offset()(-4)
            make?.leading.equalTo()(labelContainer.mas_leading)?.offset()(8)
            make?.trailing.equalTo()(labelContainer.mas_trailing)?.offset()(-8)
        }
        
        self.addGradientLayer()
    }
    
    func addGradientLayer() {
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
            self.gradientLayer = nil
        }
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.colors = [UIColor(hexString: "#000000", alpha: 0).cgColor,
                                      UIColor(hexString: "#000000", alpha: 0.6).cgColor]
        self.gradientLayer?.locations = [0.5, 1]
        self.gradientLayer?.frame = self.contentView.bounds
        
        self.contentView.layer.addSublayer(self.gradientLayer!)
        self.contentView.bringSubviewToFront(self.labelContainer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 20
    }
}
