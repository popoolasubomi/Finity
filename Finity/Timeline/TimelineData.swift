//
//  TimelineData.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class TimelineData: Identifiable {
    
    public var users: [User]?
    public var post: Post?
    public var section: TimelineSection
    
    init(users: [User]? = nil, post: Post? = nil, section: TimelineSection) {
        self.users = users
        self.post = post
        self.section = section
    }
    
}
