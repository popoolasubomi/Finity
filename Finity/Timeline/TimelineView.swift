//
//  TimelineView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/17/22.
//

import SwiftUI
import XNavigation

struct TimelineView: View {
    
    @EnvironmentObject var navigation: Navigation
    private let firestoreManager = FirestoreManager()
    @ObservedObject var timelineModel = TimelineModel()
    
    init() {
        timelineModel.fetchTimeline()
    }
    
    @ViewBuilder
    private var appName: some View {
        Text("Finity")
            .foregroundColor(CustomColor.themeColor)
            .font(Font.custom("SavoyeLetPlain", size: 45.0))
            .padding([.top, .leading])
    }
    
    @ViewBuilder
    private var rightNavBar: some View {
        HStack {
            NavigationLink(destination: PostCreationView()) {
                Image(Asset.POST_ICON.rawValue)
            }
            NavigationLink(destination: ChatsView(entry: .chats, event: EventData(title: "Chats", requestParam: "NO_PARAM"))) {
                Image(Asset.CHAT_ICON.rawValue)
            }
        }
        .padding(.trailing)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                if timelineModel.isFetching {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .navigationBarItems(
                            leading: appName,
                            trailing: rightNavBar
                        )
                } else {
                    List {
                        ForEach(timelineModel.timelineArray) { timelineData in
                            switch timelineData.section {
                            case .users:
                                UsersView(users: timelineData.users!)
                                    .padding(.bottom)
                            case .picturePost:
                                let post = timelineData.post!
                                PicturePostView(
                                    post: post,
                                    user: timelineModel.fetchUser(userId: post.userId)
                                )
                                    .environmentObject(navigation)
                                    .listRowSeparator(.hidden)
                                    .frame(height: 350)
                            case .captionPost:
                                let post = timelineData.post!
                                CaptionPostView(
                                    post: post,
                                    user: timelineModel.fetchUser(userId: post.userId)
                                )
                                    .environmentObject(navigation)
                                    .listRowSeparator(.hidden)
                                    .frame(height: 150)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                    .navigationBarItems(
                        leading: appName,
                        trailing: rightNavBar
                    )
                }
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .environmentObject(Navigation(window: UIWindow()))
    }
}
