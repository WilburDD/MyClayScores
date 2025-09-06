//
//  EnterScore.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/7/23.
//

import SwiftUI

struct EnterScore: View {
    
    @EnvironmentObject var roundData: WatchData
    @Environment(\.dismiss) var dismiss
    
    var item: Int

    var body: some View {
        
        VStack {
            Text("\(roundData.range)")
                .font(.title3)
                .fontWeight(.bold)
                .underline()
            Text("Position \(roundData.pos)")
                .font(.title3)
            Text("Scroll & Tap on Score:")
                .font(.title3)
            Spacer()
            Picker ("", selection: $roundData.posCount[item]) {
                ForEach(0...roundData.scoring[item], id: \.self) { count in
                    Text("\(count)").tag(count)
                }
            }
            .pickerStyle(.wheel)
            .scaleEffect(1.3)
            .font(.title)
            .frame(width: 100)
            .onTapGesture {
                roundData.addupScore()
                dismiss()
            }
        }
        .environmentObject(roundData)
//        .navigationBarBackButtonHidden(true)
    }
}

struct EnterScore_Previews: PreviewProvider {
    static var previews: some View {
        EnterScore(item: 2)
            .environmentObject(WatchData())
    }
}
