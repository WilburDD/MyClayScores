//
//  ContentView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import SwiftUI
import CoreData
import MediaPlayer

struct FivePosView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        
        VStack{
            HStack{
                Text("\(roundsData.selectedRange)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(2)
                Spacer()
            }
            .padding(10)
//            Section(header: RoundsHeader()) {
                List {
                    ForEach(roundsData.roundsData, id: \.self) { item in
                        FivePosList(item: item)
                    }
                }
                .listStyle(.plain)
//            }
            .onAppear{
                roundsData.fetchRounds()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}


struct FivePosView_Previews: PreviewProvider {
    static var previews: some View {
        FivePosView()
            .environment(\.managedObjectContext,
                          RoundsDataStack().managedObjectContext)
            .environmentObject(RoundsDataStack())
    }
}

