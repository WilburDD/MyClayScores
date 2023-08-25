//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct TwoPosLabels: View {
    var body: some View {
        VStack{
//            Text("Position")
//                .font(.title3)
            HStack{
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
                Spacer()
//                ZStack{
//                    Image(systemName: "square")
//                        .font(.title)
//                    Text("3")
//                        .font(.title3)
//                         .padding()
//                }
//                Spacer()
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

struct TwoPosLabels_Previews: PreviewProvider {
    static var previews: some View {
        TwoPosLabels()
    }
}
