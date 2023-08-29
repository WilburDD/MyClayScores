//
//  ScoringInfoView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct StatsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        
        VStack {
            HStack {
                Text("\(roundsData.selectedRange)")
                    .font(.title)
//                    .underline()
                    .fontWeight(.bold)
            }
            RoundedRectangle(cornerRadius: 1)
                .frame(height: 2)
            ScrollView {
                
                Text("This will be Stats View")
                    .fontWeight(.bold)
                    .padding(3)
                
                
            }
        }
        .padding()
//            .navigationBarHidden(true)
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(RoundsDataStack())
    }
}

