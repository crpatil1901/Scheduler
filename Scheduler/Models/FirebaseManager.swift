//
//  FirebaseManager.swift
//  Scheduler
//
//  Created by Chinmay Patil on 16/10/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    
    var auth: Auth
    var db: Firestore
    var storage: Storage
    
    init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        self.storage = Storage.storage()
    }
}
