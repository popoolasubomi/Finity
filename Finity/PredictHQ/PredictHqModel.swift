//
//  PredictHqModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import UIKit

class PredictHqModel {
    
    public var isFetching: Bool = true
    public var resonatingArgument: String = ""
    
    public func fetchResonatingArgumentStored(postId: String) {
        isFetching = true
        self.resonatingArgument = "Close to 100 jungles impacted by wastage damage"
        isFetching = false
    }
}
