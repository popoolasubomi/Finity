//
//  ProfileView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI
import XNavigation

struct ProfileView: View {
    
    @EnvironmentObject var navigation: Navigation
    @ObservedObject var profileModel = ProfileModel()
    
    init() {
        profileModel.fetchTimeline()
    }
    
    @ViewBuilder
    private var logoutButton: some View {
        Button(action: {}) {
            Text("Logout")
                .foregroundColor(.blue)
                .font(Font.custom("HelveticaNeue-Bold", size: 15.0))
        }
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                let user = profileModel.user
                AsyncImage(url: URL(string: user.profilePictureURL))
                    .scaledToFit()
                    .frame(width: 135, height: 135)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(CustomColor.themeColor, lineWidth: 3))
                    .padding(.top, 50)
                    .padding(.bottom)
                Text("\(user.firstName)  \(user.lastName)")
                    .font(Font.custom("HelveticaNeue-Bold", size: 15.0))
                    .padding(.bottom, 2)
                Text("\(user.emailAddress)")
                    .foregroundColor(.gray)
                    .font(Font.custom("HelveticaNeue-Regular", size: 15.0))
                    .padding(.bottom)
                
                if profileModel.isFetching {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 30)
                        Text("\(profileModel.timelineArray.count) POSTS")
                            .foregroundColor(.white)
                            .font(Font.custom("HelveticaNeue-Bold", size: 15.0))
                    }
                    if profileModel.timelineArray.count == 0 {
                        VStack{
                            Spacer()
                            Text("No Posts")
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(profileModel.timelineArray) { timelineData in
                                switch timelineData.section {
                                case .users:
                                    UsersView(users: timelineData.users!)
                                        .padding(.bottom)
                                case .picturePost:
                                    let post = timelineData.post!
                                    PicturePostView(
                                        post: post,
                                        user: user
                                    )
                                        .environmentObject(navigation)
                                        .listRowSeparator(.hidden)
                                        .frame(height: 350)
                                case .captionPost:
                                    let post = timelineData.post!
                                    CaptionPostView(
                                        post: post,
                                        user: user
                                    )
                                        .environmentObject(navigation)
                                        .listRowSeparator(.hidden)
                                        .frame(height: 150)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(GroupedListStyle())
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Spacer()
                        Text("Profile")
                            .foregroundColor(CustomColor.themeColor)
                            .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                            .padding([.top])
                        Spacer()
                        Button(action: {}) {
                            Text("Logout")
                                .foregroundColor(.blue)
                                .font(Font.custom("HelveticaNeue-Bold", size: 15.0))
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
