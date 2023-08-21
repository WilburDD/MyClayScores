//
//  FiveSinglesView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 8/5/23.
//

import SwiftUI

struct FiveSinglesView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack

    var body: some View {
        HStack (spacing: 40) {
//            Spacer()
            ForEach((1...5), id: \.self) {pos in
                
                                    ZStack {
                                        Text ("\(roundsData.posCount[pos])")
                                            .font(.largeTitle).underline().fontWeight(.bold)
                                        Picker("", selection: $roundsData.posCount[pos]) {
                                            Text("0").tag(0)
                                            Text("1").tag(1)
                                            Text("2").tag(2)
                                            Text("3").tag(3)
                                            Text("4").tag(4)
                                            Text("5").tag(5)
                                                .pickerStyle(MenuPickerStyle())
                                        }
                                        .opacity(0.1)
                                    }
                
                
                
//                Button(action: {
//                    roundsData.pos1Hit.toggle()
//            }, label: {
//                if roundsData.pos1Hit == false {
//                    Image(systemName: "circle")
//                }
//                if roundsData.pos1Hit == true {
//                    Image(systemName: "circle.fill")
//                }
//            })
//            .font(.title)
//            Spacer()
            }

//            Button(action: {
//
//            }, label: {
//                Image(systemName: "circle")
//            })
//            .font(.title)
//            Spacer()
//            Button(action: {
//
//            }, label: {
//                Image(systemName: "circle")
//            })
//            .font(.title)
//            Spacer()
//            Button(action: {
//
//            }, label: {
//                Image(systemName: "circle")
//            })
//            .font(.title)
//            Spacer()
//            Button(action: {
//
//            }, label: {
//                Image(systemName: "circle")
//            })
//            .font(.title)
        }
//        .padding(20)
    }
}

struct FiveSinglesView_Previews: PreviewProvider {
    static var previews: some View {
        FiveSinglesView()
            .environmentObject(RoundsDataStack())
    }
}
