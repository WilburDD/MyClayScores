////
////  ScoringSelectionView.swift
////  MyClayScores
////
////  Created by Doxie Davis on 6/23/23.
////
//
//import SwiftUI
//
//struct ScoringSelectionView: View {
//    
//    @EnvironmentObject var roundsData: RoundsDataStack
//    
//    var body: some View {
//        VStack {
//            Text ("Scoring input?")
//                .font(.title)
//                .fontWeight(.bold)
//                .italic()
//            HStack {
//                Spacer()
//                Button(action: {
//                    roundsData.phoneScoring = false
//                    roundsData.clickerOpacity = 1.0
//                    roundsData.phoneOpacity = 0.5
//                }, label: {
//                    Text("Clicker").font(.title)
//                })
//                .font(.headline)
//                .padding(10)
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .clipShape(Capsule())
//                .opacity(roundsData.clickerOpacity)
//                Spacer()
//                Button(action: {
//                    roundsData.phoneScoring = true
//                    roundsData.clickerOpacity = 0.5
//                    roundsData.phoneOpacity = 1.0
//                }, label: {
//                    Text("On-screen HIT/MISS").font(.title)
//                })
//                .font(.headline)
//                .padding(10)
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .clipShape(Capsule())
//                .opacity(roundsData.phoneOpacity)
//                Spacer()
//            }
//        }
//    }
//}
//
//struct ScoringSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoringSelectionView()
//            .environmentObject(RoundsDataStack())
//    }
//}
