//
//  MyClayScoresApp.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import SwiftData

@main
struct MyClayScoresApp: App {
    
    @StateObject var roundsDataStack = RoundsDataStack()
    
    @Environment(\.scenePhase) var scenePhase
    
    static let container: ModelContainer = {
        do {
            // First try with explicit schema and CloudKit
            let schema = Schema([Round.self])
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic
            )
            let container = try ModelContainer(for: schema, configurations: [config])
            print("ModelContainer created successfully with CloudKit")
            return container
        } catch {
            print("Failed to create ModelContainer with CloudKit: \(error)")
            // Fallback to local storage without CloudKit
            do {
                let schema = Schema([Round.self])
                let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                let container = try ModelContainer(for: schema, configurations: [config])
                print("ModelContainer created successfully with local storage")
                return container
            } catch {
                print("Failed with local storage: \(error)")
                fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
            }
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RoundsView()
                .environmentObject(roundsDataStack)
                .modelContainer(MyClayScoresApp.container)
                .onAppear {
                    let context = MyClayScoresApp.container.mainContext
                    roundsDataStack.setModelContext(context)
                    
                    // Trigger immediate CloudKit sync on app launch
                    Task {
                        await roundsDataStack.syncFromCloudKit()
                        // After sync completes, fetch and display data
                        roundsDataStack.fetchRounds()
                        roundsDataStack.calcAvgs()
                    }
                    
                    // Attempt migration from Core Data on first launch
                    CoreDataMigration.migrateFromCoreData(to: context) {
                        // After migration completes, refresh the data
                        Task {
                            await roundsDataStack.syncFromCloudKit()
                            roundsDataStack.fetchRounds()
                            roundsDataStack.calcAvgs()
                        }
                    }
                }
                .onChange(of: scenePhase) {
                    roundsDataStack.saveRounds()
                }
        }
    }
}

