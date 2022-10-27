//
//  Student.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import Foundation

struct Student: Identifiable {
    
    let id: String
    var emailID: String
    var name: String
    var phoneNumber: String
    var studentClass: String
    var rollNumber: Int
    
    var attendance: [AttendanceRecord]  = [
        .init(subject: "CG", conducted: 38, attended: 29),
        .init(subject: "DM", conducted: 42, attended: 31),
        .init(subject: "FDS", conducted: 36, attended: 32),
        .init(subject: "DELD", conducted: 35, attended: 25),
        .init(subject: "OOP", conducted: 39, attended: 31),
        .init(subject: "DSL", conducted: 15, attended: 13),
        .init(subject: "OOPCGL", conducted: 13, attended: 12),
        .init(subject: "DEL", conducted: 7, attended: 6),
        .init(subject: "BCSL", conducted: 5, attended: 2),
        .init(subject: "HSS", conducted: 7, attended: 5),
    ]
    
    var aggregateAttendance: Double {
        attendance.reduce(0) {$0 + Double($1.attended)} / attendance.reduce(0) {$0 + Double($1.conducted)}
    }
    
    init(id: String, emailID: String, userID: String, name: String, phoneNumber: String, studentClass: String, rollNo: Int) {
        self.id = id
        self.emailID = emailID
        self.name = name
        self.phoneNumber = phoneNumber
        self.studentClass = studentClass
        self.rollNumber = rollNo
    }
    
    init(email: String) {
        self.emailID = email
        self.id = email.components(separatedBy: "@").first ?? "BadEmail"
        self.name = ""
        self.phoneNumber = ""
        self.studentClass = "SE1"
        self.rollNumber = 0
    }

    init(_ data: [String: Any]) {
        print(data)
        self.id = data["registrationNumber"] as? String ?? "unknown"
        self.emailID = data["email"] as? String ?? "unknown"
        self.name = data["name"] as? String ?? "unknown"
        self.phoneNumber = data["phoneNumber"] as? String ?? "unknown"
        self.studentClass = data["className"] as? String ?? "unknown"
        self.rollNumber = data["rollNo"] as? Int ?? -1
    }
    
    static let sample = Student(id: "TEST_STUDENT_USER", emailID: "sample.student@pict.edu", userID: "C2K00000000", name: "Sample Student", phoneNumber: "9999999999", studentClass: "SE3", rollNo: 10436)
}
