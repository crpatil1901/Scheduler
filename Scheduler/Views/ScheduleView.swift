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
            ScrollView {
                VStack {
                    ForEach(vm.lectures) { lecture in
                        Button {
                            sheetLecture = lecture
                            isSheetPresented = true
                        } label: {
                            LectureCardView(lecture: lecture)
                        }

                        
                    }
                }
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
