//
//  CommentsModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import Foundation

class CommentsModel {
    
    public var post: Post
    public var isFetching:Bool = true
    public var userStore = [String:User]()
    public var comments = [Comment]()
    public var fakeUserStore = [String:User]()
    
    init(post: Post) {
        self.post = post
        for comment in post.comments {
            comments.append(Comment(comment: comment))
        }
        fetchUsers()
    }
    
    private func fetchUsers() {
        isFetching = true
        for _ in 0..<10 {
            let user = User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300")
            userStore[user.emailAddress] = user
        }
        isFetching = false
    }
}

class Comment: Identifiable {
    
    public var userId: String
    public var comment: String
    
    init(comment: [String]) {
        self.userId = comment[0]
        self.comment = comment[1]
    }
}
