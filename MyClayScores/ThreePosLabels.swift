//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct ThreePosLabels: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("6")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("7")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("8")
                        .font(.title3)
                        .padding()
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
    
    
    struct ThreePosLabels_Previews: PreviewProvider {
        static var previews: some View {
            ThreePosLabels()
                .environmentObject(RoundsDataStack())
        }
    }
    
}
