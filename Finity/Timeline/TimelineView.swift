//
//  TimelineView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/17/22.
//

import SwiftUI

struct TimelineView: View {
    
    private let firestoreManager = FirestoreManager()
    private let timelineModel = TimelineModel()
    
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
            Button(action: {}) {
                Image(Asset.POST_ICON.rawValue)
            }
            Button(action: {}) {
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
                            case .picturePost:
                                PicturePostView(post: timelineData.post!)
                            case .captionPost:
                                CaptionPostView(post: timelineData.post!)
                            }
                        }
                    }
                    .frame(width: .infinity)
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                    .navigationBarItems(
                        leading: appName,
                        trailing: rightNavBar
                    )
                }
            }
        }
        .toolbarBackground(Color.red, for: .navigationBar)
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
