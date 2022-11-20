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
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray, lineWidth: 0.5)
                .shadow(radius: 17.5)
                .frame(height: 150.0)
            VStack {
                HStack{
                    AsyncImage(url: URL(string: user.profilePictureURL))
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(CustomColor.themeColor, lineWidth: 1))
                    Text(user.firstName)
                        .foregroundColor(.black)
                        .font(Font.custom("HelveticaNeue-Regular", size: 15))
                    Spacer()
                    Button(action: {}) {
                        switch post.flag {
                        case -1:
                            Image(Asset.RED_FLAG.rawValue)
                        case 1:
                            Image(Asset.GREEN_FLAG.rawValue)
                        default:
                            Image(Asset.GREY_FLAG.rawValue)
                        }
                    }
                }.padding([.leading, .trailing])
                Divider()
                HStack {
                    Text(user.firstName)
                        .foregroundColor(.black)
                        .font(Font.custom("HelveticaNeue-Bold", size: 15.0))
                    Text(post.caption)
                        .foregroundColor(.black)
                        .font(Font.custom("HelveticaNeue-Regular", size: 15.0))
                        .lineLimit(1)
                    Spacer()
                }.padding([.leading, .trailing])
                HStack {
                    Button(action: {}) {
                        Image(Asset.UNLIKE_HEART.rawValue)
                    }
                    Button(action: {}) {
                        Image(Asset.CHAT_ICON.rawValue)
                    }
                    Spacer()
                }.padding(.leading)
            }
            .frame(height: 300.0)
        }
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
