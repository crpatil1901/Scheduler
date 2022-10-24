//
//  AttendanceRecord.swift
//  Scheduler
//
//  Created by Chinmay Patil on 19/10/22.
//

import SwiftUI

struct AttendanceRecord: Identifiable {
    
    var id: UUID
    var subject: String
    var conducted: Int
    var attended: Int
    
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
    
    init(subject: String, conducted: Int, attended: Int) {
        self.id = UUID()
        self.subject = subject
        self.conducted = conducted
        self.attended = attended
    }
}
