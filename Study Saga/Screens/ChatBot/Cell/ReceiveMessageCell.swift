//
//  ReceiveMessageCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import UIKit
import Combine

import AlamofireImage
 
let kMaxMessageWidth = 260

class ReceiveMessageCell: UITableViewCell {
    
    static var reuseID = "ReceiveMessageCellReuseId"
    
    let avatarSize: CGFloat = 30
    
    var message: Message? {
        didSet {
            guard let message = self.message else {
                return
            }
            
            // Update content text
            self.messageLabel.text = message.message
            
            // Update content text size
            let maxSize = CGSize(width: kMaxMessageWidth, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading
                .union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: message.message)
                .boundingRect(
                    with: maxSize,
                    options: options,
                    attributes: [.font : UIFont.systemFont(ofSize: 15)],
                    context: nil
                )
            
            var width = estimatedFrame.width + 5
            
            let isTopMessage = message.groupState.contains(.top)
            
            // Update time label
            let isBottomMessage = message.groupState.contains(.bottom)
            timeLabel.isHidden = !isBottomMessage
            timeLabel.text = message.time.getDateString()
            let timeTextWidth = timeLabel.text!.width(withConstrainedHeight: 11,
                                                      font: .systemFont(ofSize: 11))
            if isBottomMessage {
                width = max(width, timeTextWidth + 10)
            }
            
            // Update avatar
            avatarImgView.isHidden = !isTopMessage
            avatarImgView.contentMode = .scaleAspectFill
            if isTopMessage {
                avatarImgView.image = chatBotImg
            }
//            if let url = URL(string: message.avatarUrl), isTopMessage {
//                avatarImgView.af.setImage(
//                    withURL: url,
//                    filter: CircleFilter()
//                )
//            } else {
//                avatarImgView.image = UIImage(named: "")
//            }
            
            if isTopMessage {
                bubbleHStack.alignment = .top
            } else {
                bubbleHStack.alignment = .center
            }
            
            // Resize bubble
            self.messageHeightConstraint?.constant = estimatedFrame.height + 5
            self.messageWidthConstraint?.constant =  min(width, CGFloat(kMaxMessageWidth))
        }
    }
    
    /// UI properties
    private var bubbleVStack = UIStackView()
    private var bubbleHStack = UIStackView()
    private var backgroundImgView = UIImageView()
    private var avatarImgView = UIImageView()
    
    private var messageLabel = UILabel()
    private var timeLabel = UILabel()
    
    private var messageWidthConstraint: NSLayoutConstraint?
    private var messageHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.setUpUI()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.transform = CGAffineTransform(scaleX: -1, y: -1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        //-----------------------------------------------
        //  Avatar Image View
        //-----------------------------------------------
        self.contentView.addSubview(avatarImgView)
        avatarImgView.mas_makeConstraints { make in
            make?.size.equalTo()(avatarSize)
        }
        NSLayoutConstraint.activate([
            avatarImgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            avatarImgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2)
        ])
        
        //-----------------------------------------------
        //  Bubble Background
        //-----------------------------------------------
        self.contentView.addSubview(backgroundImgView)
        backgroundImgView.contentMode = .scaleToFill
        backgroundImgView.image = UIImage(named: "chat_bubble_receive")?
            .resizableImage(
                withCapInsets: UIEdgeInsets(top: 15, left: 21, bottom: 15, right: 21),
                resizingMode: .stretch
            )
        backgroundImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImgView.leadingAnchor.constraint(equalTo: avatarImgView.trailingAnchor, constant: 10),
            backgroundImgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            backgroundImgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2)
        ])
        
        //-----------------------------------------------
        //  Bubble HStack View
        //-----------------------------------------------
        backgroundImgView.addSubview(bubbleHStack)
        bubbleHStack.axis = .horizontal
        bubbleHStack.alignment = .center
        bubbleHStack.distribution = .fill
        bubbleHStack.backgroundColor = .clear
        bubbleHStack.spacing = 2
        bubbleHStack.isUserInteractionEnabled = false
        bubbleHStack.layer.masksToBounds = true
        bubbleHStack.mas_makeConstraints { make in
            make?.edges.equalTo()(backgroundImgView)?.inset()(5)
        }
        
        //-----------------------------------------------
        //  Bubble VStack View
        //-----------------------------------------------
        bubbleHStack.addArrangedSubview(bubbleVStack)
        bubbleVStack.axis = .vertical
        bubbleVStack.alignment = .leading
        bubbleVStack.distribution = .fill
        bubbleVStack.backgroundColor = .clear
        bubbleVStack.spacing = 10
        bubbleVStack.isUserInteractionEnabled = false
        bubbleVStack.layer.masksToBounds = true

        //-----------------------------------------------
        //  Message Content Label
        //-----------------------------------------------
        bubbleVStack.addArrangedSubview(messageLabel)
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.textColor = .black
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 1000
        messageLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(bubbleVStack.mas_leading)
            make?.trailing.equalTo()(bubbleVStack.mas_trailing)
        }

        messageWidthConstraint = messageLabel.widthAnchor.constraint(equalToConstant: 0)
        messageWidthConstraint?.isActive = true
        messageHeightConstraint = messageLabel.heightAnchor.constraint(equalToConstant: 0)
        messageHeightConstraint?.isActive = true
        
        //-----------------------------------------------
        //  Time Label
        //-----------------------------------------------
        bubbleVStack.addArrangedSubview(timeLabel)
        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.backgroundColor = .clear
        timeLabel.textColor = .lightGray
        timeLabel.mas_makeConstraints { make in
            make?.leading.equalTo()(bubbleVStack.mas_leading)?.offset()(10)
            make?.trailing.equalTo()(bubbleVStack.mas_trailing)?.offset()(-10)
            make?.bottom.equalTo()(bubbleVStack.mas_bottom)?.offset()(-10)
            make?.height.equalTo()(11)
        }
    }
}

extension TimeInterval {

    func getDateString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()

        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "HH:mm dd-MM-yyyy"
        }

        return formatter.string(from: date)
    }
}
