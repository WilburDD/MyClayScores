//
//  CoreDataMigration.swift
//  MyClayScores
//
//  Migration utility to import Core Data records into SwiftData
//

import Foundation
import SwiftData
import CoreData
import CloudKit

class CoreDataMigration {
    
    static func migrateFromCoreData(to modelContext: ModelContext, completion: @escaping () -> Void) {
        // Check if migration has already been done
        let defaults = UserDefaults.standard
        
        // First, check if we have valid data - if all rounds are empty, re-migrate
        let checkDescriptor = FetchDescriptor<Round>()
        if let existingRounds = try? modelContext.fetch(checkDescriptor) {
            let validRounds = existingRounds.filter { $0.range != nil && $0.date != nil && $0.total > 0 }
            if validRounds.count > 0 {
                print("Migration already completed with \(validRounds.count) valid rounds")
                completion()
                return
            } else if existingRounds.count > 0 {
                print("Found \(existingRounds.count) rounds but all appear empty - will re-migrate")
                // Delete empty rounds and reset migration flag
                for round in existingRounds {
                    modelContext.delete(round)
                }
                try? modelContext.save()
                defaults.removeObject(forKey: "hasMigratedFromCoreData")
            }
        }
        
        if defaults.bool(forKey: "hasMigratedFromCoreData") {
            print("Migration flag set but no valid data found - re-migrating")
            defaults.removeObject(forKey: "hasMigratedFromCoreData")
        }
        
        var localMigrationDone = false
        var cloudKitMigrationDone = false
        
        let checkCompletion = {
            if localMigrationDone && cloudKitMigrationDone {
                defaults.set(true, forKey: "hasMigratedFromCoreData")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
        
        // Try to migrate from local Core Data store first
        migrateFromLocalCoreData(to: modelContext) {
            localMigrationDone = true
            checkCompletion()
        }
        
        // Then try to migrate from CloudKit
        migrateFromCloudKit(to: modelContext) {
            cloudKitMigrationDone = true
            checkCompletion()
        }
    }
    
    private static func migrateFromLocalCoreData(to modelContext: ModelContext, completion: @escaping () -> Void) {
        // Note: Can't use NSPersistentCloudKitContainer because the .xcdatamodeld was deleted
        // CloudKit migration is handled separately via direct CloudKit API
        // Try local SQLite store instead
        migrateFromLocalOnlyStore(to: modelContext, completion: completion)
    }
    
    private static func migrateFromLocalOnlyStore(to modelContext: ModelContext, completion: @escaping () -> Void) {
        // Try to load the old Core Data store from local SQLite
        guard let coreDataURL = getCoreDataStoreURL() else {
            print("Could not find local Core Data store")
            completion()
            return
        }
        
        let container = NSPersistentContainer(name: "MyClayScoresModel")
        let storeDescription = NSPersistentStoreDescription(url: coreDataURL)
        storeDescription.setOption(true as NSNumber, forKey: NSReadOnlyPersistentStoreOption)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data store: \(error)")
                completion()
                return
            }
            
            let context = container.viewContext
            context.perform {
                self.migrateFromContext(context, to: modelContext, source: "Local Store") {
                    completion()
                }
            }
        }
    }
    
