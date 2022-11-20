//
//  CommentsView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct CommentsView: View {
    
    private var post: Post
    @State var typingMessage: String = ""
    private var commentsModel: CommentsModel
    
    init(post: Post) {
        self.post = post
        commentsModel = CommentsModel(post: post)
    }
    
    var body: some View {
        NavigationView {
            if commentsModel.isFetching {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                VStack {
                    let postOwner = commentsModel.userStore[post.userId]
                    Spacer()
                    Spacer()
                    Divider()
                    FullCommentView(user: postOwner!, comment: post.caption)
                        .padding(.top)
                    Divider()
                    if commentsModel.comments.isEmpty {
                        Text("No Comments")
                    } else {
                        List {
                            ForEach(commentsModel.comments) { comment in
                                FullCommentView(user: commentsModel.userStore[comment.userId]!, comment: comment.comment)
                                    .frame(height: 55)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(.gray, lineWidth: 0.5)
                            .frame(height: 50)
                        HStack {
                            TextField("Add a comment...", text: $typingMessage)
                                .textFieldStyle(.plain)
                                .frame(minHeight: CGFloat(30))
                            Button(action: {}) {
                                    Text("Send")
                            }
                        }
                        .padding()
                    }
                    .frame(minHeight: CGFloat(50))
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Spacer()
                            Text("Comments")
                                .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                                .padding([.top])
                            Spacer()
                        
                            NavigationLink(destination: PredictHQView(post: post)) {
                                switch post.flag {
                                case -1:
                                    Image(Asset.RED_FLAG.rawValue)
                                case 1:
                                    Image(Asset.GREEN_FLAG.rawValue)
                                default:
                                    Image(Asset.GREY_FLAG.rawValue)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
            }
        }
 
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let timelineModel = TimelineModel()
        let post = timelineModel.fetchFakeCaptionPost()
        CommentsView(post: post)
    }
}
