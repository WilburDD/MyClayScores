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
        NavigationStack (path: $roundsData.path) {
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
                        if roundsData.selectedRange == "American Trap" || roundsData.selectedRange == "Continental Trap" || roundsData.selectedRange == "ISSF/Olympic Trap" || roundsData.selectedRange == "Compak/5-Stand" {
                            NavigationLink {
                                FivePosEditView(item: item)
                            } label: {
                                FivePosList(item: item)
                            }
                        } else {
                            if roundsData.selectedRange == "American Skeet" {
                                NavigationLink {
                                    EightPosEditView (item: item)
                                } label: {
                                    EightPosList(item: item)
                                }
                            } else {
                                if roundsData.selectedRange == "ISSF/Olympic Skeet" {
                                    NavigationLink {
                                        NinePosEditView (item: item)
                                    } label: {
                                        NinePosList(item: item)
                                    }
                                } else {
                                    if roundsData.selectedRange == "Double Trap" {
                                        NavigationLink {
                                            DoubleTEditView (item: item)
                                        } label: {
                                            FivePosList(item: item)
                                        }
                                    }
                                }
                            }
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
            RoundedRectangle(cornerRadius: 1)
                .frame(height: 2)
            HStack (alignment: .bottom) {
                Spacer()
                
                NavigationLink {
                    SelectRange()
                } label: {
                    VStack {
                        Image(systemName: "figure.hunting")
                        Text("Range")
                    }
                    .font(.title3)
                }
                Spacer()
                
                NavigationLink(value: roundsData.positions) {
                    VStack {
                        Image(systemName: "plus.square.fill")
                            .font(.title)
                        Text("New Round")
                    }
                    .font(.title3)
                }
                .navigationDestination(for: Int.self) {_ in
                    if roundsData.selectedRange == "American Trap" || roundsData.selectedRange == "Continental Trap" || roundsData.selectedRange == "ISSF/Olympic Trap" || roundsData.selectedRange == "Compak/5-Stand" {
                        FivePosNRView()
                    } else if roundsData.selectedRange == "American Skeet" {
                        EightPosNRView()
                    } else if roundsData.selectedRange == "ISSF/Olympic Skeet" {
                        NinePosNRView()
                    } else if roundsData.selectedRange == "Double Trap" {
                        DoubleTNRView()
                    }
                }
                Spacer()
                
                NavigationLink {
                    StatsView()
                } label: {
                    VStack {
                        Image(systemName: "chart.dots.scatter")
                        Text("Stats")
                    }
                    .font(.title3)
                }
                Spacer()
            }
            .padding(.top)
        }
        .padding()
        .listStyle(.plain)
        .onAppear{
            roundsData.selectedRange = roundsData.storedRange
            if roundsData.selectedRange == "American Skeet" {
                roundsData.positions = 8
            } else if roundsData.selectedRange == "ISSF/Olympic Skeet" {
                roundsData.positions = 9
            } else {
                roundsData.positions = 5
            }
            roundsData.clearData()
            roundsData.fetchRounds()
            roundsData.calcAvgs()
        }
        
        .alert(item: $roundsData.connectivityManager.notificationMessage) { message in
             Alert(title: Text(message.text),
                   dismissButton: .default(Text("Dismiss")))
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        .environmentObject(roundsData)
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

