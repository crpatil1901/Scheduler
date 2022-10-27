//
//  LectureCardView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 17/10/22.
//

import SwiftUI

struct LectureCardView: View {
    
    @State var isDeleted = false
    @State var offset = 0.0
    @State var isSlid = false
    
    let lecture: Lecture
    
    let deleteAction: (String) -> ()
    
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
        .offset(CGSize(width: offset, height: 0))
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    withAnimation(.interactiveSpring()){
                        if !isSlid {
                            self.offset = max(min(value.translation.width, 0), -UIScreen.main.bounds.width / 3)
                        } else {
                            self.offset = max(min(value.translation.width, UIScreen.main.bounds.width / 5), 0) - UIScreen.main.bounds.width / 5
                        }
                        
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        if self.offset < -UIScreen.main.bounds.width / 7 {
                            self.offset = -UIScreen.main.bounds.width / 5
                            isSlid = true
                        } else {
                            self.offset = 0
                            isSlid = false
                        }
                    }
                }
        )
        .background {
            
            ZStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.red)
                        
                }
                HStack {
                    Spacer()
                    Button {
                        deleteAction(lecture.id)
                    } label: {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width / 5)
                    }

                        
                }
            }
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .transition(.move(edge: .trailing))
    }
}

struct LectureCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Lecture.samples, id: \.id) { lecture in
                    LectureCardView(lecture: lecture, deleteAction: { _ in } )
                }
            }
        }
//        .preferredColorScheme(.dark)
    }
}
