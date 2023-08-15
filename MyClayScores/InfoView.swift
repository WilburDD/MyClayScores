//
//  ScoringInfoView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct InfoView: View {
    
    var body: some View {
        
        VStack {
            Text("How To Use")
                .font(.title.italic())
                .fontWeight(.bold)
                .padding(5)
                .padding(.top)
            ScrollView {
                
                Text(" - App can be run on either an iPhone or iPad. \n\n - App must be running and visible on screen during scoring.  Do not push lock/sleep button, go to home screen or switch to another app during or prior to scoring.\n\n - Tap on the Range name at top of the Rounds or Graphs screen to switch between each Range's data. \n\n - Once Range, starting Position and method of Scoring Input (see below) have been selected, scoring will start automatically at the starting position selected.  After 5 shots, scoring will move to the next position.  Scoring will stop when 25 rounds have been shot and go to New Round Edit screen.\n\n - On the New Round Edit screen you can change Range selection, edit each position's Score if needed and add a Comment.  Date & time are automatically entered and cannot be changed.\n\n - Saved rounds can be edited by touching on the round in the Rounds view.  (Note: Press 'return' after editing a comment.)\n\n - Saved rounds can be deleted (permanently) by swiping to the left on the round in the Rounds view.\n\n - There are two ways to enter your HIT or MISS score after each shot:")
                    .fontWeight(.bold)
                    .padding(3)
                Text("1. Using iPad/iPhone:  Tap either the HIT or MISS button on the New Round screen.")
                    .padding(8)
                Text("2. Use a Bluetooth camera shutter remote (examples shown).  Shutter remote must be paired with phone via Bluetooth.")
                Text("Click either button once for a HIT and double-click for a MISS.")
//                    .fontWeight(.bold)
                    .padding(8)
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
                //                Spacer()
                
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


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

