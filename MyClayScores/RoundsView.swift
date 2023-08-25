//
//  ContentView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import SwiftUI
import CoreData
import MediaPlayer

struct RoundsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
        
    var body: some View {
                VStack{
                HStack (alignment: .bottom){
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(2)
                        .italic()
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text("Rounds:  \(roundsData.totalRnds)")
                        Text("Avg:  \(roundsData.totalAvg, specifier: "%.1f")")
                    }
                    .font(.title2)
                }
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
                List {
                    ForEach(roundsData.roundsData, id: \.self) { item in
                        if roundsData.selectedRange == "American Trap" || roundsData.selectedRange == "Continental Trap" || roundsData.selectedRange == "ISSF/Olympic Trap" || roundsData.selectedRange == "Double Trap" || roundsData.selectedRange == "Compak/5-Stand" {
                            FivePosList(item: item)
                        } else if
                            roundsData.selectedRange == "American Skeet" {
                            EightPosList(item: item)
                        } else if
                            roundsData.selectedRange == "ISSF/Olympic Skeet" {
                            NinePosList(item: item)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        roundsData.deleteRound(indexSet: indexSet)
                        roundsData.saveRounds()
                        roundsData.fetchRounds()
                        roundsData.calcAvgs()
                    })
                }
            }
            .padding()
            .listStyle(.plain)
            .onAppear{
                roundsData.selectedRange = roundsData.storedRange
                roundsData.fetchRounds()
                roundsData.calcAvgs()
                if roundsData.selectedRange == "" {
                    roundsData.selection = 1
                }
            }
            .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)

    }
}

struct RoundsView_Previews: PreviewProvider {
    static var previews: some View {
        RoundsView()
            .environment(\.managedObjectContext,
                          RoundsDataStack().managedObjectContext)
            .environmentObject(RoundsDataStack())
    }
}

