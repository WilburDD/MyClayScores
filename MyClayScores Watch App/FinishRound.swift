//
//  FinishRound.swift
//  TrapScores Watch App
//
//  Created by Doxie Davis on 10/14/23.
//

import SwiftUI

struct FinishRound: View {
    
    @EnvironmentObject var roundData: WatchData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("<")
                        .font(.title2)
                        .foregroundColor(.white)
                })
                .frame(width: 40)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Text("\(roundData.range)")
                .font(.title3)
                .fontWeight(.bold)
                .underline()
            Text("Comment")
                .font(.title3)
            Text("(Tap to enter)")
            TextField (roundData.comment, text: $roundData.comment)
                .font(.title3)
                .onChange(of: self.roundData.comment, perform : { value in
                    if value.count > 10 {
                        self.roundData.comment = String(value.prefix(28))
                    }
                })
                .multilineTextAlignment(.center)
//                .padding()
            //
            //            NavigationLink(destination: EnterComment(),
            //                           label: {
            //                Text("Comment")
            //            })
            //            .foregroundColor(.white)
            //            .frame(height: 50)
            //            .background(.teal, in: Capsule())
            Button(action: {
                roundData.addRound(
                    range: roundData.range,
                    comment: roundData.comment,
                    date: Date.now,
                    pos1: Int64(roundData.posCount[0]),
                    pos2: Int64(roundData.posCount[1]),
                    pos3: Int64(roundData.posCount[2]),
                    pos4: Int64(roundData.posCount[3]),
                    pos5: Int64(roundData.posCount[4]),
                    pos6: Int64(roundData.posCount[5]),
                    pos7: Int64(roundData.posCount[6]),
                    pos8: Int64(roundData.posCount[7]),
                    pos9: Int64(roundData.posCount[8]),
                    total: Int64(roundData.roundTotal))
                roundData.saveRounds()
                roundData.fetchRounds()
                roundData.clearData()
                dismiss()
            }, label: {
                Text("Save Round")
                    .font(.title3)
            })
                        .frame(width: 150, height: 50)
            .foregroundColor(.white)
            .background(.green, in: Capsule())
            Spacer()
            
        }
                .ignoresSafeArea(edges: .top)
        //        .ignoresSafeArea(edges: .bottom)
                .navigationBarBackButtonHidden(true)
        //        Spacer()
        .environmentObject(roundData)
    }
}


struct FinishRound_Previews: PreviewProvider {
    static var previews: some View {
        FinishRound()
            .environmentObject(WatchData())
    }
}
