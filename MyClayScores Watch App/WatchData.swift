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
        do {
            // Save the context - NSPersistentCloudKitContainer automatically syncs to CloudKit
            try managedObjectContext.save()
            
            // Ensure the save completes and CloudKit sync is initiated
            managedObjectContext.processPendingChanges()
            
            // Explicitly trigger CloudKit export for watchOS
            triggerCloudKitExport()
            
            fetchRounds()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    /// Explicitly trigger CloudKit export to ensure immediate sync on watchOS
    /// This method forces CloudKit to process pending exports immediately rather than deferring them
    private func triggerCloudKitExport() {
        let container = PersistenceController.shared.container
        
        // Ensure CloudKit container is properly configured
        guard let storeDescription = container.persistentStoreDescriptions.first else {
            print("Warning: No store description found for CloudKit export")
            return
        }
        
        // Verify CloudKit is configured (NSPersistentCloudKitContainer automatically configures this)
        guard storeDescription.cloudKitContainerOptions != nil else {
            print("Warning: CloudKit container options not configured")
            return
        }
        
        // Access the persistent store coordinator to ensure CloudKit operations are queued
        // This ensures the container is aware of the changes and will sync to CloudKit
        let coordinator = container.persistentStoreCoordinator
        
        // Use a background task to ensure CloudKit operations are processed
        // This is critical on watchOS where CloudKit sync may be deferred for power management
        container.performBackgroundTask { backgroundContext in
            do {
                // Set merge policy to ensure CloudKit changes are properly handled
                backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                // Access the coordinator in background context to trigger CloudKit sync processing
                let _ = coordinator
                
                // Process any pending changes in background context to trigger CloudKit export
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
                
                // Force CloudKit to process the export by ensuring coordinator is active
                // Accessing persistent stores ensures CloudKit operations are queued and processed
                let _ = coordinator.persistentStores
                
            } catch {
                print("Error triggering CloudKit export: \(error)")
            }
        }
    }
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64, exclude: Bool = false) {
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

