import SwiftUI
import GoogleSignIn

class GoogleAuthModel: ObservableObject {
    
    @Published var givenName: String = "FIRST_NAME"
    @Published var profilePicUrl: String = "PICTURE_URL"
    @Published var emailAdress: String = "EMAIL_ADDRESS"
    @Published var lastName: String = "LAST_NAME"
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = "NO_ERROR"
    
    func checkStatus() {
        if (GIDSignIn.sharedInstance.currentUser != nil) {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let profileUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = user.profile?.givenName ?? "FIRST_NAME"
            self.lastName = user.profile?.familyName ?? "LAST_NAME"
            self.profilePicUrl = profileUrl
            self.emailAdress = user.profile?.email ?? "EMAIL_ADDRESS"
            self.isLoggedIn = true
        } else {
            givenName = "FIRST_NAME"
            lastName = "LAST_NAME"
            profilePicUrl = "PICTURE_URL"
            emailAdress = "EMAIL_ADDRESS"
            isLoggedIn = false
        }
    }
    
    func getCurrentUser() -> User {
        checkStatus()
        return User(firstName: givenName, lastName: lastName, emailAddress: emailAdress, profilePictureURL: profilePicUrl)
    }
    
    func restoreSignIn(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
    }
        
    func signIn(handler: @escaping(_ success: Bool) -> Void){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        let signInConfig = GIDConfiguration.init(clientID: Security.GOOGLE_API_KEY.rawValue)
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { [self] user, error in
                if let error = error {
                    self.errorMessage = "error: \(error.localizedDescription)"
                    handler(false)
                }
                self.checkStatus()
                handler(true)
            }
        )
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
