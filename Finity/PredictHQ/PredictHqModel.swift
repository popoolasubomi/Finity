//
//  PredictHqModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit
import Foundation

class PredictHqModel: ObservableObject {
    
    @Published var isFetching: Bool = true
    public var resonatingArgument: String = ""
    
    public func fetchPredictHQData(request_parameters: String, handler: @escaping(_ results: [[String:Any]]) -> Void) {
        isFetching = true
        PredictHQ_API().fetchData(request_param: request_parameters) { results in
            handler(results)
            self.isFetching = false
        }
    }
    
    public func fetchResonatingArgumentStored(postId: String) {
        isFetching = true
        self.resonatingArgument = "Heavy snow in New York coming soon"
        isFetching = false
    }
}
