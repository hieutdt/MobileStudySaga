//
//  EmptyDeadlinesView.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/26/21.
//

import Foundation
import UIKit
import Masonry


class EmptyDeadlinesView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }
    
    var imageView = UIImageView()
    
    var label: UILabel = {
        var lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 10
        return lbl
    }()
    
    func customInit() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleToFill
        imageView.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(20)
            make?.centerY.equalTo()(self.mas_centerY)
            make?.size.equalTo()(120)
        }
        
        label.mas_makeConstraints { make in
            make?.leading.equalTo()(imageView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-20)
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(10)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-10)
        }
    }
    
    func setEmptyView(with title: String,
                      image: UIImage,
                      backgroundColor: UIColor = .clear) {
        self.label.text = title
        self.imageView.image = image
        self.backgroundColor = backgroundColor
    }
}
