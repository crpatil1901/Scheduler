//
//  LoginCards.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import SwiftUI

struct UserLoginCard: View {
    
    @Binding var emailText: String
    @Binding var passwordText: String
    
    @State private var isSigningUp = false
    
    var signupAction: (String, String) -> Void
    var loginAction: (String, String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Welcome User")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.bottom, 64)
            
            TextField("Email", text: $emailText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.title3)
                .keyboardType(.emailAddress)
                
            Divider()
                .overlay(.primary)
                .padding(.bottom, 32)
            
            SecureField("Password", text: $passwordText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.title3)
                
            Divider()
                .overlay(.primary)
                .padding(.bottom, 32)
                
            
            Button {
                if isSigningUp {
                    signupAction(emailText, passwordText)
                } else {
                    loginAction(emailText, passwordText)
                }
            } label: {
                Text(isSigningUp ? "Sign Up" : "Log In")
            }
            .buttonStyle(LoginButton())
            
            HStack {
                Text(isSigningUp ? "Already registered? " : "New User? ")
                Button(isSigningUp ? "Log In" : "Sign Up") {
                    withAnimation {
                        isSigningUp.toggle()
                    }
                }
                .fontWeight(.bold)
                .buttonStyle(.plain)
            }
            .padding(.top, 16)
            
            Spacer()
            
        }
        .padding(24)
    }
}

struct ManagerLoginCard: View {
    
    @Binding var emailText: String
    @Binding var passwordText: String
    
    @State private var isSigningUp = false
    
    var signupAction: (String, String) -> Void
    var loginAction: (String, String) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Welcome Manager")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.bottom, 64)
            
            TextField("Email", text: $emailText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.title3)
                .keyboardType(.emailAddress)
                
            Divider()
                .overlay(.primary)
                .padding(.bottom, 32)
            
            SecureField("Password", text: $passwordText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(.title3)
                
            Divider()
                .overlay(.primary)
                .padding(.bottom, 32)
            
            Button {
                if isSigningUp {
                    signupAction(emailText, passwordText)
                } else {
                    loginAction(emailText, passwordText)
                }
            } label: {
                Text(isSigningUp ? "Sign Up" : "Log In")
            }
            .buttonStyle(LoginButton())
            
            HStack {
                Text(isSigningUp ? "Already registered? " : "New User? ")
                Button(isSigningUp ? "Log In" : "Sign Up") {
                    withAnimation {
                        isSigningUp.toggle()
                    }
                }
                .fontWeight(.bold)
                .buttonStyle(.plain)
            }
            .padding(.top, 16)
            
            Spacer()
            
        }
        .padding(24)
    }
}

struct LoginButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.bold)
            .frame(width: 275)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .opacity(configuration.isPressed ? 0.25 : 0.0)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.3), value: configuration.isPressed)
    }
}

struct LoginCards_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginCard(emailText: .constant("Text"), passwordText: .constant(("pass")), signupAction: {_, _ in }, loginAction: {_, _ in })
    }
}
