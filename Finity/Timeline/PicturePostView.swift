//
//  PicturePostView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI
import XNavigation

struct PicturePostView: View {
    
    @EnvironmentObject var navigation: Navigation
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
                .frame(height: 350.0)
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
                    }.onTapGesture {
                        navigation.pushView(PredictHQView(post: post))
                    }
                }.padding([.leading, .trailing])
                Spacer()
                AsyncImage(
                    url: URL(string: post.image!),
                    transaction: Transaction(animation: .easeInOut)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .transition(.scale(scale: 0.1, anchor: .center))
                    case .failure:
                        Image(systemName: "wifi.slash")
                    @unknown default:
                        EmptyView()
                    }
                }
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
                    Button(action: {print(5)}) {
                        Image(Asset.UNLIKE_HEART.rawValue)
                    }
                    .padding(.leading)
                    Image(Asset.CHAT_ICON.rawValue)
                        .onTapGesture {
                        navigation.pushView(CommentsView(post: post))
                        }
                        .padding(.leading, 5)
                    Spacer()
                }
            }
            .frame(height: 300.0)
        }
    }
}

struct PicturePostView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        PicturePostView(
            post: timelineModel.fetchFakePicturePost(),
            user: timelineModel.fetchFakeUser()
        )
        .environmentObject(Navigation(window: UIWindow()))
    }
}
