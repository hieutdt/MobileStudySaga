//
//  Message.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import SwiftUI

struct MessageGroupState: OptionSet {
    let rawValue: Int8
    
    static let `default` = MessageGroupState(rawValue: 1 << 0)
    static let top = MessageGroupState(rawValue: 1 << 1 )
    static let bottom = MessageGroupState(rawValue: 1 << 2)
}

enum MessageDeliveryState: Int {
    case unknown = 0
    case delivered
    case delivering
    case failed
}

enum UIMessageType: Int {
    case tutorial
    case text
    case typing
}

/// `Message` model to use in SwiftUI.
///  This model is converted from `MessageEntity`.
struct Message: Hashable {
    var messageId: String
    var roomId: String = ""
    var fromId: String = ""
    var toIDs: [String]
    
    var time: TimeInterval = Date().timeIntervalSince1970
    
    var message: String
    // var meta
    
    var avatarUrl: String = ""
    var name: String = ""
    
    var type: UIMessageType = .text
    
    var groupState: MessageGroupState = []
    var deliveryState: MessageDeliveryState = .unknown
    
    var showDelivering: Bool = false
    
    func isFromCurrentUser() -> Bool {
        return self.fromId == AccountManager.manager.loggedInUser?.id
    }
    
    func isDirectMessage() -> Bool {
        return toIDs.count > 0
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.messageId)
    }
}

extension Message: Identifiable {
    var id: String {
        self.messageId
    }
}

extension Message {
    init() {
        self.messageId = UUID().uuidString
        self.message = ""
        self.time = Date().timeIntervalSince1970
        self.type = .text
        self.fromId = ""
        self.toIDs = []
    }
}
