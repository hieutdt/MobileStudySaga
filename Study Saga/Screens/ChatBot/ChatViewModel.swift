//
//  ChatViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import Combine


class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    
    init() {
        for _ in 0...100 {
            let isSendMessage = Bool.random()
            let fromId = isSendMessage ? AccountManager.manager.loggedInUser!.id : "Bot"
            let fromName = isSendMessage ? AccountManager.manager.loggedInUser!.name : "Bot"
            let message = Message(messageId: UUID().uuidString,
                                  roomId: UUID().uuidString,
                                  fromId: fromId,
                                  toIDs: [],
                                  message: "jalsfkjaksljafskljfaskljfaslkjafsklafjsl",
                                  avatarUrl: "",
                                  name: fromName)
            
            self.messages.append(message)
        }
    }
}
