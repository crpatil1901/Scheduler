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
    var userID: String
    var name: String
    var phoneNumber: String
    var studentClass: String
    
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
    
    init(id: String, emailID: String, userID: String, name: String, phoneNumber: String, studentClass: String) {
        self.id = id
        self.emailID = emailID
        self.userID = userID
        self.name = name
        self.phoneNumber = phoneNumber
        self.studentClass = studentClass
    }
    
    init(id: String, email: String) {
        self.id = id
        self.emailID = email
        self.userID = email.components(separatedBy: "@").first ?? "error"
        self.name = ""
        self.phoneNumber = ""
        self.studentClass = "SE1"
    }

    init(_ data: [String: Any]) {
        self.id = data["id"] as? String ?? "unknown"
        self.emailID = data["emailID"] as? String ?? "unknown"
        self.userID = data["userID"] as? String ?? "unknown"
        self.name = data["name"] as? String ?? "unknown"
        self.phoneNumber = data["phoneNumber"] as? String ?? "unknown"
        self.studentClass = data["class"] as? String ?? "unknown"
    }
    
    static let sample = Student(id: "REXfctuytVItufd", emailID: "crpatil1901@gmail.com", userID: "crpatil1901", name: "Chinmay Patil", phoneNumber: "9860767300", studentClass: "SE3")
}
