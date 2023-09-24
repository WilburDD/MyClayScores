//
//  Pos1View.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/5/23.
//

import SwiftUI

struct ScoringView: View {
    
    @EnvironmentObject var roundData: WatchData
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert: Bool = false
    
    var item: Int
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if roundData.roundTotal == 0 {
                        roundData.clearData()
                        dismiss()
                    } else {
                        showAlert = true
                    }
                }, label: {
                        Text("<")
                            .font(.title2)
                            .foregroundColor(.white)
                })
                .frame(width: 40, height: 25)
                .alert("WARNING", isPresented: $showAlert) {
                    Button("DISCARD", role: .destructive) {
                        roundData.clearData()
                        dismiss()
                    }
                    Button("Continue Scoring", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("Exiting without saving round will discard any scoring input.")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            VStack {
                Text("\(roundData.range)")
                    .fontWeight(.bold)
                    .underline()
                Text("Total Score: \(roundData.roundTotal)")
            }
            .font(.title3)
            List {
                ForEach (0...roundData.positions, id: \.self) { item in
                    NavigationLink {
                        EnterScore(item: item)
                    } label: {
                        HStack {
                            Spacer()
                            VStack (alignment: .leading) {
                                Text("Pos \(item + 1)")
                                Spacer()
                                Text("Score: ")
                            }
                            .font(.title3)
                            Spacer()
                            Text("\(roundData.posCount[item])")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            HStack {
                NavigationLink(destination: EnterComment(),
                               label: {
                    Text("Comment")
                })
                .foregroundColor(.white)
                .frame(height: 50)
                .background(.teal, in: Capsule())
                Spacer()
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
                    Text("Save")
                })
                .frame(width: 70, height: 50)
                .foregroundColor(.white)
                .background(.green, in: Capsule())
            }
            .padding()
        }
        .listStyle(CarouselListStyle())
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        //        Spacer()
        .environmentObject(roundData)
        .onAppear {
            roundData.range = roundData.ranges[item]
            roundData.pos = item + 1
            if roundData.range == "American Trap" || roundData.range == "Continental Trap" || roundData.range == "ISSF/Olympic Trap" || roundData.range == "Compak/5-Stand" {
                roundData.positions = 4
                roundData.scoring = [5, 5, 5, 5, 5]
            } else if roundData.range == "American Skeet" {
                roundData.positions = 7
                roundData.scoring = [4, 4, 2, 2, 2, 4, 4, 3]
            } else if roundData.range == "ISSF/Olympic Skeet" {
                roundData.positions = 8
                roundData.scoring = [3, 3, 3, 2, 3, 3, 2, 4, 2]
            } else if roundData.range == "Double Trap" {
                roundData.positions = 4
                roundData.scoring = [10, 10, 10, 10, 10]
            }
        }
    }
}


struct ScoringView_Previews: PreviewProvider {
    static var previews: some View {
        ScoringView(item: 1)
            .environmentObject(WatchData())
    }
}
