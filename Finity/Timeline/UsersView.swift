//
//  UsersView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI

struct UsersView: View {
    
    private var users: [User]
    
    init(users: [User]) {
        self.users = users
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(users) { user in
                    VStack {
                        AsyncImage(url: URL(string: user.profilePictureURL))
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        Text(user.firstName)
                            .foregroundColor(.black)
                            .font(Font.custom("HelveticaNeue-Regular", size: 15))
                    }
                    .padding([.top, .leading, .bottom], 5)
                }
            }
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        UsersView(users: timelineModel.fetchTestUsers())
    }
}
