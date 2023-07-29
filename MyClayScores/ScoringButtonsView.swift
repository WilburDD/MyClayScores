//
//  ScoringButtonsView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct ScoringButtonsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                roundsData.hitScore = true
                roundsData.countShot()
            }, label: {
                Text("Hit").frame(width: 150, height: 150)
            })
            .padding(.all)
            .font(.title)
            .frame(width: 125, height: 125)
            .background(Color(.green))
            .foregroundColor(.black)
            .clipShape(Circle())
            Spacer()
            Button(action: {
                roundsData.hitScore = false
                roundsData.countShot()
            }, label: {
                Text("Miss").frame(width: 100, height: 100)
            })
            .padding(.all)
            .font(.title)
            .frame(width: 125, height: 125)
            .background(Color(.red))
            .foregroundColor(.black)
            .clipShape(Circle())
            Spacer()
        }
    }
}

struct ScoringButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringButtonsView()
    }
}
