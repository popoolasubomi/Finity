//
//  FirestoreManager.swift
//  Finity
//
//  Created by Subomi Popoola on 11/18/22.
//

import FirebaseCore
import FirebaseFirestore

class FirestoreManager {
    
    var database: Firestore
    
    init() {
        database = Firestore.firestore()
    }
    
    private func verifyUserExists(
        emailAddress: String,
        handler: @escaping(_ userExists: Bool) -> Void
    ) {
        database.collection("users").document(emailAddress).getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            handler(snapshot.exists)
        }
    }
    
    private func registerUser(
        firstName: String,
        lastName: String,
        pictureUrl: String,
        emailAddress: String
    ) {
        database.collection("users").document(emailAddress).setData([
            "first": firstName,
            "last": lastName,
            "profile_url": pictureUrl,
            "email_address": emailAddress
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(emailAddress)")
            }
        }
    }
    
    public func verifyUserExistsAndRegister(
        firstName: String,
        lastName: String,
        pictureUrl: String,
        emailAddress: String
    ) {
        verifyUserExists(emailAddress: emailAddress) { userExists in
            if !userExists {
                self.registerUser(firstName: firstName, lastName: lastName, pictureUrl: pictureUrl, emailAddress: emailAddress)
            }
        }
    }
}
