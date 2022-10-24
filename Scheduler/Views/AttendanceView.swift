//
//  AttendanceView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 19/10/22.
//

import SwiftUI
import Charts

struct AttendanceView: View {
    @ObservedObject var vm: StudentViewModel
    
    func getColor(_ subject: String) -> Color {
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
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                            AttendanceCardView(attRec: .init(
                                subject: "Overall",
                                conducted: vm.student.attendance.reduce(0) {$0 + $1.conducted},
                                attended: vm.student.attendance.reduce(0) {$0 + $1.attended})
                            )
                            ForEach(vm.student.attendance) { att in
                                AttendanceCardView(attRec: att)
                                    .aspectRatio(3/4, contentMode: .fit)
                            }
                            .onTapGesture {
                                
                            }
                        }
                        .padding(.top, 160)
                    }
                    .padding()
                }
            }
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Attendance")
                        .padding(.horizontal)
                        .font(.largeTitle)
                        .bold()
                    Divider()
                    HStack {
                        Spacer()
                        VStack {
                            Text("Total Lectures")
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text("\(vm.student.attendance.reduce(0) {$0 + $1.conducted} )")
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                        VStack {
                            Text("Total Attended")
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text("\(vm.student.attendance.reduce(0) {$0 + $1.attended} )")
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
                .background {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                        .edgesIgnoringSafeArea(.top)
                }
            }
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(vm: StudentViewModel(Student.sample, signOutAction: {}))
            .preferredColorScheme(.dark)
    }
}
