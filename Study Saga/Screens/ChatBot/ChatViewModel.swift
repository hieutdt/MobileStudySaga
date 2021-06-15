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
                                  message: "jalsfkjaksljafskljfaskljfaslkjafsklafjsl asd'lkdas'kdas da'slk das'lkdasl';daksl';daksl; asdl;adksl; das;ladsk ;ladsk adsl;kadsl;kadsl; adsads",
                                  avatarUrl: "",
                                  name: fromName)
            
            self.messages.append(message)
        }
        
        self.prepareMessagesForRender()
    }
    
    func groupMessages() {
        var currentGroupId: String = ""
        var currentType: UIMessageType = .text
        for i in 0..<self.messages.count {
            var mess = messages[i]
            if currentGroupId == "" || currentGroupId != mess.fromId || currentType != mess.type {
                mess.groupState.insert(.bottom)
                
                currentGroupId = mess.fromId
                currentType = mess.type
                
                messages[i] = mess
                
                // Update prev message's group state
                if i > 0 {
                    messages[i - 1].groupState.insert(.top)
                }
            }
        }
    }
    
    func prepareMessagesForRender() {
        if messages.count > 0 && messages.last?.type != .tutorial {
            var tutorialMess = Message()
            tutorialMess.type = .tutorial
            self.messages.append(tutorialMess)
        }
        
        self.groupMessages()
    }
}
