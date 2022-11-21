//
//  ChatsData.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class ChatsData: Identifiable {
    
    public var id: String
    public var title: String
    public var labels: [String]
    public var location: String
    public var rank: Int
    public var labelText: String
    public var users: [String]
    public var messages: [[String:String]]
    
    init(id: String, title: String, labels: [String], location: String, rank: Int, users: [String] = [], messages: [[String:String]] = []) {
        self.id = id 
        self.title = title
        self.labels = labels
        self.location = location
        self.rank = rank
        self.users = users
        self.messages = messages
        var processedLabel = labels.count >= 2 ? "\(labels[0]), \(labels[1])" : ""
        processedLabel = labels.count == 1 ? "\(labels[0])" : processedLabel
        self.labelText = processedLabel
    }
}
