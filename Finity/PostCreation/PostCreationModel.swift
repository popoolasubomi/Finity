//
//  PostCreationModel.swift
//  Finity
//
//  Created by Subomi Popoola on 11/23/22.
//

import UIKit

class PostCreationModel: ObservableObject {
    
    private let dbManager = FirestoreManager()
    
    init() {
        
    }
    
    public func createPost(caption: String, image: UIImage?,  handler: @escaping(_ success: Bool) -> Void) {
        let user = GoogleAuthModel().getCurrentUser()
        let predictHqModel = PredictHqModel()
        if caption != "" {
            predictHqModel.fetchResonatingArgumentStored(sentence: caption) { argument, score in
                
                var post = [String:Any]()
                post["caption"] = caption
                if let _ = image {
                    post["image"] = "https://picsum.photos/200/300"
                }
                post["likes"] = []
                post["comments"] = []
                post["flag"] = score < 50 ? -1 : 1
                post["flagId"] = argument
                post["userId"] = user.emailAddress
                self.dbManager.createPost(data: post) { success in
                    handler(success)
                }
            }
        } else {
            handler(false)
        }
    }
}
