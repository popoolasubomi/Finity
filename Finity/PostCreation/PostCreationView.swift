//
//  PostCreationView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct PostCreationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
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

struct PostCreationView_Previews: PreviewProvider {
    static var previews: some View {
        PostCreationView()
    }
}
