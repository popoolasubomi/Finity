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
        events.append(EventData(title: "Academic", requestParam: "category=academic&sort=relevance"))
        events.append(EventData(title: "Sports", requestParam: "category=sports&sort=relevance"))
        events.append(EventData(title: "Politics", requestParam: "category=politics&sort=relevance"))
        events.append(EventData(title: "Concerts", requestParam: "category=concerts&sort=relevance"))
        events.append(EventData(title: "Conferences", requestParam: "category=conferences&sort=relevance"))
        events.append(EventData(title: "Expos", requestParam: "category=expos&sort=relevance"))
        events.append(EventData(title: "Festival", requestParam: "category=festivals&sort=relevance"))
        events.append(EventData(title: "Performing Arts", requestParam: "category=performing-arts&sort=relevance"))
        events.append(EventData(title: "Community", requestParam: "category=community&sort=relevance"))
        events.append(EventData(title: "Politics", requestParam: "category=politics&sort=relevance"))
        events.append(EventData(title: "Disasters", requestParam: "category=disasters&sort=relevance"))
        events.append(EventData(title: "Terror", requestParam: "category=terror&sort=relevance"))
        events.append(EventData(title: "Health Warnings", requestParam: "category=health-warnings&sort=relevance"))
    }
}
