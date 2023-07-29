//
//  ContentView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import SwiftUI
import CoreData
import MediaPlayer

struct AllRoundsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    if roundsData.selectedRange == "American" {
                        roundsData.selectedRange = "Continental"
                        roundsData.contOpactity = 1.0
                        roundsData.amerOpactity = 0.5
                        roundsData.intlOpacity = 0.5
                    } else {
                        if roundsData.selectedRange == "Continental" {
                            roundsData.selectedRange = "Intl./Olympic"
                            roundsData.intlOpacity = 1.0
                            roundsData.contOpactity = 0.5
                            roundsData.amerOpactity = 0.5
                        } else {
                            if roundsData.selectedRange == "Intl./Olympic" {
                                roundsData.selectedRange = "American"
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
            Section(header: RoundsHeader()) {
                List {
                    ForEach(roundsData.roundsData, id: \.self) { item in
                        NavigationLink {
                            SavedRoundEdit(item: item)
                        } label: {
                            RoundsList(item: item)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        roundsData.deleteRound(indexSet: indexSet)
                        roundsData.saveRounds()
                        roundsData.fetchRounds()
                        roundsData.calcAvgs()
                    })
                }
                .listStyle(.plain)
            }
            .onAppear{
                roundsData.fetchRounds()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct RoundsView_Previews: PreviewProvider {
    static var previews: some View {
        AllRoundsView()
            .environment(\.managedObjectContext,
                          RoundsDataStack().managedObjectContext)
            .environmentObject(RoundsDataStack())
    }
}

