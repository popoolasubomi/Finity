//
//  TimelineModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class TimelineModel {
    
    public var timelineArray = [TimelineData]()
    public var isFetching: Bool = true
    
    private var userStore = [String:User]()
    
    private func fetchUsers(handler: @escaping(_ users: [User]) -> Void) {
        var users = [User]()
        for _ in 0..<10 {
            let user = User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300")
            users.append(user)
            userStore[user.emailAddress] = user
        }
        handler(users)
    }
    
    private func fetchPosts(handler: @escaping(_ posts: [Post]) -> Void) {
        var posts = [Post]()
        for index in 0..<10 {
            if index % 2 == 0 {
                posts.append(fetchFakePicturePost())
            } else {
                posts.append(fetchFakeCaptionPost())
            }
        }
        handler(posts)
    }
    
    public func fetchUser(userId: String) -> User  {
        return userStore[userId]!
    }
    
    public func fetchTimeline() {
        timelineArray.removeAll()
        isFetching = true
        fetchUsers { users in
            self.timelineArray.append(TimelineData(users: users, section: .users))
            self.fetchPosts { posts in
                for post in posts {
                    if post.image == nil {
                        self.timelineArray.append(TimelineData(post: post, section: .captionPost))
                    } else {
                        self.timelineArray.append(TimelineData(post: post, section: .picturePost))
                    }
                }
                self.isFetching = false
            }
        }
    }
    
    // Testing Functions
    
    public func fetchTestUsers() -> [User] {
        var users = [User]()
        for _ in 0..<10 {
            let user = User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300")
            users.append(user)
        }
        return users
    }
    
    public func fetchFakePicturePost() -> Post {
        let postId = "FAKE_POST_ID"
        let userId = "popo***@***.com"
        let image = "https://picsum.photos/300/300"
        let caption = "Over 300 jungles gone from pollution"
        let flag = Int.random(in: 0..<2)
        return Post(
            postId: postId,
            userId: userId,
            caption: caption,
            flag: flag,
            image: image
        )
    }
    
    public func fetchFakeCaptionPost() -> Post {
        let postId = "FAKE_POST_ID"
        let userId = "popo***@***.com"
        let caption = "Over 300 jungles gone from pollution"
        let flag = Int.random(in: 0..<2)
        return Post(
            postId: postId,
            userId: userId,
            caption: caption,
            flag: flag
        )
    }
    
    public func fetchFakeUser() -> User {
        return User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300")
    }
}
