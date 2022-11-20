//
//  EventsModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import UIKit

class EventsModel {
    
    public var events = [EventData]()
    
    init() {
        populateEvents()
    }
    
    private func populateEvents() {
        events.append(EventData(title: "Sports", requestParam: "category=sports"))
        events.append(EventData(title: "Concerts", requestParam: "category=concerts"))
        events.append(EventData(title: "Conferences", requestParam: "category=conferences"))
        events.append(EventData(title: "Expos", requestParam: "category=expos"))
        events.append(EventData(title: "Festival", requestParam: "category=festivals"))
        events.append(EventData(title: "Performing Arts", requestParam: "category=performing-arts"))
        events.append(EventData(title: "Community", requestParam: "category=community"))
        events.append(EventData(title: "Politics", requestParam: "category=politics"))
        events.append(EventData(title: "Disasters", requestParam: "category=disasters"))
    }
}
