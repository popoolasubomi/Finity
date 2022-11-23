//
//  ChatsView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct ChatsView: View {
    
    private var event: EventData
    @ObservedObject var chatsModel: ChatsModel
    
    init(entry: ChatsEntry, event: EventData) {
        self.event = event
        self.chatsModel = ChatsModel(event: event, entry: entry)
    }
    
    var body: some View {
        ZStack {
            if chatsModel.isFetching {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if chatsModel.chats.count == 0 {
                    Text("No Chats")
                } else {
                    List {
                        ForEach(chatsModel.chats) { chat in
                            HStack {
                                ZStack {
                                    VStack {
                                        HStack {
                                            Text(chat.title)
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.leading)
                                                .font(Font.custom("HelveticaNeue-Medium", size: 16.5))
                                                .padding(2.5)
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.blue)
                                                    .frame(width: 150, height: 22.5)
                                                Text(chat.labelText)
                                                    .foregroundColor(.white)
                                                    .font(Font.custom("HelveticaNeue-Regular", size: 15.0))
                                                    .frame(width: 150, height: 22.5)
                                                    .padding(2.5)
                                            }
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(.purple)
                                                    .frame(width: 150, height: 22.5)
                                                Text("Rank: \(chat.rank)")
                                                    .foregroundColor(.white)
                                                    .font(Font.custom("HelveticaNeue-Regular", size: 15.0))
                                                    .frame(width: 150, height: 22.5)
                                                    .padding(2.5)
                                            }
                                        }
                                    }
                                    
                                    NavigationLink(destination: MessagerView(chatData: chat)) {
                                        EmptyView()
                                    }
                                    .frame(width: 0, height: 0)
                                    .opacity(0)
                                }
                                Image(Asset.NEXT_ICON.rawValue)
                            }
                            .padding([.leading])
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
                VStack {
                    Text(event.title)
                        .foregroundColor(.black)
                        .font(Font.custom("HelveticaNeue-Bold", size: 20.0))
                        .padding([.top, .leading])
                }
            }
        }
        .onAppear {
            chatsModel.fetchChats()
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(entry: .chats, event: EventData(title: "Chats", requestParam: "NO_PARAM"))
    }
}
