//
//  ProfileModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import GoogleSignIn

class ProfileModel: ObservableObject {
    
    public var user: User
    @Published var isFetching: Bool = true
    public var timelineArray = [TimelineData]()
    private let googleAuthModel = GoogleAuthModel()
    private let dbManager = FirestoreManager()
    
    init() {
        self.user = googleAuthModel.getCurrentUser()
    }
    
    private func fetchPosts(handler: @escaping(_ posts: [Post]) -> Void) {
        dbManager.fetchPostsFrom(userId: user.emailAddress) { posts in
            handler(posts)
        }
    }
    
    public func fetchTimeline() {
        timelineArray.removeAll()
        isFetching = true
        fetchPosts { posts in
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
    
    // Testing Functions
    
    public func fetchFakePicturePost() -> Post {
        let postId = "FAKE_POST_ID"
        let userId = "popo***@***.com"
        let image = "https://picsum.photos/300/300"
        let caption = "Over 300 jungles gone from pollution"
        let flag = Int.random(in: -1..<2)
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
        let caption = "We have lost a lot of wildlife due to the greed of others"
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
