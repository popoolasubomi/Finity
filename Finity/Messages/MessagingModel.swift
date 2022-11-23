//
//  MessagingModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class MessagingModel: ObservableObject {
    
    public var chatData: ChatsData
    private var chatUsers = [String]()
    private let dbManager = FirestoreManager()
    
    @Published var messages = [MessageData]()
    @Published var isFetching: Bool = false
    
    init(chatData: ChatsData) {
        self.chatData = chatData
    }
    
    public func fetchMessages() {
        dbManager.createChatInfo(chatData: chatData) { success in
            if success {
                self.dbManager.fetchMessagesFrom(chatId: self.chatData.id) { messages, users in
                    self.messages = messages
                    self.chatUsers = users
                }
            }
        }
    }
    
    public func sendMessage(content: String) {
        let user = GoogleAuthModel().getCurrentUser()
        if !chatUsers.contains(user.emailAddress) {
            dbManager.addUserToChat(chatId: chatData.id, userId: user.emailAddress)
        }
        dbManager.addMessageToChat(chatId: chatData.id, userId: user.emailAddress, content: content)
    }
}
