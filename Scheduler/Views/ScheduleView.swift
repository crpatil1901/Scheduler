//
//  ScheduleView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct ScheduleView: View {
    
    @State var isSheetPresented = false
    @State var sheetLecture = Lecture()
    @ObservedObject var vm: StudentViewModel
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if !vm.ongoingLectures.isEmpty {
                        HStack {
                            Text("Current: ")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    ForEach(vm.ongoingLectures) { lecture in
                        Button {
                            sheetLecture = lecture
                            isSheetPresented = true
                        } label: {
                            LectureCardView(lecture: lecture)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(lineWidth: 4)
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                }
                        }
                    }
                    if !vm.futureLectures.isEmpty {
                        HStack {
                            Text("Upcoming: ")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    ForEach(vm.futureLectures) { lecture in
                        Button {
                            sheetLecture = lecture
                            isSheetPresented = true
                        } label: {
                            LectureCardView(lecture: lecture)
                        }
                    }
                    if !vm.pastLectures.isEmpty {
                        HStack {
                            Text("Past: ")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    ForEach(vm.pastLectures) { lecture in
                        Button {
                            sheetLecture = lecture
                            isSheetPresented = true
                        } label: {
                            LectureCardView(lecture: lecture)
                        }
                        .saturation(0)
                    }
                    .onDelete { index in
                        print("deleted \(index)")
                    }
                }
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
            .refreshable {
                vm.fetchLectures(className: vm.student.studentClass)
            }
            .navigationTitle("Schedule")
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isSheetPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .sheet(isPresented: $isSheetPresented, onDismiss: {
            self.sheetLecture = Lecture()
        }) {
            NavigationView {
                LectureEditView(lecture: $sheetLecture, isShown: $isSheetPresented, confirmationAction: {
                    vm.addLecture(&sheetLecture)
                    isSheetPresented = false
                })
                    .navigationTitle("Edit Lecture")
            }
            
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(vm: StudentViewModel(Student.sample, signOutAction: {}))
    }
}
