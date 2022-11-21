//
//  MessagingModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class MessagingModel: ObservableObject {
    
    public var users = [String]()
    public var chatId: String
    public var chatData: ChatsData
    private let dbManager = FirestoreManager()
    private let googleAuthModel = GoogleAuthModel()
    
    @Published var messages = [MessageData]()
    @Published var isFetching: Bool = false
    
    init(chatData: ChatsData) {
        self.chatId = chatData.id
        self.chatData = chatData
        createChat(chatData: chatData)
        populateUsers()
        //startTimer()
    }
    
    private func startTimer() {
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchMessages), userInfo: nil, repeats: true)
    }
    
    private func populateUsers() {
        dbManager.fetchTheseChatUsersIDs(chatId: chatId) { users in
            self.users = users
        }
    }
    
//    @objc private func fetchMessages() {
//        print("working")
//        dbManager.fetchMessagesFrom(chatId: chatId) { messages in
//            self.messages = messages.reversed()
//            self.isFetching = false
//        }
//
//    }
    
    public func sendMessage(content: String) {
       let user = googleAuthModel.getCurrentUser()
//        if !users.contains(user.emailAddress) {
//            dbManager.addUserToChat(chatId: chatId, userId: user.emailAddress, userIds: users)
//            populateUsers()
//        }
//        dbManager.addMessageToChat(chatId: chatId, userId: user.emailAddress, content: content, messages: messages)
        messages.append(MessageData(content: content, user: user))
    }
    
    private func createChat(chatData: ChatsData) {
        dbManager.createChatInfo(chatData: chatData)
    }
    
}
