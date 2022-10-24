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
    @Published var lectures = [Lecture]()
    @Published var editMode = false
    @Published var studentImageData: Data? = nil
    
    @Published var pastLectures = [Lecture]()
    @Published var ongoingLectures = [Lecture]()
    @Published var futureLectures = [Lecture]()
    
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
        
        if let imageData = studentImageData {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                print("No User Found")
                return
            }
            FirebaseManager.shared.storage.reference(withPath: uid).putData(imageData) { result in
                switch result {
                    case.failure(let error):
                        print("Error uploading data: \(error.localizedDescription)")
                    case.success(let metadata):
                        print("Image saved: \(metadata)")
                }
            }
        }
    }
    
    func addLecture(_ newLecture: inout Lecture) {
        let data: [String: Any] = [
            "subject": newLecture.subject,
            "professor": newLecture.professor,
            "startTime": Timestamp(date: newLecture.startTime),
            "duration": newLecture.duration,
        ]
        if newLecture.id.isEmpty {
            self.lectures.append(newLecture)
            FirebaseManager.shared.db.collection("classes").document(student.studentClass).collection("lectures").addDocument(data: data) { error in
                if let error = error {
                    print("Error saving data: \(error.localizedDescription)")
                }
            }
        } else {
            for i in 0 ..< self.lectures.count {
                if self.lectures[i].id == newLecture.id {
                    self.lectures[i] = newLecture
                }
            }
            FirebaseManager.shared.db.collection("classes").document(student.studentClass).collection("lectures").document(newLecture.id).setData(data)
        }
        
        self.fetchLectures(className: student.studentClass)
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
                    }.sorted { $0.startTime < $1.startTime }
                    
                    self.pastLectures = [Lecture]()
                    self.futureLectures = [Lecture]()
                    self.ongoingLectures = [Lecture]()
                    
                    for lecture in self.lectures {
                        if lecture.startTime + TimeInterval(lecture.duration*60) < Date() {
                            self.pastLectures.append(lecture)
                        } else if lecture.startTime > Date() {
                            self.futureLectures.append(lecture)
                        } else {
                            self.ongoingLectures.append(lecture)
                        }
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
        print("Started download")
        FirebaseManager.shared.storage.reference(forURL: "gs://scheduler-3ab9f.appspot.com/\(student.id)").getData(maxSize: 10485760) { result in
            print("Downloaded", result)
            switch result {
                case .success(let data):
                    self.studentImageData = data
                case .failure(let error):
                    print("Error Downloading profile picture: \(error.localizedDescription)")
            }
        }
    }
}
