////
////  CompakScoringView.swift
////  MyClayScores
////
////  Created by Doxie Davis on 8/22/23.
////
//
//import SwiftUI
//import CoreData
//
//struct CompakScoringView: View {
//    
//    @EnvironmentObject var roundsData: RoundsDataStack
//
//    var body: some View {
//        Spacer()
//        HStack {
//            Text("Compak/5-Stand Scoring")
//            Spacer()
//            Text("Position:  \(roundsData.scoringPos + 1)")
//        }
//        .font(.title3)
//        .padding()
//        VStack {
//            Text("Single")
//            HStack {
//                Button(action: {
//                    
//                }, label: {
//                    Text("Hit")
//                })
//                Button(action: {
//                    
//                }, label: {
//                    Text("Miss")
//                })
//            }
//            VStack {
//                Text("First Double")
//                HStack {
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Hit")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Miss")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Hit")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Miss")
//                    })
//                }
//            }
//            VStack {
//                Text("Second Double")
//                HStack {
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Hit")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Miss")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Hit")
//                    })
//                    Button(action: {
//                        
//                    }, label: {
//                        Text("Miss")
//                    })
//                }
//            }
//            Spacer()
//            Button(action: {
//                roundsData.showScoring.toggle()
//            }, label: {
//                Text("DONE")
//            })
//            .font(.headline)
//            .padding(10)
//            .background(Color.blue)
//            .foregroundColor(Color.white)
//            .clipShape(Capsule())
//        }
//    }
//}
//
//struct CompakScoringView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompakScoringView()
//            .environmentObject(RoundsDataStack())
//
//    }
//}
