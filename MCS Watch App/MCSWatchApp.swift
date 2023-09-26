//
//  MCSApp.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/5/23.
//

import SwiftUI
import WatchKit

@main
struct MCS_Watch_AppApp: App {

    @StateObject var roundData = WatchData()

    var body: some Scene {
        WindowGroup {
            ChooseRange()
                .environmentObject(roundData)
                .environment(\.managedObjectContext,
                              roundData.managedObjectContext)
        }
    }
}
