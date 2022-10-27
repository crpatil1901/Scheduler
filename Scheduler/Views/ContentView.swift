//
//  ContentView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 14/10/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var loginVM = LoginScreenViewModel()
    
    
    func getStudentObject() -> Student {
        if let data = loginVM.fetchedData {
            return Student(data)
        } else {
            return Student(email: loginVM.email ?? "error@error.com")
        }
        
    }
    
//    var body: some View {
//        if loginVM.isLoggedIn {
//            HomeView(vm: StudentViewModel(
//                getStudentObject(),
//                signOutAction: {
//                    withAnimation {
//                        loginVM.isLoggedIn = false
//                        loginVM.isLoading = false
//                    }
//                    try? FirebaseManager.shared.auth.signOut()
//                }
//            ))
//            .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
//        } else {
//            LoginScreen(vm: loginVM)
//        }
//    }
    var body: some View {
        RollCardsView(rollNumbers: [1,2,3,4,5,6,7])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
