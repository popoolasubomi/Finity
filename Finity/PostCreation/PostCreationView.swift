//
//  PostCreationView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct PostCreationView: View {
    
    @State var typingMessage: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(CustomColor.lightGrey)
                        .frame(width: ScreenSize.screenWidth * 0.85, height: ScreenSize.screenHeight * 0.30)
                    Image(Asset.COMPOSE_ICON.rawValue)
                }
            }
            Spacer()
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
            
            Spacer()
            Button(action: {}) {
                Image(Asset.SUBMIT_POST_ICON.rawValue)
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Create Post")
                        .foregroundColor(.black)
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

struct PostCreationView_Previews: PreviewProvider {
    static var previews: some View {
        PostCreationView()
    }
}
