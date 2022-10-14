//
//  LectureEditView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct LectureEditView: View {
    
    @Binding var lecture: Lecture
    @Binding var isShown: Bool
    
    var confirmationAction: () -> Void
    
    private let subjects = ["CG", "OOP", "FDS", "DELD", "DM", "DSL", "OOPCGL", "DSL", "HSS", "BCSL"]
    
    var body: some View {
        Form {
            Picker("Subject", selection: $lecture.subject) {
                ForEach(subjects, id: \.self) { sub in
                    Text(sub)
                }
            }
            TextField("Professor Name", text: $lecture.professor)
                .autocorrectionDisabled(true)
            DatePicker("Start time", selection: $lecture.startTime)
                .datePickerStyle(.graphical)
            Picker("Duration", selection: $lecture.duration) {
                ForEach([30, 60, 90, 120], id: \.self) { i in
                    Text("\(i) Minutes")
                        .tag(i)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    confirmationAction()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    isShown = false
                }
            }
        }
    }
}

//struct LectureEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        LectureEditView(lecture: .constant(Lecture.samples.first!))
//    }
//}
