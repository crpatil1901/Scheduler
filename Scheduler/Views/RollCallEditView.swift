//
//  RollCallEditView.swift
//  Scheduler
//
//  Created by Chinmay Patil on 29/10/22.
//

import SwiftUI

struct RollCallEditView: View {
    @State var records: [(Int, Bool)]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 8), count: 5), spacing: 8) {
                ForEach(records, id: \.0) { record in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .aspectRatio(5/7, contentMode: .fit)
                            .foregroundColor(record.1 ? .green : .red)
                        Text("\(record.0)")
                            .font(.title)
                            .bold()
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            records[record.0 - 1].1.toggle()
                        }
                    }
                    .rotation3DEffect(
                        Angle(degrees: record.1 ? 360 : 0),
                        axis: (0,1,0)
                    )
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Records")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RollCallEditView_Previews: PreviewProvider {
    @State static var records = Array(0..<84).map {($0+1, $0%2==0)}
    static var previews: some View {
        NavigationView {
            RollCallEditView(records: records)
        }
    }
}
