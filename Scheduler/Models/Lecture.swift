//
//  Lecture.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct Lecture: Identifiable {
    var id: String
    var subject: String
    var professor: String
    var startTime: Date
    var duration: Int
    
    var color: Color {
        switch subject {
            case "CG"  : return Color.yellow
            case "DM"  : return Color.teal
            case "FDS" : return Color.green
            case "OOP" : return Color.orange
            case "DELD": return Color.blue
            case "DSL" : return Color.pink
            case "DEL" : return Color.cyan
            case "HSS" : return Color.mint
            case "BCSL": return Color.purple
            case "OOPCGL": return Color.brown
            default: return Color.red
        }
    }
    
    var textColor: Color {
        switch subject {
            case "CG"  : return Color.black
            case "DM"  : return Color.black
            case "FDS" : return Color.black
            case "OOP" : return Color.black
            case "DELD": return Color.white
            case "DSL" : return Color.black
            case "DEL" : return Color.black
            case "HSS" : return Color.black
            case "BCSL": return Color.white
            case "OOPCGL": return Color.white
            default: return Color.white
        }
    }
    
    static let samples = [
        Lecture(id: UUID().uuidString ,subject: "CG", professor: "Laxmi Pawar", startTime: Date()+5, duration: 60),
        Lecture(id: UUID().uuidString ,subject: "DM", professor: "Priyanka", startTime: Date(timeIntervalSinceNow: 3600), duration: 60),
        Lecture(id: UUID().uuidString ,subject: "DSL", professor: "Sheetal Sonawane", startTime: Date(timeIntervalSinceNow: 8100), duration: 120),
        Lecture(id: UUID().uuidString ,subject: "OOP", professor: "Aarti Deshpande", startTime: Date(timeIntervalSinceNow: 18000), duration: 60),
    ]
    
    init(id: String, subject: String, professor: String, startTime: Date, duration: Int) {
        self.id = id
        self.subject = subject
        self.professor = professor
        self.startTime = startTime
        self.duration = duration
    }
    
    init() {
        self.id = ""
        self.subject = "CG"
        self.professor = ""
        self.startTime = Date() + 3600
        self.duration = 60
    }
}
