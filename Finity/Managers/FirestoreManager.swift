//
//  FirestoreManager.swift
//  Finity
//
//  Created by Subomi Popoola on 11/18/22.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreManager {
    
    var database: Firestore
    private var userStore = [String: User]()
    private var googleAuthModel = GoogleAuthModel()
    
    init() {
        database = Firestore.firestore()
    }
    
    private func verifyUserExists(
        emailAddress: String,
        handler: @escaping(_ userExists: Bool) -> Void
    ) {
        database.collection("users").document(emailAddress).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                handler(false)
                return
            }
            handler(snapshot.exists)
        }
    }

    
    private func verifyChatExists(chatId: String, handler: @escaping(_ chatExists: Bool) -> Void) {
        database.collection("chats").document(chatId).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                handler(false)
                return
            }
            handler(snapshot.exists)
        }
    }
    
    private func registerUser(
        firstName: String,
        lastName: String,
        pictureUrl: String,
        emailAddress: String
    ) {
        database.collection("users").document(emailAddress).setData([
            "first": firstName,
            "last": lastName,
            "profile_url": pictureUrl,
            "email_address": emailAddress
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(emailAddress)")
            }
        }
    }
    
    public func fetchAllUsers(handler: @escaping(_ users: [User]) -> Void) {
        var users = [User]()
        let currentUser = googleAuthModel.getCurrentUser()
        database.collection("users").getDocuments { documentSnaps, error in
            if error == nil {
                documentSnaps?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = User(
                        firstName: data["first"] as! String,
                        lastName: data["last"] as! String,
                        emailAddress: snapshot.documentID,
                        profilePictureURL: data["profile_url"] as! String,
                        isCurrentUser: currentUser.emailAddress == snapshot.documentID
                    )
                    if user.isCurrentUser ?? false {
                        users.insert(user, at: 0)
                    } else {
                        users.append(user)
                    }
                })
                handler(users)
            }
            handler([])
        }
    }
    
    public func fetchTheseUsers(userIds: [String], handler: @escaping(_ users: [User]) -> Void) {
        var filteredUsers = [User]()
        fetchAllUsers { users in
            users.forEach { user in
                if userIds.contains(user.emailAddress) {
                    filteredUsers.append(user)
                }
            }
            handler(filteredUsers)
        }
    }
    
    public func fetchAllPosts(handler: @escaping(_ posts: [Post]) -> Void) {
        var posts = [Post]()
        database.collection("posts").getDocuments { documentSnaps, error in
            if error == nil {
                documentSnaps?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let post = Post(
                        postId: snapshot.documentID,
                        userId: data["userId"] as! String,
                        caption: data["caption"] as! String,
                        flag: data["flag"] as! Int,
                        image: data["image"] as? String ?? nil,
                        likes: data["likes"] as! [String],
                        comments: data["comments"] as! [[String:String]],
                        flagId: data["flagId"] as? String ?? nil)
                    posts.append(post)
                })
                handler(posts)
            }
            handler([])
        }
    }
    
    public func fetchPostsFrom(userId: String, handler: @escaping(_ posts: [Post]) -> Void) {
        var filteredPosts = [Post]()
        fetchAllPosts { posts in
            posts.forEach { post in
                if post.userId == userId {
                    filteredPosts.append(post)
                }
            }
            handler(filteredPosts)
        }
    }
    
    
    public func fetchMyChats(handler: @escaping(_ chats: [ChatsData]) -> Void) {
        let currentUser = googleAuthModel.getCurrentUser()
        var chats = [ChatsData]()
        database.collection("chats").getDocuments { documentSnaps, error in
            if error == nil {
                documentSnaps?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let users = data["users"] as? [String] ?? []
                    if users.contains(currentUser.emailAddress) {
                        chats.append(ChatsData(id: snapshot.documentID, title: data["title"] as! String, labels: data["labels"] as! [String], location: data["location"] as! String, rank: data["rank"] as! Int, users: users))
                    }
                })
                handler(chats)
            }
            handler([])
        }
    }
    
    public func fetchMessagesFrom(chatId: String, handler: @escaping(_ messages: [MessageData]) -> Void) {
        fetchAllUsers { users in
            users.forEach { user in
                self.userStore[user.emailAddress] = user
            }
            var messageArray = [MessageData]()
            self.database.collection("chats").document(chatId).getDocument { snap, error in
                if error == nil {
                    let data = snap?.data()
                    if let messages = data?["messages"] as? [[String:String]] {
                        messages.forEach { message in
                            let content = message["content"]!
                            let userId = message["userId"]!
                            let user = self.userStore[userId]!
                            messageArray.append(MessageData(content: content, user: user))
                        }
                    }
                    handler([])
                }
                handler([])
            }
        }
    }
    
    public func fetchTheseChatUsersIDs(chatId: String, handler: @escaping(_ users: [String]) -> Void) {
        database.collection("chats").document(chatId).getDocument { snap, error in
            if error == nil {
                let data = snap?.data()
                if let users = data?["users"] as? [String] {
                   handler(users)
                }
                handler([])
            }
            handler([])
        }
    }
    
    public func addUserToChat(chatId: String, userId: String, userIds: [String]) {
        var mUserIds = userIds
        mUserIds.append(userId)
        database.collection("chats").document(chatId).setData(["users": mUserIds], merge: true)
    }
    
    public func addMessageToChat(chatId: String, userId: String, content: String, messages: [MessageData]) {
        var mmessages = [[String:String]]()
        messages.forEach { message in
            mmessages.append(["content": message.content, "userId": message.user.emailAddress])
        }
        mmessages.append(["content": content, "userId": userId])
        mmessages = mmessages.reversed()
        database.collection("chats").document(chatId).setData(["messages": [["content": content, "userId": userId]]], merge: true)
    }
    
    public func createChatInfo(chatData: ChatsData) {
        verifyChatExists(chatId: chatData.id) { chatExists in
            if !chatExists {
                self.database.collection("chats").document(chatData.id).setData([
                    "title": chatData.title,
                    "labels": chatData.labels,
                    "location": chatData.location,
                    "rank": chatData.rank
                ], merge: true)
            }
        }
    }
    
    public func verifyUserExistsAndRegister(
        firstName: String,
        lastName: String,
        pictureUrl: String,
        emailAddress: String
    ) {
        if emailAddress != "EMAIL_ADDRESS" {
            verifyUserExists(emailAddress: emailAddress) { userExists in
                if !userExists {
                    self.registerUser(firstName: firstName, lastName: lastName, pictureUrl: pictureUrl, emailAddress: emailAddress)
                }
            }
        }
    }
}
