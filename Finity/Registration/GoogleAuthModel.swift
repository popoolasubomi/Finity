import SwiftUI
import GoogleSignIn

class GoogleAuthModel: ObservableObject {
    
    @Published var givenName: String = "NO_NAME"
    @Published var profilePicUrl: String = "NO_URL"
    @Published var emailAdress: String = "NO_EMAIL"
    @Published var lastName: String = "NO_NAME"
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = "NO_ERROR"
    
    func checkStatus() {
        if (GIDSignIn.sharedInstance.currentUser != nil) {
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let profileUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = user.profile?.givenName ?? "NO_NAME"
            self.lastName = user.profile?.familyName ?? "NO_NAME"
            self.profilePicUrl = profileUrl
            self.emailAdress = user.profile?.email ?? "NO_EMAIL"
            self.isLoggedIn = true
        } else {
            givenName = "NO_NAME"
            lastName = "NO_NAME"
            profilePicUrl = "NO_URL"
            emailAdress = "NO_EMAIL"
            isLoggedIn = false
        }
    }
    
    func getCurrentUser() -> User? {
        if GIDSignIn.sharedInstance.currentUser == nil {
            return nil
        }
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
