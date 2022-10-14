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
    
    var attendence: Double
    
    init(id: String, emailID: String, userID: String, name: String, phoneNumber: String, studentClass: String, attendence: Double) {
        self.id = id
        self.emailID = emailID
        self.userID = userID
        self.name = name
        self.phoneNumber = phoneNumber
        self.studentClass = studentClass
        self.attendence = attendence
    }
    
    init(id: String, email: String) {
        self.id = id
        self.emailID = email
        self.userID = email.components(separatedBy: "@").first ?? "error"
        self.name = ""
        self.phoneNumber = ""
        self.studentClass = "SE1"
        self.attendence = 69.42
    }

    init(_ data: [String: Any]) {
        self.id = data["id"] as? String ?? "unknown"
        self.emailID = data["emailID"] as? String ?? "unknown"
        self.userID = data["userID"] as? String ?? "unknown"
        self.name = data["name"] as? String ?? "unknown"
        self.phoneNumber = data["phoneNumber"] as? String ?? "unknown"
        self.studentClass = data["class"] as? String ?? "unknown"
        self.attendence = 69.42
    }
    
    static let sample = Student(id: "REXfctuytVItufd", emailID: "crpatil1901@gmail.com", userID: "crpatil1901", name: "Chinmay Patil", phoneNumber: "9860767300", studentClass: "SE3", attendence: 69.42)
}
