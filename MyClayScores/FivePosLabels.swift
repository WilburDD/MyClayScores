//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct FivePosLabels: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack (spacing: 0) {
            Text("Position")
                .font(.title3)
            HStack {
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("1")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("2")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("3")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("4")
                        .font(.title3)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("5")
                        .font(.title3)
                        .padding()
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .environmentObject(roundsData)
        }
    }
    
    
    struct FivePosLabels_Previews: PreviewProvider {
        static var previews: some View {
            FivePosLabels()
                .environmentObject(RoundsDataStack())
        }
    }
    
}
