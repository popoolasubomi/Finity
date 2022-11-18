import SwiftUI
import SwiftUISegues
import GoogleSignInSwift

struct RegistrationView: View {
    
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    @EnvironmentObject private var googleAuthModel: GoogleAuthModel
    
    @ViewBuilder
    private var backgroundColor: some View {
        LinearGradient(
            gradient: Gradient(colors: [.white, CustomColor.themeColor]),
            startPoint: .center,
            endPoint: .bottom
        )
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var image: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .padding(.top, 35)
    }
    
    @ViewBuilder
    private var button: some View {
        Button(action: {
            googleAuthModel.signIn { success in
                if success {
                    let firstName = googleAuthModel.givenName
                    let lastName = googleAuthModel.lastName
                    let pictureUrl = googleAuthModel.profilePicUrl
                    let emailAddress = googleAuthModel.emailAdress
                    
                    let firestoreManager = FirestoreManager()
                    firestoreManager.verifyUserExistsAndRegister(firstName: firstName, lastName: lastName, pictureUrl: pictureUrl, emailAddress: emailAddress)
                }
            }
        }) {
            Image("RegisterButton")
            
        }
        .padding(.bottom, 30)
        .frame(width: 200, height: 45)
        
    }
    
    @ViewBuilder
    private var text: some View {
        Text("Property of Finity")
            .foregroundColor(.white)
            .font(.callout)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack(spacing: 250) {
                image
                button
                text
            }
            .task {
                try? await Task.sleep(for: Duration.seconds(2))
                self.launchScreenState.dismiss()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(LaunchScreenStateManager())
            .environmentObject(GoogleAuthModel())
    }
}
