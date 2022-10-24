//
//  LectureCardView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct LectureCardView: View {
    
    let lecture: Lecture
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(lecture.subject)
                    .font(.title2)
                .bold()
                Spacer()
                Text(lecture.professor)
                    .font(.headline)
            }
            HStack {
                Text(lecture.startTime, style: .date)
                Text(lecture.startTime, style: .time)
                Spacer()
                Label("\(lecture.duration)", systemImage: "clock")
            }
        }
        .foregroundColor(lecture.textColor)
        .padding()
        .background(lecture.color.cornerRadius(12))
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct LectureCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Lecture.samples, id: \.id) { lecture in
                    LectureCardView(lecture: lecture)
                }
            }
        }
//        .preferredColorScheme(.dark)
    }
}
