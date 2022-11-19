//
//  PicturePostView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI

struct PicturePostView: View {
    
    private var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PicturePostView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        PicturePostView(post: timelineModel.fetchFakePicturePost())
    }
}
