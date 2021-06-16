//
//  ChatViewModel.swift
//  Study Saga
//
//  Created by Trần Đình Tôn Hiếu on 13/06/2021.
//

import Foundation
import Combine
import Alamofire

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    
    var messageDidAdd = PassthroughSubject<Message, Never>()
    
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
    
    func sendMessage(_ message: String) {
        // Update UI first
        let user = AccountManager.manager.loggedInUser!
        var messageModel = Message(messageId: UUID().uuidString,
                                   roomId: UUID().uuidString,
                                   fromId: user.id,
                                   toIDs: [],
                                   message: message,
                                   avatarUrl: "",
                                   name: user.name)
        messageModel.type = .text
        
        self.messages.insert(messageModel, at: 0)
        self.messageDidAdd.send(messageModel)
        
        // Send request
        guard let token = AccountManager.manager.cachingToken else {
            return
        }
        
        let url = "\(kDomain)/api/rasa/chatbot"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "*/*"
        ]
        
        let params = [
            "message": message
        ]
        
        // Send request.
        AF.request(
            url,
            method: .post,
            parameters: params,
            encoder: JSONParameterEncoder.default,
            headers: headers) { urlRequest in
            urlRequest.timeoutInterval = 15
            urlRequest.allowsConstrainedNetworkAccess = true
        }
        .responseJSON { response in
            if let value = response.value as? [String: Any] {
                
                let data = value.arrayDictForKey("data")
                if !data.isEmpty {
                    let dataDict = data[0]
                    let responeText = dataDict.stringValueForKey("text")
                    var repMessage = Message(messageId: UUID().uuidString,
                                             roomId: UUID().uuidString,
                                             fromId: "Bot",
                                             toIDs: [],
                                             message: responeText,
                                             avatarUrl: "",
                                             name: "Bot")
                    repMessage.groupState.insert(.top)
                    self.messages.insert(repMessage, at: 0)
                    self.messageDidAdd.send(repMessage)
                }
            }
        }
    }
}
