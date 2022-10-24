//
//  DashboardView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import SwiftUI
import PhotosUI
import CoreImage.CIFilterBuiltins

struct ProfileView: View {
    
    @ObservedObject var vm: StudentViewModel
    @State private var pickedPhoto: PhotosPickerItem? = nil
    @State var isShowingActionSheet = false
    @State var isShowingBarcode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            if vm.editMode {
                                PhotosPicker(selection: $pickedPhoto) {
                                    if let data = vm.studentImageData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(50)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 50)
                                                    .stroke(lineWidth: 4)
                                                    .frame(width: 100, height: 100)
                                            }
                                            .padding(.bottom, 4)
                                            .transition(.opacity)
                                            
                                    } else {
                                        Image(systemName: "person.circle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .padding(.bottom, 4)
                                            .transition(.opacity)
                                    }
                                }
                                .onChange(of: pickedPhoto) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            vm.studentImageData = data
                                        }
                                    }
                                }
                            } else {
                                if let data = vm.studentImageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                        .padding(.bottom, 4)
                                        .transition(.opacity)
                                } else {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .padding(.bottom, 4)
                                        .transition(.opacity)
                                }
                                
                            }
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
                            Text("69%")
                                .frame(height: 40)
                        }
                        .frame(width: 100)
                    }
                    .padding()
                    Button {
                        isShowingActionSheet = true
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
            .confirmationDialog("Sign Out?", isPresented: $isShowingActionSheet) {
                Button("Sign Out", role: .destructive) {
                    vm.signOutAction()
                }
            } message: {
                Text("Are you sure you want to Sign Out?")
            }
            .sheet(isPresented: $isShowingBarcode){
                BarcodeView(id: vm.student.userID, isPresented: $isShowingBarcode)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.isShowingBarcode = true
                    } label: {
                        Image(systemName: "barcode")
                    }

                }
                ToolbarItem(placement: .primaryAction) {
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
                        }
                    }
                }
            }
        }
    }
}

struct BarcodeView: View {
    
    let id: String
    @Binding var isPresented: Bool
    
    let context = CIContext()
//    let filter = CIFilter.qrCodeGenerator()
    let filter = CIFilter.barcodeGenerator()
    
    func generateBarcode(_ string: String) -> Image {
        
        let errorImage = Image(systemName: "exclamationmark.triangle")
        
        guard let message = string.data(using: .ascii) else { return errorImage }
        
        filter.setValue(message, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else { return errorImage }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return errorImage }
        
        return Image(uiImage: UIImage(cgImage: cgImage))
        
    }
    
    var body: some View {
        NavigationView {
            generateBarcode(id)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: .infinity)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.title)
                        }
                    }
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: StudentViewModel(Student.sample, signOutAction: {}))
    }
}
