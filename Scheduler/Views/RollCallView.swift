//
//  RollCallView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 22/10/22.
//

import SwiftUI

struct RollCallView: View {
    
    let impact = UIImpactFeedbackGenerator(style: .rigid)
    
    @State var offset: CGSize = .zero {
        didSet {
            let new = (offset.width.magnitude / UIScreen.main.bounds.width) > 0.3
            let old = (oldValue.width.magnitude/UIScreen.main.bounds.width) > 0.3
            if new != old {
                impact.impactOccurred()
            }
        }
    }
    
    @State var roll: Int? = 1
    
    @State var present = [Int]()
    @State var absent  = [Int]()
    
    var scale: CGSize {
        let moved = offset.width.magnitude
        let scale = max(1 - (moved / UIScreen.main.bounds.width) * 0.5, 0.5)
        return CGSize(width: scale, height: scale)
    }
    
    var rotation: Angle {
        let moved = offset.width
        if moved > 0 {
            let angle = min(moved / UIScreen.main.bounds.width, 1.5)
            return Angle(degrees: 30 * angle)
        } else {
            let angle = max(moved / UIScreen.main.bounds.width,-1.5)
            return Angle(degrees: 30 * angle)
        }
        
    }
    
    var result: Int {
        let moved = offset.width
        let proportion = moved / UIScreen.main.bounds.width
        if proportion > 0.3 {
            return 1
        } else if proportion < -0.3 {
            return -1
        } else {
            return 0
        }
    }
    
    var cardGradient: LinearGradient {
        switch result {
            case  0: return .linearGradient(colors: [.blue,     .cyan], startPoint: .bottomTrailing, endPoint: .topLeading)
            case  1: return .linearGradient(colors: [.green,    .mint], startPoint: .bottomTrailing, endPoint: .topLeading)
            case -1: return .linearGradient(colors: [.red,      .pink], startPoint: .bottomTrailing, endPoint: .topLeading)
            default: return .linearGradient(colors: [.yellow, .orange], startPoint: .bottomTrailing, endPoint: .topLeading)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Present: ")
                Text("\(present.reduce("") { $0 + String($1) + "," })")
            }
            HStack {
                Text("Absent: ")
                Text("\(absent.reduce("") { $0 + String($1) + "," })")
            }
            if let roll = roll {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(cardGradient)
                    .padding(48)
                    .aspectRatio(5/7, contentMode: .fit)
                    .overlay {
                        Text("\(roll)")
                            .font(.system(size: 144, weight: .bold))
                    }
                    .offset(offset)
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .gesture(
                        DragGesture()
                            .onChanged { offset in
                                withAnimation(.interactiveSpring()) {
                                    self.offset = offset.translation
                                }
                            }
                            .onEnded { offset in
                                let moved = offset.translation.width
                                let proportion = moved / UIScreen.main.bounds.width
                                
                                if proportion.magnitude <= 0.3 {
                                    withAnimation(.interactiveSpring()) {
                                        self.offset = .zero
                                    }
                                } else {
                                    if proportion > 0 {
                                        present.append(roll)
                                    } else {
                                        absent.append(roll)
                                    }
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        self.offset = CGSize(
                                            width: proportion > 0 ? UIScreen.main.bounds.width*2 : -UIScreen.main.bounds.width*2,
                                            height: 0
                                        )
                                    }
                                    let newRoll = roll + 1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        self.roll = nil
                                        self.offset = .zero
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation {
                                            self.roll = newRoll
                                        }
                                    }
                                }
                            }
                    )
                    .transition(.scale)
            }
            Spacer()
        }
        .padding(.vertical, 64)
    }
}

struct RollCallView_Previews: PreviewProvider {
    static var previews: some View {
        RollCallView()
    }
}
