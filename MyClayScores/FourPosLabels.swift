//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct FourPosLabels: View {
    
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
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("9")
                        .font(.title3)
                        .padding()
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.trailing)
            .environmentObject(roundsData)
        }
    }
    
    
    struct FourPosLabels_Previews: PreviewProvider {
        static var previews: some View {
            FourPosLabels()
                .environmentObject(RoundsDataStack())
        }
    }
    
}
