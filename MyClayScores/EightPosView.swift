//
//  EightPosView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 8/11/23.
//

import SwiftUI
import CoreData

struct EightPosView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    if roundsData.selectedRange == "American Trap" {
                        roundsData.selectedRange = "Continental Trap"
                        roundsData.contOpactity = 1.0
                        roundsData.amerOpactity = 0.5
                        roundsData.intlOpacity = 0.5
                    } else {
                        if roundsData.selectedRange == "Continental Trap" {
                            roundsData.selectedRange = "Intl./Olympic Trap"
                            roundsData.intlOpacity = 1.0
                            roundsData.contOpactity = 0.5
                            roundsData.amerOpactity = 0.5
                        } else {
                            if roundsData.selectedRange == "Intl./Olympic Trap" {
                                roundsData.selectedRange = "American Trap"
                                roundsData.intlOpacity = 0.5
                                roundsData.contOpactity = 0.5
                                roundsData.amerOpactity = 1.0
                            }}}
                    roundsData.fetchRounds()
                    roundsData.calcAvgs()
                }, label: {
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(2)
                })
                Spacer()
            }
            .padding(10)
            HStack {
                HStack {
                    Text("1")
                    Spacer()
                    Text("2")
                    Spacer()
                    Text("3")
                    Spacer()
                    Text("4")
                    Spacer()
                }
                HStack {
                    Text("5")
                    Spacer()
                    Text("6")
                    Spacer()
                    Text("7")
                    Spacer()
                    Text("8")
                    Spacer()
                }
                Text("19")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
//            Section(header: RoundsHeader()) {
//                List {
//                    ForEach(roundsData.roundsData, id: \.self) { item in
//                        NavigationLink {
//                            SavedRoundEdit(item: item)
//                        } label: {
//                            FivePosList(item: item)
//                        }
//                    }
//                    .onDelete(perform: { indexSet in
//                        roundsData.deleteRound(indexSet: indexSet)
//                        roundsData.saveRounds()
//                        roundsData.fetchRounds()
//                        roundsData.calcAvgs()
//                    })
//                }
//                .listStyle(.plain)
//            }
            .onAppear{
                roundsData.fetchRounds()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct EightPosView_Previews: PreviewProvider {
    static var previews: some View {
        EightPosView()
            .environment(\.managedObjectContext,
                          RoundsDataStack().managedObjectContext)
            .environmentObject(RoundsDataStack())
    }
}

