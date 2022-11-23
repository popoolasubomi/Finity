//
//  PostCreationView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/20/22.
//

import SwiftUI

struct PostCreationView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var typingMessage: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @ObservedObject var postCreationModel = PostCreationModel()
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {}) {
                ZStack {
                    if selectedImage == nil {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(CustomColor.lightGrey)
                            .frame(width: ScreenSize.screenWidth * 0.85, height: ScreenSize.screenHeight * 0.30)
                        Image(Asset.COMPOSE_ICON.rawValue)
                    } else {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: ScreenSize.screenWidth * 0.85, height: ScreenSize.screenHeight * 0.30)
                    }
                }
                .onTapGesture {
                    sourceType = .photoLibrary
                    isImagePickerDisplay.toggle()
                }
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(.gray, lineWidth: 0.5)
                    .frame(height: 50)
                HStack {
                    TextField("Add a caption...", text: $typingMessage)
                        .textFieldStyle(.plain)
                        .frame(minHeight: CGFloat(30))
                }
                .padding()
            }
            .frame(minHeight: CGFloat(50))
            .padding()
            
            Spacer()
            Button(action: {
                postCreationModel.createPost(caption: typingMessage, image: selectedImage) { success in
                    if success {
                        typingMessage = ""
                        selectedImage = nil 
                        self.mode.wrappedValue.dismiss()
                    }
                }
            }) {
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
        .sheet(isPresented: self.$isImagePickerDisplay) {
           ImagePickerView(selectedImage: $selectedImage, sourceType: sourceType)
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
