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
    @ObservedObject var commentsModel: CommentsModel
    
    init(post: Post) {
        self.post = post
        commentsModel = CommentsModel(post: post)
    }
    
    var body: some View {
        ZStack {
            if commentsModel.isFetching {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                VStack {
                    let postOwner = commentsModel.userStore[post.userId]
                    Spacer()
                    Spacer()
                    if commentsModel.comments.isEmpty {
                        VStack(spacing: 120) {
                            VStack {
                                Divider()
                                FullCommentView(user: postOwner!, comment: post.caption)
                                    .padding(.top)
                                Divider()
                            }
                            Spacer()
                            Text("No Comments")
                            Spacer()
                        }
                    } else {
                        Divider()
                        FullCommentView(user: postOwner!, comment: post.caption)
                            .padding(.top)
                        Divider()
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
                            Button(action: {
                                commentsModel.postComment(comment: typingMessage)
                                typingMessage.removeAll()
                            }) {
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
                        VStack {
                            Text("Comments")
                                .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                                .padding([.top, .leading])
                        }
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
               
            }
        }
        .onAppear {
            commentsModel.fetchComments()
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        let postId = "FAKE_POST_ID"
        let userId = "popoolaogooluwasubomi@gmail.com"
        let image = "https://picsum.photos/300/300"
        let caption = "Over 300 jungles gone from pollution"
        let flag = Int.random(in: -1..<2)
        let post = Post(
            postId: postId,
            userId: userId,
            caption: caption,
            flag: flag,
            image: image,
            comments: [["userId":"popo***@***.com", "comment":"Such a shame"], ["userId":"popo***@***.com", "comment":"Something seems off about this comment, the cheker flags its authencity"]]
        )
        CommentsView(post: post)
    }
}
