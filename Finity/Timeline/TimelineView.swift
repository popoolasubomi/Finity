//
//  TimelineView.swift
//  Finity
//
//  Created by Subomi Popoola on 11/17/22.
//

import SwiftUI

struct TimelineView: View {
    
    private let firestoreManager = FirestoreManager()
    
    @ViewBuilder
    private var appName: some View {
        Text("Finity")
            .foregroundColor(CustomColor.themeColor)
            .font(Font.custom("SavoyeLetPlain", size: 45.0))
            .padding([.top, .leading], 10.0)
    }
    
    var body: some View {
        NavigationView {
            Text("Hello, world!")
            .navigationBarItems(
                leading: appName,

                trailing: Button(action: {
                // Actions
                }, label: { Image("Icon") })
            )
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
