//
//  MyClayScoresApp.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

@main
struct MyClayScoresApp: App {
    
    @EnvironmentObject var roundsDataStack: RoundsDataStack
    
//    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
                RoundsView()
                .environmentObject(roundsDataStack)
                .environment(\.managedObjectContext,
                              roundsDataStack.managedObjectContext)
//                .onChange(of: scenePhase) { _ in
//                    roundsDataStack.saveRounds()
//                }
        }
    }
}

