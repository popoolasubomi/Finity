//
//  CaptionPostView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI

struct CaptionPostView: View {
    
    private var post: Post
    private var user: User
    
    init(post: Post, user: User) {
        self.post = post
        self.user = user
    }
    
    var body: some View {
        Text("Go away:)")
    }
}

struct CaptionPostView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        CaptionPostView(
            post: timelineModel.fetchFakeCaptionPost(),
            user: timelineModel.fetchFakeUser()
        )
    }
}
