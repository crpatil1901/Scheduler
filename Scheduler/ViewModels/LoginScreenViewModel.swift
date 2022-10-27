//
//  LoginScreenViewModel.swift
//  Scheduler
//
//  Created by Chinmay Patil on 14/10/22.
//

import SwiftUI
import Firebase

class LoginScreenViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isLoggedIn = false
    @Published var isShowingAlert = false
    
    @Published var fetchedData: [String: Any]? = nil
    
    var email: String? = nil
    
    @Published var alertText: String? {
        didSet {
            isLoading = false
            isShowingAlert = true
        }
    }
    
    func createUser(_ email: String, password: String) {
        isLoading = true
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertText = "Error logging in: \(error.localizedDescription)"
                return
            }
            if result != nil {
                self.email = email
                self.getStudentData(email: email)
            } else {
                self.alertText = "Trouble Signing Up"
            }
        }
    }
    
    func logIn(_ email: String, password: String) {
        isLoading = true
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.alertText = "Error signing up: \(error.localizedDescription)"
                return
            }
            if result != nil {
                self.email = email
                self.getStudentData(email: email)
            } else {
                self.alertText = "Trouble logging in"
            }
        }
    }
    
    func getStudentData(email: String) {
        let id = FirebaseManager.shared.auth.currentUser?.uid ?? "error: noUser"
        FirebaseManager.shared.db.collection("users").document(id).getDocument { snapshot, error in
            if let error = error {
                self.alertText = "Error retrieving data: \(error.localizedDescription)"
            } else if let snapshot = snapshot {
                self.fetchedData = snapshot.data()
                withAnimation {
                    self.isLoggedIn = true
                }
            } else {
                self.alertText = "Error retreving data"
            }
        }
    }
}
