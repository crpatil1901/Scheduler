//
//  SchedulerApp.swift
//  Scheduler
//
//  Created by Chinmay Patil on 14/10/22.
//

import SwiftUI
import Firebase

@main
struct SchedulerApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}
