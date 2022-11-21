//
//  MessageData.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class MessageData: Identifiable {
    public var content: String
    public var user: User
    
    init(content: String, user: User) {
        self.content = content
        self.user = user
    }
}
