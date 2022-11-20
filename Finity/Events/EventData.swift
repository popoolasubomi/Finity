//
//  EventData.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class EventData: Identifiable {
    
    public var title: String
    public var requestParam: String
    
    init(title: String, requestParam: String) {
        self.title = title
        self.requestParam = requestParam
    }
}
