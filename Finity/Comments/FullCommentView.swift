//
//  FullCommentView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct FullCommentView: View {
    
    private var user: User
    private var comment: String
    
    init(user: User, comment: String) {
        self.user = user
        self.comment = comment
    }
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: user.profilePictureURL))
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(CustomColor.themeColor, lineWidth: 1))
            Text(user.firstName)
                .foregroundColor(.black)
                .font(Font.custom("HelveticaNeue-Bold", size: 15))
            Text(comment)
                .font(Font.custom("HelveticaNeue-Regular", size: 15))
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }.padding([.leading, .trailing])
    }
}

struct FullCommentView_Previews: PreviewProvider {
    static var previews: some View {
        let comment = "Such a shame"
        let user = User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300")
        FullCommentView(user: user, comment: comment)
    }
}
