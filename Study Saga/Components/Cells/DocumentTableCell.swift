//
//  DocumentTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 3/11/21.
//

import Foundation
import UIKit
import Combine
import Masonry

protocol DocumentTableCellDelegate: NSObject {
    
    func didSelectDocumentCell(_ cell: DocumentTableCell)
}

class DocumentTableCell: UITableViewCell {
    
    static let reuseId = "DocumentTableCellReuseId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: DocumentTableCellDelegate? = nil
    
    var model: Document? {
        didSet {
            if let model = self.model {
                nameLbl.text = model.name
                if model.type == .docx {
                    documentTypeImg.image = UIImage(named: "docx")
                } else {
                    documentTypeImg.image = UIImage(named: "pdf")
                }
            }
        }
    }
    
    var shadowView = ShadowView()
    
    var container = UIButton()
    
    var documentTypeImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var nameLbl: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    func customInit() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.addSubview(shadowView)
        shadowView.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-5)
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(5)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-5)
            make?.height.equalTo()(50)
        }
        
        //-------------------------------------------------------------------
        //  Container Button
        //-------------------------------------------------------------------
        container.setBackgroundColor(color: .white, forState: .normal)
        container.setBackgroundColor(color: .lightGray, forState: .highlighted)
        container.layer.cornerRadius = 10
        self.addSubview(container)
        container.mas_makeConstraints { make in
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-5)
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(5)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-5)
            make?.height.equalTo()(50)
        }
        
        //-------------------------------------------------------------------
        //  Document Type Image View
        //-------------------------------------------------------------------
        container.addSubview(documentTypeImg)
        documentTypeImg.mas_makeConstraints { make in
            make?.top.equalTo()(container.mas_top)?.with()?.offset()(10)
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(10)
            make?.size.equalTo()(30)
            make?.bottom.equalTo()(container.mas_bottom)?.with()?.offset()(-10)
        }
        
        //-------------------------------------------------------------------
        //  Name Label
        //-------------------------------------------------------------------
        container.addSubview(nameLbl)
        nameLbl.mas_makeConstraints { make in
            make?.leading.equalTo()(documentTypeImg.mas_trailing)?.with()?.offset()(10)
            make?.centerY.equalTo()(documentTypeImg.mas_centerY)
        }
        
        container.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
    }
    
    @objc func didSelectCell() {
        if let delegate = self.delegate {
            delegate.didSelectDocumentCell(self)
        }
    }
}
