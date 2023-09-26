//
//  ContentView.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/5/23.
//

import SwiftUI
import WatchKit

struct ChooseRange: View {
    
    @EnvironmentObject var roundData: WatchData

    var body: some View {

        NavigationStack {
            VStack {
                Text("Select Range")
                    .font(.title3)
                    .underline()
                    .fontWeight(.bold)
                List {
                    ForEach (0..<7) { item in
                        NavigationLink (destination: ScoringView(item: item)) {
                            HStack {
                                Text("\(roundData.ranges[item])")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                }
                .listStyle(CarouselListStyle())
            }
            .environmentObject(roundData)
            .onAppear {
                roundData.clearData()
            }
        }
    }
}

struct ChooseRange_Previews: PreviewProvider {
    static var previews: some View {
        ChooseRange()
            .environmentObject(WatchData())
    }
}
