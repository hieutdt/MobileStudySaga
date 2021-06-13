//
//  SendMessageCell.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import UIKit
import Combine

import AlamofireImage

class SendMessageCell: UITableViewCell {
    
    static var reuseID = "SendMessageCellReuseId"

    var message: Message? {
        didSet {
            if let message = self.message {
                // Update content text
                self.messageLabel.text = message.message
                
                // Update content text size
                let maxSize = CGSize(width: kMaxMessageWidth, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: message.message)
                    .boundingRect(
                        with: maxSize,
                        options: options,
                        attributes: [.font: UIFont.systemFont(ofSize: 15)],
                        context: nil
                    )
                
                var width = estimatedFrame.width + 5
                
                // Update top private view
                let isTopMessage = message.groupState.contains(.top)
                
                // Update time label
                let isBottomMessage = message.groupState.contains(.bottom)
                timeLabel.isHidden = !isBottomMessage
                if isBottomMessage {
                    timeLabel.text = message.time.getDateString()
                    var timeTextWidth = timeLabel.text?.width(
                        withConstrainedHeight: 11,
                        font: .systemFont(ofSize: 11)) ?? 0
                    timeTextWidth += 10
                    width = max(width, timeTextWidth)
                }
                
                // Update lock icon's position
                if isTopMessage {
                    self.bubbleHStack.alignment = .top
                } else {
                    self.bubbleHStack.alignment = .center
                }
                
                // Update sending indicator
                if message.showDelivering {
                    self.sendingIndicator.isHidden = false
                    self.sendingIndicator.startAnimating()
                } else {
                    self.sendingIndicator.stopAnimating()
                    self.sendingIndicator.isHidden = true
                }
                
                // Resize bubble
                self.messageHeightConstraint?.constant = estimatedFrame.height + 5
                self.messageWidthConstraint?.constant =  min(width, CGFloat(kMaxMessageWidth))
            }
        }
    }
    
    /// UI properties
    private var mainStackView = UIStackView()
    
    private var bubbleHStack = UIStackView()
    private var bubbleVStack = UIStackView()
    private var backgroundImgView = UIImageView()
    
    private var messageLabel = UILabel()
    private var timeLabel = UILabel()
    
    private var sendingIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .medium
        activityView.hidesWhenStopped = true
        activityView.color = .lightGray
        return activityView
    }()
    
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
        //  Main Stack View
        //-----------------------------------------------
        self.contentView.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.alignment = .trailing
        mainStackView.distribution = .fill
        mainStackView.backgroundColor = .clear
        mainStackView.spacing = 5
        mainStackView.isUserInteractionEnabled = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
        
        //-----------------------------------------------
        //  Bubble Background
        //-----------------------------------------------
        mainStackView.addArrangedSubview(backgroundImgView)
        backgroundImgView.contentMode = .scaleToFill
        backgroundImgView.image = UIImage(named: "chat_bubble_send")?
            .resizableImage(
                withCapInsets: UIEdgeInsets(top: 15, left: 21, bottom: 15, right: 21),
                resizingMode: .stretch
            )
        backgroundImgView.mas_makeConstraints { make in
            make?.trailing.equalTo()(self.mainStackView.mas_trailing)?.offset()(-5)
        }
        
        //-----------------------------------------------
        //  Sending Indicator
        //-----------------------------------------------
        self.contentView.addSubview(sendingIndicator)
        sendingIndicator.mas_makeConstraints { make in
            make?.trailing.equalTo()(backgroundImgView.mas_leading)?.offset()(-20)
            make?.centerY.equalTo()(backgroundImgView.mas_centerY)
            make?.size.equalTo()(20)
        }
        
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
            make?.top.equalTo()(backgroundImgView.mas_top)?.offset()(5)
            make?.bottom.equalTo()(backgroundImgView.mas_bottom)?.offset()(-5)
            make?.leading.equalTo()(backgroundImgView.mas_leading)?.offset()(5)
            make?.trailing.equalTo()(backgroundImgView.mas_trailing)?.offset()(-5)
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
        messageLabel.numberOfLines = 100
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

