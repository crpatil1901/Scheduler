//
//  DashboardView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: StudentViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 96))
                                .padding(.bottom, 4)
                            if vm.editMode {
                                TextField("Name", text: $vm.student.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .frame(height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke()
                                            .foregroundColor(.blue)
                                    )
                            } else {
                                Text(vm.student.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(height: 40)
                            }
                            
                        }
                        Spacer()
                    }
                    
                    .overlay(alignment: .topTrailing) {
                        HStack {
                            if vm.editMode {
                                Button("Done") {
                                    withAnimation {
                                        self.vm.editMode = false
                                    }
                                    vm.saveStudentData()
                                }
                                .bold()
                            } else {
                                Button {
                                    withAnimation {
                                        self.vm.editMode = true
                                    }
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.title2)
                                }
                            }
                        }
                        .frame(height: 40)
                        
                    }
                    .padding()
                    VStack {
                        HStack{
                            Text("Phone Number:")
                            
                            TextField("Phone Number", text: $vm.student.phoneNumber)
                                .keyboardType(.phonePad)
                                .multilineTextAlignment(.trailing)
                                .bold(vm.editMode)
                                .disabled(!vm.editMode)
                        }
                        Divider()
                        HStack{
                            Text("Email:")
                            
                            TextField("Phone Number", text: $vm.student.emailID)
                                .keyboardType(.emailAddress)
                                .multilineTextAlignment(.trailing)
                                .bold(vm.editMode)
                                .disabled(!vm.editMode)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground).cornerRadius(16))
                    .padding()
                    
                    HStack {
                        VStack {
                            Text("Class")
                                .bold()
                            if vm.editMode {
                                Picker("Class", selection: $vm.student.studentClass) {
                                    ForEach(1 ..< 12) { i in
                                        Text("SE\(i)")
                                            .tag("SE\(i)")
                                    }
                                }
                                .frame(height: 40)
                                
                            } else {
                                Text(vm.student.studentClass)
                                    .frame(height: 40)
                            }
                        }
                        .frame(width: 100)
                        Spacer()
                        VStack {
                            Text("User ID")
                                .bold()
                            Text(vm.student.userID)
                                .frame(height: 40)
                        }
                        .frame(width: 110)
                        Spacer()
                        VStack {
                            Text("Attendance")
                                .bold()
                            Text("\(vm.student.attendence.formatted())%")
                                .frame(height: 40)
                        }
                        .frame(width: 100)
                    }
                    .padding()
                    Button {
                        vm.signOutAction()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .bold()
                            .padding()
                            .background(Color.red.cornerRadius(16))
                    }
                    .foregroundColor(.white)
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: StudentViewModel(Student.sample, signOutAction: {}))
            .preferredColorScheme(.dark)
    }
}
