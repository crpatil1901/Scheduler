//
//  AttendanceCardView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 19/10/22.
//

import SwiftUI

struct AttendanceCardView: View {
    
    var attRec: AttendanceRecord
    
    var completion: Double {
        Double(attRec.attended) / Double(attRec.conducted)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 4)
                .foregroundColor(attRec.color)
            VStack {
                HStack{
                    Text(attRec.subject)
                        .font(.headline)
                        .bold()
                        Spacer()
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 16)
                        .foregroundColor(attRec.color)
                        .opacity(0.1)
                    Circle()
                        .trim(from: 0, to: completion)
                        .rotation(Angle(degrees: -90))
                        .stroke(
                            .angularGradient(
                                colors: [attRec.color.opacity(0.4), attRec.color],
                                center: UnitPoint(x: 0.5, y: 0.5),
                                startAngle: Angle(degrees: 0 - 90),
                                endAngle: Angle(degrees: (360 * completion) - 90)
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                    Text("\(Int(completion*100.rounded()))%")
                        .font(.headline)
                        .bold()
                }
                .padding(.horizontal, 4)
            }
            .padding(12)
        }
    }
}

struct AttendanceCardView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceCardView(attRec: .init(subject: "OOPCGL", conducted: 7, attended: 6))
            .frame(width: 150, height: 200)
    }
}
