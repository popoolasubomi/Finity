//
//  CommentsModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import Foundation

class CommentsModel: ObservableObject {
    
    public var post: Post
    @Published var isFetching: Bool = true
    public var userStore = [String:User]()
    public var comments = [Comment]()
    public var dbManager = FirestoreManager()
    
    init(post: Post) {
        self.post = post
        post.comments.forEach { comment in
            comments.append(Comment(userId: comment["userId"]!, comment: comment["comment"]!))
        }
        fetchCommentUsers()
    }
    
    private func fetchCommentUsers() {
        // Fetch commenters + current post owner
        var commenterIds = [String]()
        commenterIds.append(post.userId)
        comments.forEach { comment in
            commenterIds.append(comment.userId)
        }
        isFetching = true
        dbManager.fetchTheseUsers(userIds: commenterIds) { users in
            users.forEach { user in
                self.userStore[user.emailAddress] = user
            }
            self.isFetching = false
        }
    }
}

class Comment: Identifiable {
    
    public var userId: String
    public var comment: String
    
    init(userId: String, comment: String) {
        self.userId = userId
        self.comment = comment
    }
}
