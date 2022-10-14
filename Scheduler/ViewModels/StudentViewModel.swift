//
//  StudentViewModel.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import SwiftUI
import FirebaseFirestore

class StudentViewModel: ObservableObject {
    
    @Published var student: Student
    @Published var lectures = /* [Lecture]() */ Lecture.samples
    @Published var editMode = false
    
    var signOutAction: () -> Void
    
    func saveStudentData() {
        let studentData = [
            "id": student.id,
            "emailID": student.emailID,
            "userID": student.userID,
            "name": student.name,
            "phoneNumber": student.phoneNumber,
            "class": student.studentClass,
        ]
        
        FirebaseManager.shared.db.collection("users").document(student.id).setData(studentData) { error in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
            }
        }
    }
    
    func addLecture(_ newLecture: inout Lecture) {
        for i in 0 ..< self.lectures.count {
            if self.lectures[i].id == newLecture.id {
                self.lectures[i] = newLecture
                return
            }
        }
        self.lectures.append(newLecture)
        newLecture = Lecture()
    }
    
    func fetchLectures(className: String) {
        FirebaseManager.shared.db.collection("classes").document(className).collection("lectures").getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving data: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot {
                    self.lectures = snapshot.documents.map { document in
                        let data = document.data()
                        return Lecture(
                            id: document.documentID,
                            subject: data["subject"] as? String ?? "Unknown",
                            professor: data["professor"] as? String ?? "Unknown",
                            startTime: (data["startTime"] as? Timestamp)?.dateValue() ?? Date.distantPast,
                            duration: data["duration"] as? Int ?? 0
                        )
                    }
                } else {
                    print("Snapshot invalid")
                }
            }
        }
    }
    
    init(_ student: Student, signOutAction: @escaping () -> Void) {
        self.student = student
        self.signOutAction = signOutAction
        if !student.studentClass.isEmpty {
            self.fetchLectures(className: student.studentClass)
        }
    }
}