    private static func migrateFromContext(_ sourceContext: NSManagedObjectContext, to modelContext: ModelContext, source: String, completion: @escaping () -> Void) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "RoundEntity")
        
        do {
            let results = try sourceContext.fetch(request)
            print("Found \(results.count) records to migrate from \(source)")
            
            if results.count == 0 {
                completion()
                return
            }
            
            var migratedCount = 0
            for (index, oldRecord) in results.enumerated() {
                // Log all available keys for first record
                if index == 0 {
                    print("Sample record keys: \(oldRecord.entity.attributesByName.keys.sorted())")
                }
                
                let rangeValue = oldRecord.value(forKey: "range") as? String
                let dateValue = oldRecord.value(forKey: "date") as? Date
                let totalValue = oldRecord.value(forKey: "total") as? Int64 ?? 0
                
                if index < 3 {
                    print("Migrating record \(index + 1): range='\(rangeValue ?? "nil")', date=\(dateValue?.description ?? "nil"), total=\(totalValue)")
                }
                
                let round = Round(
                    comment: oldRecord.value(forKey: "comment") as? String,
                    date: dateValue,
                    exclude: (oldRecord.value(forKey: "exclude") as? Bool) ?? false,
                    pos1: (oldRecord.value(forKey: "pos1") as? Int64) ?? 0,
                    pos2: (oldRecord.value(forKey: "pos2") as? Int64) ?? 0,
                    pos3: (oldRecord.value(forKey: "pos3") as? Int64) ?? 0,
                    pos4: (oldRecord.value(forKey: "pos4") as? Int64) ?? 0,
                    pos5: (oldRecord.value(forKey: "pos5") as? Int64) ?? 0,
                    pos6: (oldRecord.value(forKey: "pos6") as? Int64) ?? 0,
                    pos7: (oldRecord.value(forKey: "pos7") as? Int64) ?? 0,
                    pos8: (oldRecord.value(forKey: "pos8") as? Int64) ?? 0,
                    pos9: (oldRecord.value(forKey: "pos9") as? Int64) ?? 0,
                    range: rangeValue,
                    total: totalValue
                )
                
                // Ensure range is set (it should be from the initializer, but verify)
                if round.range == nil || round.range?.isEmpty == true {
                    print("WARNING: Round \(index + 1) has nil/empty range after creation")
                }
                
                // Copy additional fields if they exist
                if let id = oldRecord.value(forKey: "id") as? UUID {
                    round.id = id
                }
                round.doubles = (oldRecord.value(forKey: "doubles") as? Int64) ?? 0
                round.firsts = (oldRecord.value(forKey: "firsts") as? Int64) ?? 0
                round.highs = (oldRecord.value(forKey: "highs") as? Int64) ?? 0
                round.lows = (oldRecord.value(forKey: "lows") as? Int64) ?? 0
                round.seconds = (oldRecord.value(forKey: "seconds") as? Int64) ?? 0
                round.singles = (oldRecord.value(forKey: "singles") as? Int64) ?? 0
                
                modelContext.insert(round)
                migratedCount += 1
            }
            
            try modelContext.save()
            print("Successfully migrated \(migratedCount) records from \(source)")
            completion()
        } catch {
            print("Error migrating from \(source): \(error)")
            completion()
        }
    }
    
    private static func migrateFromCloudKit(to modelContext: ModelContext, completion: @escaping () -> Void) {
        let container = CKContainer(identifier: "iCloud.com.doxiedavis.TrapScores")
        let database = container.privateCloudDatabase
        
        // Query for RoundEntity records from Core Data
        let predicate = NSPredicate(value: true) // Get all records
        let query = CKQuery(recordType: "CD_RoundEntity", predicate: predicate)
        
        print("Querying CloudKit for CD_RoundEntity records...")
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 500) { result in
            switch result {
            case .success(let response):
                let records = response.matchResults.compactMap { try? $0.1.get() }
                print("Found \(records.count) CloudKit records to migrate")
                
                if records.count == 0 {
                    print("No CloudKit records found")
                    completion()
                    return
                }
                
                // Log first record's keys for debugging
                if let firstRecord = records.first {
                    print("Sample CloudKit record keys: \(firstRecord.allKeys().sorted())")
                    print("Sample values - CD_range: \(firstRecord["CD_range"] ?? "nil"), CD_date: \(firstRecord["CD_date"] ?? "nil"), CD_total: \(firstRecord["CD_total"] ?? "nil")")
                }
                
                var migratedCount = 0
                var errors = 0
                var seenUUIDs = Set<UUID>() // Track UUIDs to prevent duplicates
                
                for (index, record) in records.enumerated() {
                    // Extract values - Core Data + CloudKit stores fields with "CD_" prefix
                    let rangeValue = record["CD_range"] as? String
                    let dateValue = record["CD_date"] as? Date
                    let totalValue: Int64 = {
                        if let num = record["CD_total"] as? Int64 {
                            return num
                        } else if let num = record["CD_total"] as? NSNumber {
                            return num.int64Value
                        } else {
                            return 0
                        }
                    }()
                    
                    if index < 3 {
                        print("Migrating CloudKit record \(index + 1): range='\(rangeValue ?? "nil")', date=\(dateValue?.description ?? "nil"), total=\(totalValue)")
                    }
                    
                    // Helper to extract Int64 from CloudKit record with CD_ prefix
                    let extractInt64: (String) -> Int64 = { key in
                        let prefixedKey = "CD_\(key)"
                        if let num = record[prefixedKey] as? Int64 {
                            return num
                        } else if let num = record[prefixedKey] as? NSNumber {
                            return num.int64Value
                        } else {
                            return 0
                        }
                    }
                    
                    let round = Round(
                        comment: record["CD_comment"] as? String,
                        date: dateValue,
                        exclude: (record["CD_exclude"] as? Bool) ?? false,
                        pos1: extractInt64("pos1"),
                        pos2: extractInt64("pos2"),
                        pos3: extractInt64("pos3"),
                        pos4: extractInt64("pos4"),
                        pos5: extractInt64("pos5"),
                        pos6: extractInt64("pos6"),
                        pos7: extractInt64("pos7"),
                        pos8: extractInt64("pos8"),
                        pos9: extractInt64("pos9"),
                        range: rangeValue,
                        total: totalValue
                    )
                    
                    // Copy ID if available (CD_id)
                    if let idString = record["CD_id"] as? String, let id = UUID(uuidString: idString) {
                        round.id = id
                    } else if let idValue = record["CD_id"] {
                        // Try converting any ID value to string then UUID
                        let idString = String(describing: idValue)
                        if let id = UUID(uuidString: idString) {
                            round.id = id
                        }
                    }
                    
                    // If still no ID, try using recordName as UUID
                    if round.id == nil {
                        if let recordNameUUID = UUID(uuidString: record.recordID.recordName) {
                            round.id = recordNameUUID
                        }
                    }
                    
                    // Ensure we have a unique ID - if UUID already seen or still nil, generate new one
                    if let existingID = round.id {
                        if seenUUIDs.contains(existingID) {
                            print("Duplicate UUID detected: \(existingID), generating new UUID")
                            round.id = UUID()
                        } else {
                            seenUUIDs.insert(existingID)
                        }
                    } else {
                        round.id = UUID()
                        seenUUIDs.insert(round.id!)
                    }
                    
                    // Copy additional fields
                    round.doubles = extractInt64("doubles")
                    round.firsts = extractInt64("firsts")
                    round.highs = extractInt64("highs")
                    round.lows = extractInt64("lows")
                    round.seconds = extractInt64("seconds")
                    round.singles = extractInt64("singles")
                    
                    DispatchQueue.main.async {
                        modelContext.insert(round)
                        do {
                            try modelContext.save()
                            migratedCount += 1
                            if migratedCount % 10 == 0 {
                                print("Migrated \(migratedCount) of \(records.count) CloudKit records")
                            }
                        } catch {
                            errors += 1
                            print("Error saving migrated CloudKit record \(index + 1): \(error)")
                        }
                    }
                }
                
                // Wait a bit for all saves to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("Successfully migrated \(migratedCount) records from CloudKit (errors: \(errors), unique UUIDs: \(seenUUIDs.count))")
                    completion()
                }
            case .failure(let error):
                print("Error querying CloudKit: \(error)")
                // If no records found or error, that's okay - might not have CloudKit data
                completion()
            }
        }
    }
    
    private static func getCoreDataStoreURL() -> URL? {
        // Try to find the Core Data SQLite store
        let fileManager = FileManager.default
        
        // Check application support directory
        if let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let storeURL = appSupport.appendingPathComponent("MyClayScoresModel.sqlite")
            if fileManager.fileExists(atPath: storeURL.path) {
                return storeURL
            }
        }
        
        // Check Library/Application Support
        if let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let appSupportURL = libraryURL.appendingPathComponent("Application Support")
            let storeURL = appSupportURL.appendingPathComponent("MyClayScoresModel.sqlite")
            if fileManager.fileExists(atPath: storeURL.path) {
                return storeURL
            }
        }
        
        return nil
    }
}

