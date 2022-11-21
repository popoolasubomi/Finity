//
//  MessagerView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct MessagerView: View {
    private var chatId: String
    private var chatTitle: String
    @State var typingMessage: String = ""
    @ObservedObject var messagingModel: MessagingModel
    
    init(chatData: ChatsData) {
        self.chatId = chatData.id
        self.chatTitle = chatData.title
        self.messagingModel = MessagingModel(chatData: chatData)
    }
    
    var body: some View {
        if messagingModel.isFetching {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            VStack {
                if messagingModel.messages.count == 0 {
                    VStack {
                        Spacer()
                        Text("No Messages")
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(messagingModel.messages) { message in
                            MessageView(currentMessage: message)
                        }
                    }
                }
                HStack {
                    TextField("Message", text: $typingMessage)
                        .textFieldStyle(.plain)
                        .frame(minHeight: CGFloat(30))
                    Button(action: {
                        messagingModel.sendMessage(content: typingMessage)
                        typingMessage = ""
                    }) {
                            Text("Send")
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(chatTitle)
                            .foregroundColor(.black)
                            .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                            .padding([.top, .leading])
                    }
                }
            }
        }
    }
}

struct MessagerView_Previews: PreviewProvider {
    static var previews: some View {
        let chatData = ChatsData(id: "TEST", title: "TEST", labels: ["TEST"], location: "TEST", rank: 9, messages: [["TEST":"TEST"]])
        MessagerView(
            chatData: chatData
        )
    }
}
