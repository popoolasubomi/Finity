//
//  ChatsModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class ChatsModel: ObservableObject {
    
    private var event: EventData
    private var entry: ChatsEntry
    public var chats = [ChatsData]()
    @Published var isFetching: Bool = true
    private let dbManager = FirestoreManager()
    
    init(event: EventData, entry: ChatsEntry) {
        self.event = event
        self.entry = entry
    }
    
    public func fetchChats() {
        let predictHqModel = PredictHqModel()
        isFetching = true
        switch entry {
        case .events:
            self.chats = [ChatsData]()
            predictHqModel.fetchPredictHQData(request_parameters: event.requestParam) { results in
                results.forEach { result in
                    self.chats.append(ChatsData(
                        id: result["id"] as! String,
                        title: result["title"] as! String,
                        labels: result["labels"] as! [String],
                        location: result["country"] as! String,
                        rank: result["rank"] as! Int)
                    )
                }
                self.isFetching = false
            }
        case .chats:
            dbManager.fetchMyChats { chats in
                self.chats = chats
                self.isFetching = false
            }
        }
    }
}
