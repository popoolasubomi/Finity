//
//  Post.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class Post {
    
    public var postId: String
    public var userId: String
    public var image: String?
    public var caption: String
    public var likes: [String]?
    public var comments: [String]?
    public var flagId: String?
    public var flag: Int
    
    init(postId: String, userId: String, caption: String, flag: Int, image: String? = nil, likes: [String]? = [], comments: [String]? = [], flagId: String? = "") {
        self.postId = postId
        self.userId = userId
        self.image = image
        self.caption = caption
        self.likes = likes
        self.comments = comments
        self.flagId = flagId
        self.flag = flag
    }
}
