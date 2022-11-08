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
    @State var records = [(Int, Bool)]()
    @State var isComplete = false
    
    let lastRoll = 21
    
//    @State var roll: Int? = 9
//    @State var records = [(1,true), (2,true), (3,true), (4,true), (5,false), (6,true), (7,true), (8,false), ]
    
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
    
    func getProportion(pos: CGFloat, width: CGFloat) -> Double { return ( pos - width/2 ) / width }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 8)
                            .id(0)
                        ForEach(self.records, id: \.0) { rec in
                            GeometryReader { geometry in
                                let proportion = self.getProportion(
                                    pos: geometry.frame(in: .global).midX,
                                    width: UIScreen.main.bounds.width
                                )
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(rec.1 ? .green : .red)
                                    Text("\(rec.0)")
                                        .font(.title)
                                        .bold()
                                }
                                .rotation3DEffect(
                                    Angle(degrees: 30 * proportion),
                                    axis: (0,1,0)
                                )
                                .scaleEffect(1 - pow(proportion, 2)*1.1)
                                .offset(x: proportion.magnitude < 1 ? (-160) * pow(proportion, 3) : 0)
                            }
                            .aspectRatio(5/7, contentMode: .fit)
                            .id(rec.1)
                            .padding(2.5)
                        }
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 8)
                            .id(-1)
                    }
                    .onChange(of: records.count) { newValue in
                        withAnimation {
                            proxy.scrollTo(-1)
                        }
                    }
                }
            }
            .frame(height: 80)
            if let roll = roll {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(cardGradient)
                    .padding(48)
                    .aspectRatio(5/7, contentMode: .fit)
                    .overlay {
                        Text("\(roll)")
                            .font(.system(size: 144, weight: .bold))
                    }
                    .shadow(
                        color: {
                            switch result {
                                case -1: return .red.opacity(0.8)
                                case  0: return .blue.opacity(0.8)
                                case  1: return .green.opacity(0.8)
                                default: return .primary.opacity(0.8)
                            }
                        }(),
                        radius: 24
                    )
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
                                        withAnimation { records.append((roll,  true)) }

                                    } else {
                                        withAnimation { records.append((roll, false)) }
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
                                        if newRoll <= lastRoll {
                                            withAnimation {
                                                self.roll = newRoll
                                            }
                                        } else {
                                            isComplete = true
                                        }
                                    }
                                }
                            }
                    )
                    .transition(.scale)
            } else if isComplete {
                NavigationLink(destination: RollCallEditView(records: records)) {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(.gray)
                        .padding(48)
                        .aspectRatio(5/7, contentMode: .fit)
                        .overlay {
                            Label("Edit", systemImage: "pencil")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .shadow(
                            color: .gray,
                            radius: 48
                        )
                }
            }
            Spacer()
        }
        .overlay(alignment: .bottom) {
            HStack {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Absent")
                }
                .foregroundColor(.red)
                Spacer()
                HStack {
                    Text("Present")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.green)
            }
            .font(.title3)
            .bold()
            .padding(.horizontal, 32)
        }
        .padding(.vertical)
    }
}

struct RollCallView_Previews: PreviewProvider {
    static var previews: some View {
        RollCallView()
    }
}
