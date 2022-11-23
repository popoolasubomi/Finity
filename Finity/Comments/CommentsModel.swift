//
//  CommentsModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import Foundation

class CommentsModel: ObservableObject {
    
    public var post: Post
    public var userStore = [String:User]()
    public var dbManager = FirestoreManager()
    
    @Published var comments = [Comment]()
    @Published var isFetching: Bool = true
    
    init(post: Post) {
        self.post = post
    }
    
    public func fetchComments() {
        isFetching = true
        dbManager.fetchCommentsFromPost(postId: post.postId) { comments in
            var commenterIds = [self.post.userId]
            comments.forEach { comment in
                commenterIds.append(comment.userId)
            }
            self.dbManager.fetchTheseUsers(userIds: commenterIds) { users in
                users.forEach { user in
                    self.userStore[user.emailAddress] = user
                }
                self.isFetching = false
                self.comments = comments
            }
        }
    }
    
    public func postComment(comment: String) {
        let user = GoogleAuthModel().getCurrentUser()
        dbManager.addCommentToPost(postId: post.postId, userId: user.emailAddress, comment: comment) { success in
            if success {
                self.userStore[user.emailAddress] = user
            }
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
