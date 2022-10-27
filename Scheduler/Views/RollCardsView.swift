//
//  RollCardsView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 02/11/22.
//

import SwiftUI

struct RollCard {
    
    let rollNumber: Int
    var state: CardState
    
    enum CardState {
        case present
        case absent
        case unknown
    }
    
}

struct RollCardsView: View {
    
    @State var records: [RollCard]
    @State var currentIndex: Int = 0
    @State var isShowingCard = true
    @Namespace var cardAnimation
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    @State var offset: CGSize = .zero
    
    var scale: CGSize {
        let minScale = 0.4
        let proportion = Double(offset.width.magnitude / screenWidth)
        let scale = minScale + (1-minScale) * powl(2.731, -proportion*proportion)
        return CGSize(width: scale, height: scale)
    }
    
    var rotation: Angle {
        let proportion = Double(offset.width / screenWidth)
        return Angle(degrees: proportion > 1 ? 30 : proportion < -1 ? -30 : proportion * 30)
    }
    
    init(rollNumbers: [Int]) {
        self.records = rollNumbers.map { RollCard(rollNumber: $0, state: .unknown) }
    }

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(records, id: \.rollNumber) { record in
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(lineWidth: 4)
                            if !(self.isShowingCard && self.records[currentIndex].rollNumber == record.rollNumber) {
                                RoundedRectangle(cornerRadius: 8)
                                    .matchedGeometryEffect(
                                        id: self.records[currentIndex].rollNumber == record.rollNumber ? "current" : "\(record.rollNumber)",
                                        in: cardAnimation
                                    )
//                                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                                    .foregroundColor(record.state == .present ? .green : record.state == .absent ? .red : .gray)
                                Text("\(record.rollNumber)")
                                    .matchedGeometryEffect(
                                        id: self.records[currentIndex].rollNumber == record.rollNumber ? "currentTxt" : "\(record.rollNumber)Txt",
                                        in: cardAnimation
                                    )
//                                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
                                    .font(.title)
                                    .bold()
                            }
                        }
                        .aspectRatio(5/7, contentMode: .fit)
                    }
                }
            }
            .frame(height: 80)
            .backgroundStyle(.ultraThinMaterial)
            if isShowingCard {
                RoundedRectangle(cornerRadius: 24)
                    .matchedGeometryEffect(id: "current", in: cardAnimation)
                    .foregroundColor(.blue)
                    .overlay {
                        Text("\(records[currentIndex].rollNumber)")
                            .matchedGeometryEffect(id: "currentTxt", in: cardAnimation)
                    }
                    .aspectRatio(5/7, contentMode: .fit)
                    .padding(32)
                    .offset(self.offset)
                    .scaleEffect(self.scale)
                    .rotationEffect(self.rotation, anchor: .center)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.interactiveSpring()) {
                                    self.offset = value.translation
                                }
                            }
                            .onEnded { value in
                                
                                let proportion = value.translation.width / screenWidth
                                
                                withAnimation(.spring()) {
                                    if proportion.magnitude < 0.35 {
                                            self.offset = .zero
                                    } else {
                                        
                                        if proportion > 0 {
                                            self.offset = CGSize(width:  screenWidth*2.5, height: 0)
                                        } else {
                                            self.offset = CGSize(width: -screenWidth*2.5, height: 0)
                                        }
                                        
                                        let nextIndex = currentIndex+1
                                        if nextIndex < records.count {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                isShowingCard = false
                                                self.currentIndex = nextIndex
                                                self.offset = .zero
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                withAnimation {
                                                    isShowingCard = true
                                                }
                                            }
                                        } else {
                                            // TODO: Show Edit Card
                                        }
                                        
                                    }
                                }
                            }
                    )
                    .transition(.slide)
            }
            Spacer()
        }
    }
}

struct RollCallViewNew_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            RollCardsView(rollNumbers: [1,2,3,4,5,6,7])
                .tabItem {
                    Label("Attendance", systemImage: "menucard")
                }
        }
    }
}
