//
//  HomeView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct HomeView: View {
    
    init(vm: StudentViewModel) {
        self.vm = vm
        if vm.student.name == "" {
            tab = 2
            vm.editMode = true
        } else {
            tab = 1
        }
    }
    
    @ObservedObject var vm: StudentViewModel
    @State var tab: Int
    
    var body: some View {
        TabView(selection: $tab.animation()) {
            ScheduleView(vm: vm)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(1)
            ProfileView(vm: vm)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(vm: StudentViewModel(Student.sample, signOutAction: {}))
    }
}
