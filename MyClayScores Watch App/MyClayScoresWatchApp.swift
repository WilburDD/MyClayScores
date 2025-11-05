//
//  MCSApp.swift
//  MCS Watch App
//
//  Created by Doxie Davis on 9/5/23.
//

import SwiftUI
import SwiftData
import WatchKit

@main
struct MyClayScores_Watch_AppApp: App {

    @StateObject var roundData = WatchData()
    
    static let container: ModelContainer = {
        do {
            let schema = Schema([Round.self])
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            print("Failed to create ModelContainer with CloudKit: \(error)")
            do {
                let schema = Schema([Round.self])
                let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ChooseRange()
                .environmentObject(roundData)
                .modelContainer(MyClayScores_Watch_AppApp.container)
                .onAppear {
                    roundData.setModelContext(MyClayScores_Watch_AppApp.container.mainContext)
                }
        }
    }
}
