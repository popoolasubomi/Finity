//
//  User.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class User: Identifiable {
    
    public var firstName: String
    public var lastName: String
    public var emailAddress: String
    public var profilePictureURL: String
    public var isCurrentUser: Bool?
    
    init(firstName: String, lastName: String, emailAddress: String, profilePictureURL: String, isCurrentUser: Bool? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.profilePictureURL = profilePictureURL
        self.isCurrentUser = isCurrentUser
    }
}
