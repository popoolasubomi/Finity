//
//  PredictHQView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct PredictHQView: View {
    
    private var post: Post
    @ObservedObject var predictHqModel = PredictHqModel()
    private let googleModel = GoogleAuthModel()
    
    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        VStack {
            if predictHqModel.isFetching {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Spacer()
                Divider()
                FullCommentView(user: predictHqModel.postUser!, comment: post.caption)
                    .padding(.top)
                Divider()
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(CustomColor.themeColor)
                        .frame(width: ScreenSize.screenWidth * 0.85, height: ScreenSize.screenHeight * 0.30)
                    Text(post.caption)
                        .foregroundColor(.white)
                        .font(Font.custom("HelveticaNeue-Bold", size: 18.5))
                        .padding()
                        .frame(width: ScreenSize.screenWidth * 0.85)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(.yellow)
                        .frame(width: ScreenSize.screenWidth * 0.85, height: ScreenSize.screenHeight * 0.30)
                    if predictHqModel.isFetching {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text(post.flagId ?? "")
                            .foregroundColor(CustomColor.themeColor)
                            .font(Font.custom("HelveticaNeue-Bold", size: 18.5))
                            .padding()
                            .frame(width: ScreenSize.screenWidth * 0.85)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("PredictHQ")
                        .foregroundColor(CustomColor.themeColor)
                        .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                        .padding([.top, .leading])
                    switch post.flag {
                    case -1:
                        Image(Asset.RED_FLAG.rawValue)
                            .padding(.top)
                    case 1:
                        Image(Asset.GREEN_FLAG.rawValue)
                            .padding(.top)
                    default:
                        Image(Asset.GREY_FLAG.rawValue)
                            .padding(.top)
                    }
                }
            }
        }.onAppear {
            predictHqModel.fetchUser(userId: post.userId)
        }
    }
}

struct PredictHQView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        let post = timelineModel.fetchFakeCaptionPost()
        PredictHQView(post: post)
    }
}
