//
//  EventsView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/19/22.
//

import SwiftUI

struct EventsView: View {
    
    private var eventsModel = EventsModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(eventsModel.events) { event in
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 0.5)
                            .frame(height: 50.0)
                        ZStack {
                            HStack {
                                Text(event.title)
                                Spacer()
                                Image(Asset.NEXT_ICON.rawValue)
                            }.padding()
                            
                            NavigationLink(destination: ChatsView(entry: .events, event: event)) {
                                EmptyView()
                            }
                            .frame(width: 0, height: 0)
                            .opacity(0)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Events")
                            .foregroundColor(CustomColor.themeColor)
                            .font(Font.custom("HelveticaNeue-Bold", size: 25.0))
                            .padding([.top, .leading])
                    }
                }
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
