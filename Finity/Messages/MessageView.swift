//
//  MessageView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct MessageView: View {
    
    private var currentMessage: MessageData
    
    init(currentMessage: MessageData) {
        self.currentMessage = currentMessage
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !(currentMessage.user.isCurrentUser ?? true) {
                AsyncImage(url: URL(string: currentMessage.user.profilePictureURL))
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
            } else {
                Spacer()
            }
            ContentMessageView(contentMessage: currentMessage.content,
                               isCurrentUser: currentMessage.user.isCurrentUser ?? true)
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(currentMessage: MessageData(content: "There are a lot of premium iOS templates on iosapptemplates.com",
                                                user: User(firstName: "subomi", lastName: "popoola", emailAddress: "popo***@***.com", profilePictureURL: "https://picsum.photos/200/300", isCurrentUser: false)
                                                   )
        )
    }
}
