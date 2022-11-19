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
    
    init(firstName: String, lastName: String, emailAddress: String, profilePictureURL: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.profilePictureURL = profilePictureURL
    }
}
