//
//  LoginScreen.swift
//  Scheduler
//
//  Created by Chinmay Patil on 14/10/22.
//

import SwiftUI

struct LoginScreen: View {
    
    init(vm: LoginScreenViewModel) {
        self.vm = vm
    }
    
    @ObservedObject var vm: LoginScreenViewModel
    
    private var gradientColors: [Color] = [.pink, .red, .orange]
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isUserSelected = true
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.primary)
                    .colorInvert()
                    .edgesIgnoringSafeArea(.all)
                LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom)
                    .hueRotation(isUserSelected ? Angle(degrees: 0) : Angle(degrees: 180))
                    .cornerRadius(50)
                    .frame(width: 400, height: 600)
                    .rotationEffect(Angle(degrees: 135))
            }
            .clipped()
        .edgesIgnoringSafeArea(.all)
            VStack {
                
                Picker("Login Picker", selection: $isUserSelected.animation()) {
                    Text("User")
                        .tag(true)
                    Text("Manager")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(.regularMaterial)
                .frame(width: 350)
                .cornerRadius(24)
                
                if isUserSelected {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(width: 350, height: 400)
                        .foregroundStyle(.regularMaterial)
                        .overlay {
                            UserLoginCard(emailText: $emailText,
                                      passwordText: $passwordText,
                                      signupAction: vm.createUser,
                                      loginAction: vm.logIn
                            )
                        }
                        .padding()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                } else {
                    RoundedRectangle(cornerRadius: 32)
                        .frame(width: 350, height: 400)
                        .foregroundStyle(.regularMaterial)
                        .overlay {
                            ManagerLoginCard(emailText: $emailText,
                                      passwordText: $passwordText,
                                      signupAction: vm.createUser,
                                      loginAction: vm.logIn
                            )
                        }
                        .padding()
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                }
                
                
            }
            
        }
        .alert("\(vm.alertText ?? "Error")", isPresented: $vm.isShowingAlert) {
            Button("Close") {
                vm.isShowingAlert = false
            }
        }
        .overlay {
            if vm.isLoading {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.ultraThickMaterial)
                    ProgressView()
                        .progressViewStyle(.circular)
                }

            }
        }
    }
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginScreen(vm: LoginScreenViewModel())
            .preferredColorScheme(.dark)
    }
}
