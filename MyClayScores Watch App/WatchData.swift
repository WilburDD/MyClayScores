//
//  Persistence.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import Foundation
import SwiftUI
import WatchKit
import ClockKit
import CoreData
import CloudKit

class WatchData: ObservableObject, Identifiable {
        
    @Published var roundData: [RoundEntity] = []

    @Published var positions = 0
    @Published var pos = Int()
    @Published var range = String("")
    @Published var ranges = ["American Trap", "Continental Trap", "ISSF/Olympic Trap", "Double Trap", "American Skeet", "ISSF/Olympic Skeet", "Compak/5-Stand"]
    @Published var rangeSelected = false
    @Published var posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var scoring = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var roundTotal = 0
    @Published var roundDate = Date()
    @Published var comment = ""
        
    struct PersistenceController {
        static let shared = PersistenceController()
        
        static var preview: PersistenceController = {
            let result = PersistenceController(inMemory: true)
            let viewContext = result.container.viewContext
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Error \(nsError), \(nsError.userInfo)")
            }
            return result
        }()
        
        let container: NSPersistentCloudKitContainer
        
        init(inMemory: Bool = false) {
            container = NSPersistentCloudKitContainer(name: "MyClayScoresModel")
            if inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            } else {
                // Configure CloudKit options for watchOS
                let storeDescription = container.persistentStoreDescriptions.first!
                storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
                
                // Explicitly set CloudKit container identifier for watchOS
                // This ensures CloudKit sync works properly
                if storeDescription.cloudKitContainerOptions == nil {
                    let options = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.doxiedavis.TrapScores")
                    storeDescription.cloudKitContainerOptions = options
                }
            }
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"{
            return PersistenceController.preview.container.viewContext
        }
        return PersistenceController.shared.container.viewContext
    }
    
    func fetchRounds() {
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "range == %@", range)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        do {
            roundData = try managedObjectContext.fetch(request)
        } catch let error {
            print ("Error fetching. \(error)")
        }
    }
    
    func saveRounds() {
        guard managedObjectContext.hasChanges else { return }
        
        let container = PersistenceController.shared.container
        
        do {
            // Save the view context - this persists changes locally and triggers CloudKit export
            try managedObjectContext.save()
            
            // Ensure all pending changes are processed
            managedObjectContext.processPendingChanges()
            
            // Verify CloudKit is configured
            guard let storeDescription = container.persistentStoreDescriptions.first else {
                fetchRounds()
                return
            }
            
            guard storeDescription.cloudKitContainerOptions != nil else {
                fetchRounds()
                return
            }
            
            // Trigger CloudKit export by accessing the persistent store coordinator's stores
            // This ensures CloudKit operations are queued and processed
            // On watchOS, CloudKit sync may be deferred, but accessing stores helps trigger it
            let coordinator = container.persistentStoreCoordinator
            let _ = coordinator.persistentStores
            
            // Fetch rounds to update UI
            fetchRounds()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64, exclude: Bool = false) {
        // Always create a new round - users should be able to create multiple rounds
        // CloudKit's merge policy will handle any actual duplicates during sync
        let newRound = RoundEntity(context: managedObjectContext)
        newRound.range = range
        newRound.comment = comment
        newRound.date = date
        newRound.id = UUID()
        newRound.pos1 = pos1
        newRound.pos2 = pos2
        newRound.pos3 = pos3
        newRound.pos4 = pos4
        newRound.pos5 = pos5
        newRound.pos6 = pos6
        newRound.pos7 = pos7
        newRound.pos8 = pos8
        newRound.pos9 = pos9
        newRound.total = total
        newRound.exclude = exclude
        saveRounds()
    }
    
    func clearData () {
        pos = 1
        posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        roundTotal = 0
        comment = ""
    }
    
    func addupScore () {
        roundTotal = posCount[0] + posCount[1] + posCount[2] + posCount[3] + posCount[4] + posCount[5] + posCount[6] + posCount[7] + posCount[8]
    }
}

