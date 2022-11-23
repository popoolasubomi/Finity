//
//  FirestoreManager.swift
//  Finity
//
//  Created by Subomi Popoola on 11/18/22.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreManager {
    
    private var database = Firestore.firestore()
    private var googleAuthModel = GoogleAuthModel()
    
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
    
    public func createPost(data: [String:Any],  handler: @escaping(_ success: Bool) -> Void) {
        database.collection("posts").addDocument(data: data) { err in
            if err == nil {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    public func fetchAllUsers(handler: @escaping(_ users: [User]) -> Void) {
        database.collection("users").getDocuments { documentSnaps, error in
            if error == nil {
                var users = [User]()
                let currentUser = self.googleAuthModel.getCurrentUser()
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
            } else {
                handler([])
            }
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
        database.collection("posts").getDocuments { documentSnaps, error in
            if error == nil {
                var posts = [Post]()
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
            } else {
                handler([])
            }
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
            } else {
                handler([])
            }
        }
    }
    
    public func createChatInfo(chatData: ChatsData,  handler: @escaping(_ success: Bool) -> Void) {
        verifyChatExists(chatId: chatData.id) { chatExists in
            if !chatExists {
                self.database.collection("chats").document(chatData.id).setData([
                    "title": chatData.title,
                    "labels": chatData.labels,
                    "location": chatData.location,
                    "rank": chatData.rank
                ], merge: true) { err in
                    if err == nil {
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            } else {
                handler(true)
            }
        }
    }
    
    public func fetchMessagesFrom(chatId: String, handler: @escaping(_ messages: [MessageData], _ currentUsers: [String]) -> Void) {
        database.collection("chats").document(chatId)
            .addSnapshotListener { documentSnapshot, error in
                if let documentSnapshot = documentSnapshot {
                    let data = documentSnapshot.data()!
                    let chatUsers = data["users"] as? [String] ?? []
                    var userStore = [String:User]()
                    self.fetchTheseUsers(userIds: chatUsers) { users in
                        users.forEach { user in
                            userStore[user.emailAddress] = user
                        }
                        var fetchedMessages = [MessageData]()
                        let dataComments = data["messages"] as? [[String:String]] ?? []
                        dataComments.forEach { message in
                            fetchedMessages.append(MessageData(content: message["content"]!, user: userStore[message["userId"]!]!))
                        }
                        handler(fetchedMessages, chatUsers)
                    }
                }
            }
    }
    
    public func addMessageToChat(chatId: String, userId: String, content: String) {
        let chatRef = database.collection("chats").document(chatId)
        chatRef.updateData(["messages": FieldValue.arrayUnion([["content": content, "userId": userId]])])
    }
    
    public func addUserToChat(chatId: String, userId: String) {
        let chatRef = database.collection("chats").document(chatId)
        chatRef.updateData(["users": FieldValue.arrayUnion([userId])])
    }
    
    public func fetchCommentsFromPost(postId: String, handler: @escaping(_ comments: [Comment]) -> Void) {
        database.collection("posts").document(postId)
            .addSnapshotListener { documentSnapshot, error in
                if let documentSnapshot = documentSnapshot {
                    var fetchedComments = [Comment]()
                    let data = documentSnapshot.data()!
                    let dataComments = data["comments"] as! [[String:String]]
                    dataComments.forEach { comment in
                        fetchedComments.append(Comment(userId: comment["userId"]!, comment: comment["comment"]!))
                    }
                    handler(fetchedComments)
                }
            }
    }
    
    public func addCommentToPost(postId: String, userId: String, comment: String, handler: @escaping(_ success: Bool) -> Void) {
        let commentRef = database.collection("posts").document(postId)
        commentRef.updateData(["comments": FieldValue.arrayUnion([["comment": comment, "userId": userId]])]) { err in
            if (err != nil) {
                handler(false)
            } else {
                handler(true)
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
