//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct FivePosLabels: View {
    var body: some View {
        VStack{
            Text("Position")
                .font(.title3)
                .fontWeight(.bold)
            HStack{
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("1")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("2")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("3")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("4")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
                Spacer()
                ZStack{
                    Image(systemName: "square")
                        .font(.title)
                    Text("5")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

struct FivePosLabels_Previews: PreviewProvider {
    static var previews: some View {
        FivePosLabels()
    }
}
