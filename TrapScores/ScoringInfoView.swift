//
//  ScoringInfoView.swift
//  TrapScores
//
//  Created by Doxie Davis on 4/7/22.
//

import SwiftUI

struct ScoringInfoView: View {
        
    var body: some View {
        
        VStack {
            Text("How To Use")
                .font(.title.italic())
                .fontWeight(.bold)
                .padding(5)
                .padding(.top)
            ScrollView {
                
                Text(" - App must be running and on phone's screen during scoring.  Do not push lock button on side of phone or switch to another app during or prior to scoring.\n\n - Tap on the Range name at top of the 'Rounds' or 'Graphs' screen to switch between each Range's data. \n\n - Scoring will start automatically at the starting position selected.  After 5 shots, scoring will move to the next position.  Scoring will stop when 25 rounds have been shot and go to 'Round Edit' screen.\n\n - You can edit each position's score if needed and add a Comment on the 'Round Edit' screen.\n\n - Individual rounds can be deleted (permanently) by swiping left on the round in the 'Rounds' view.\n\n - There are two ways to enter your HIT or MISS score after each shot:")
                    .fontWeight(.bold)
                //                                .padding(2)
                    .padding(5)
                Text("1. Using Phone:  Tap either the HIT or MISS button on the iPhone screen.")
                    .padding(5)
                Text("2. Use a Bluetooth camera shutter remote (examples shown). Click either button once for a HIT and double-click for a MISS.")
                    .padding(5)
                //            Spacer()
                HStack {
                    Image("remote")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 145)
                    //            Spacer()
                    Image("remote2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                }
                Spacer()
                
            }
            //            .navigationBarHidden(true)
            .font(.system(size: 18))
            .multilineTextAlignment(.leading)
            .padding(.leading)
            .padding(.trailing)
            .clipped()
        }
    }
}


struct ScoringInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringInfoView()
    }
}

