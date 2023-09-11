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
            //
            //            HStack {
            //                Button(action: {
            //                    if roundData.roundTotal == 0 {
            //                        roundData.clearData()
            //                        dismiss()
            //                    } else {
            //                        showAlert = true
            //                    }
            //                }, label: {
            //                    HStack {
            //                        Text("<")
            //                            .font(.title)
            //                            .foregroundColor(.white)
            //                    }
            //                })
            //                .alert("WARNING", isPresented: $showAlert) {
            //                    Button("DISCARD", role: .destructive) {
            //                        roundData.clearData()
            //                        dismiss()
            //                    }
            //                    Button("Continue Scoring", role: .cancel) {
            //                        showAlert = false
            //                    }
            //                } message: {
            //                    Text("Exiting without saving round will discard any scoring input.")
            //                }
            //                Spacer()
            //                Button(action: {
            //                    // Action to send data to phone here... with acknowledgement button?
            //                }, label: {
            //                    Text("SAVE")
            //                })
            //                .font(.headline.bold())
            //                .background(.blue)
            //                .foregroundColor(.white)
            //                .clipShape(Capsule())
            //            }
            
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
            Button(action: {
                // Action to send data to phone here... with acknowledgement button?
            }, label: {
                Text("Save")
            })
            .font(.title3)
            .foregroundColor(.white)
            .background(.blue, in: Capsule())
            .frame(width: 70)
//            .clipShape(Capsule())
        }
        .listStyle(CarouselListStyle())
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationTitle {
            HStack {
                Button(action: {
                    if roundData.roundTotal == 0 {
                        roundData.clearData()
                        dismiss()
                    } else {
                        showAlert = true
                    }
                }, label: {
                    HStack {
                        Text("<")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                })
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
                Spacer()
//                Button(action: {
//                    // Action to send data to phone here... with acknowledgement button?
//                }, label: {
//                    Text("Save")
//                })
//                .font(.title3)
//                .background(.blue)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//                .padding()
                //                Spacer()
            }
            .padding(.trailing)
        }
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
//
//
//    struct ScoringView_Previews: PreviewProvider {
//        static var previews: some View {
//            ScoringView()
//                .environmentObject(WatchData())
//        }
//    }
