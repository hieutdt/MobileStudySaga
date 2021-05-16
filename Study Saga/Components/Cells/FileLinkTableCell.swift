//
//  FileLinkTableCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 4/7/21.
//

import Foundation
import UIKit
import Masonry


protocol FileLinkTableCellDelegate: NSObject {
    func didSelectCell(_ cell: FileLinkTableCell)
}

class FileLinkTableCell: UITableViewCell {
    
    static let reuseId = "FileLinkTableCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: FileLinkTableCellDelegate? = nil
    
    var document: Document? {
        didSet {
            if let document = self.document {
                if document.type == .docx {
                    iconImageView.image = UIImage(named: "docx")
                } else if document.type == .pdf {
                    iconImageView.image = UIImage(named: "pdf")
                } else {
                    iconImageView.image = UIImage(named: "")
                }
                
                let attributedText = NSMutableAttributedString(string: document.name)
                let rangeToUnderline = NSRange(location: 0, length: document.name.lenght)
                attributedText.addAttribute(
                    NSAttributedString.Key.underlineStyle,
                    value: NSUnderlineStyle.single.rawValue,
                    range: rangeToUnderline
                )
                attributedText.addAttributes(
                    [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)!],
                    range: rangeToUnderline
                )
                self.nameLabel.attributedText = attributedText
            }
        }
    }
    
    var container = UIButton()
    
    var iconImageView = UIImageView()
    
    var nameLabel: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = UIColor.systemBlue
        return lbl
    }()
    
    private func customInit() {
        
        self.contentView.isUserInteractionEnabled = false
        
        self.addSubview(container)
        container.addSubview(iconImageView)
        container.addSubview(nameLabel)
        
        container.backgroundColor = .clear
        container.layer.cornerRadius = 10
        container.setBackgroundColor(color: .lightGray, forState: .highlighted   )
        container.mas_makeConstraints { make in
            make?.leading.equalTo()(self.mas_leading)?.with()?.offset()(10)
            make?.trailing.equalTo()(self.mas_trailing)?.with()?.offset()(-10)
            make?.top.equalTo()(self.mas_top)?.with()?.offset()(5)
            make?.bottom.equalTo()(self.mas_bottom)?.with()?.offset()(-5)
        }
        container.addTarget(self, action: #selector(didSelectCell), for: .touchUpInside)
        
        iconImageView.mas_makeConstraints { make in
            make?.leading.equalTo()(container.mas_leading)?.with()?.offset()(12)
            make?.size.equalTo()(25)
            make?.centerY.equalTo()(container.mas_centerY)
        }
        
        nameLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(iconImageView.mas_trailing)?.with()?.offset()(10)
            make?.trailing.equalTo()(container.mas_trailing)?.with()?.offset()(-12)
            make?.centerY.equalTo()(container.mas_centerY)
        }
    }
    
    func setBackground(_ color: UIColor) {
        self.container.backgroundColor = color
    }
    
    @objc func didSelectCell() {
        self.delegate?.didSelectCell(self)
    }
}
