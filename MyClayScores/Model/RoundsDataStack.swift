//
//  Persistence.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import CoreData
import SwiftUI
import CloudKit
import Charts

class RoundsDataStack: ObservableObject, Identifiable {
    
    @AppStorage("storedRange") var storedRange = String("No Range Selected")
    @AppStorage("scoringSet") var scoringSet = 0

    @Published var roundsData: [RoundEntity] = []
    
    @Published var editedIndex = 0
    
    @Published var positions = 0
    @Published var scoringPos = Int()
    @Published var showScoring = false
    @Published var selectedRange = "No Range Selected"
    @Published var selectedScoring: [[Double]] = [
        [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0],
        [10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0],
        [4.0, 4.0, 2.0, 2.0, 2.0, 4.0, 4.0, 3.0, 1.0],
        [3.0, 3.0, 3.0, 2.0, 3.0, 3.0, 2.0, 4.0, 2.0]
    ]
    @Published var range = String()
    @Published var comment = ""
    @Published var posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var roundTotal = 0
    @Published var roundDate = Date()
    @Published var roundID = UUID()
    @Published var selection = Int()
    @Published var path = NavigationPath()
    @Published var noRounds = false
    @Published var exclude = false
    
    @Published var pos1Avg = Double (0.0)
    @Published var pos2Avg = Double (0.0)
    @Published var pos3Avg = Double (0.0)
    @Published var pos4Avg = Double (0.0)
    @Published var pos5Avg = Double (0.0)
    @Published var pos6Avg = Double (0.0)
    @Published var pos7Avg = Double (0.0)
    @Published var pos8Avg = Double (0.0)
    @Published var pos9Avg = Double (0.0)
    @Published var totalAvg = Double (0.0)
    @Published var totalRnds = 0
    
    @Published var pos1Pct = Double (0.0)
    @Published var pos2Pct = Double (0.0)
    @Published var pos3Pct = Double (0.0)
    @Published var pos4Pct = Double (0.0)
    @Published var pos5Pct = Double (0.0)
    @Published var pos6Pct = Double (0.0)
    @Published var pos7Pct = Double (0.0)
    @Published var pos8Pct = Double (0.0)
    @Published var pos9Pct = Double (0.0)
    @Published var totalPct = Double (0.0)
    
    @Published var posMax = [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 25.0]
    @Published var posAvgs = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @Published var posPcts = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @Published var graphMax = Double (25.0)
    @Published var minTotal = Int()
    @Published var avgs: [AvgData] = []
    @Published var graphData: [GraphData] = []
    
    struct AvgData: Identifiable, Hashable {
        public var id = UUID()
        public var pos = Int()
        public var avg = Double()
        public var pct = Double()
    }
    struct GraphData: Hashable {
        public var seq = ""
        public var date = ""
        public var score = Int()
        public var comment = String()
    }
    
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
        
        let container: NSPersistentContainer
        
        init(inMemory: Bool = false) {
            container = NSPersistentCloudKitContainer(name: "MyClayScoresModel")
            if inMemory {
                container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            }
            // Capture a local reference to avoid capturing the mutating `self` in the escaping closure
            let localContainer = container
            localContainer.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                // Kick off a one-time background normalization for legacy data without capturing `self`
                PersistenceController.normalizeExcludesInBackground(using: localContainer)
            }
            localContainer.viewContext.automaticallyMergesChangesFromParent = true
            localContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        
        private static let normalizationFlagKey = "didNormalizeExcludeOnce"

        private static func normalizeExcludesInBackground(using container: NSPersistentContainer) {
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: normalizationFlagKey) {
                return
            }
            container.performBackgroundTask { context in
                let fetch = NSFetchRequest<NSManagedObject>(entityName: "RoundEntity")
                do {
                    let results = try context.fetch(fetch)
                    var didChange = false
                    for obj in results {
                        if let value = obj.value(forKey: "exclude") as? Bool {
                            if value == false {
                                obj.setValue(false, forKey: "exclude")
                                didChange = true
                            }
                        } else {
                            obj.setValue(false, forKey: "exclude")
                            didChange = true
                        }
                    }
                    if didChange && context.hasChanges {
                        try context.save()
                    }
                    // Mark as done regardless of whether changes were needed
                    defaults.set(true, forKey: normalizationFlagKey)
                } catch {
                    print("Background normalization failed: \(error)")
                    // Even on failure, do not set the flag so it can retry next launch
                }
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"{
            return PersistenceController.preview.container.viewContext
        }
        return PersistenceController.shared.container.viewContext
    }
    
    // Normalize any legacy or nil excludes in fetched entities and persist the fix
    private func normalizeRoundExcludes() {
        var didChange = false
        for entity in roundsData {
            // Default to false unless explicitly true
            if entity.exclude != true {
                let previous = entity.exclude
                entity.exclude = false
                if previous != entity.exclude { didChange = true }
            }
        }
        if didChange {
            do {
                try managedObjectContext.save()
            } catch {
                print("Error normalizing excludes: \(error)")
            }
        }
    }
    
    func fetchRounds() {
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "range == %@", selectedRange)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        do {
            roundsData = try managedObjectContext.fetch(request)
            normalizeRoundExcludes()
            if roundsData.count == 0 {
                self.noRounds = true
            } else {
                self.noRounds = false
            }
        } catch let error {
            print ("Error fetching. \(error)")
        }
    }
    
    func fetchGraphs() {
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let predicate = NSPredicate(format: "range == %@", selectedRange)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        do {
            roundsData = try managedObjectContext.fetch(request)
            normalizeRoundExcludes()
        } catch let error {
            print ("Error fetching. \(error)")
        }
        for x in 0...roundsData.count - 1 {
            let seq = String(x)
            let date = roundsData[x].date?.formatted(date: .numeric, time: .standard) ?? "Date error"
            let score = Int(roundsData[x].total)
            let comment = roundsData[x].comment ?? "no comment"
            graphData.append(GraphData(seq: seq, date: date, score: score, comment: comment))
        }
    }
    
    func saveRounds() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
            fetchRounds()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64, exclude: Bool ) {
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
        calcAvgs()
    }
    
    func saveEdit(range: String, comment: String, date: Date, id: UUID, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64,total: Int64, exclude: Bool ) {
        // Update existing round instead of creating a duplicate
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            if let existing = try managedObjectContext.fetch(request).first {
                existing.range = range
                existing.comment = comment
                existing.date = date
                existing.id = id
                existing.pos1 = pos1
                existing.pos2 = pos2
                existing.pos3 = pos3
                existing.pos4 = pos4
                existing.pos5 = pos5
                existing.pos6 = pos6
                existing.pos7 = pos7
                existing.pos8 = pos8
                existing.pos9 = pos9
                existing.total = total
                existing.exclude = exclude
            } else {
                // Fallback: if not found, create it once (legacy data without id)
                let newRound = RoundEntity(context: managedObjectContext)
                newRound.range = range
                newRound.comment = comment
                newRound.date = date
                newRound.id = id
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
            }
            saveRounds()
            calcAvgs()
        } catch {
            print("Error saving edit: \(error)")
        }
    }
    
    func deleteRound(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = roundsData[index]
        managedObjectContext.delete(entity)
        saveRounds()
        calcAvgs()
    }
    
    func deleteEditedRound(index: Int) {
        let entity = roundsData[index]
        managedObjectContext.delete(entity)
        saveRounds()
        calcAvgs()
    }
    
    func calcAvgs () {
        // Only include rounds not excluded
        let included = roundsData.filter { ($0.exclude) == false }
        let count = included.count
        
        // Reset collections used in charts/avgs
        avgs.removeAll()
        
        guard count > 0 else {
            pos1Avg = 0
            pos2Avg = 0
            pos3Avg = 0
            pos4Avg = 0
            pos5Avg = 0
            pos6Avg = 0
            pos7Avg = 0
            pos8Avg = 0
            pos9Avg = 0
            totalAvg = 0
            posAvgs = [pos1Avg, pos2Avg, pos3Avg, pos4Avg, pos5Avg, pos6Avg, pos7Avg, pos8Avg, pos9Avg, totalAvg]
            for x in 1...positions {
                avgs.append(AvgData(id: UUID(), pos: x, avg: posAvgs[x-1], pct: posMax[x-1] == 0 ? 0 : posAvgs[x-1]/posMax[x-1]))
            }
            totalPct = posMax[9] == 0 ? 0 : posAvgs[9]/posMax[9]
            totalRnds = roundsData.count
            graphMax = posMax[9] + 1
            let allTotals = included.compactMap({ $0.total })
            minTotal = Int(Int64(allTotals.min() ?? 0))
            return
        }
        
        pos1Avg = Double(included.reduce(0, {$0 + $1.pos1}))/Double(count)
        pos2Avg = Double(included.reduce(0, {$0 + $1.pos2}))/Double(count)
        pos3Avg = Double(included.reduce(0, {$0 + $1.pos3}))/Double(count)
        pos4Avg = Double(included.reduce(0, {$0 + $1.pos4}))/Double(count)
        pos5Avg = Double(included.reduce(0, {$0 + $1.pos5}))/Double(count)
        pos6Avg = Double(included.reduce(0, {$0 + $1.pos6}))/Double(count)
        pos7Avg = Double(included.reduce(0, {$0 + $1.pos7}))/Double(count)
        pos8Avg = Double(included.reduce(0, {$0 + $1.pos8}))/Double(count)
        pos9Avg = Double(included.reduce(0, {$0 + $1.pos9}))/Double(count)
        totalAvg = Double(included.reduce(0, {$0 + $1.total}))/Double(count)
        
        posAvgs = [pos1Avg, pos2Avg, pos3Avg, pos4Avg, pos5Avg, pos6Avg, pos7Avg, pos8Avg, pos9Avg, totalAvg]
        
        for x in 1...positions {
            avgs.append(AvgData(id: UUID(), pos: x, avg: posAvgs[x-1], pct: posMax[x-1] == 0 ? 0 : posAvgs[x-1]/posMax[x-1]))
        }
        
        totalPct = posMax[9] == 0 ? 0 : posAvgs[9]/posMax[9]
        totalRnds = roundsData.count
        graphMax = posMax[9] + 1
        let allTotals = included.compactMap({ $0.total })
        minTotal = Int(Int64(allTotals.min() ?? 0))
        let minRounded = minTotal / 5
        let minRoundedInt = floor(Double(minRounded))
        minTotal = Int(minRoundedInt * 5)
        
        if totalRnds == 0 {
            pos1Avg = 0
            pos2Avg = 0
            pos3Avg = 0
            pos4Avg = 0
            pos5Avg = 0
            pos6Avg = 0
            pos7Avg = 0
            pos8Avg = 0
            pos9Avg = 0
            totalAvg = 0
        }
    }
    
    func clearData () {
        avgs.removeAll()
        graphData.removeAll()
        posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        comment = ""
        roundTotal = 0
        exclude = false
    }
    
    func addupScore () {
        roundTotal = posCount[0] + posCount[1] + posCount[2] + posCount[3] + posCount[4] + posCount[5] + posCount[6] + posCount[7] + posCount[8]
    }
    
    // Pull-to-refresh helper to clear local/transient state and refetch from CloudKit/Core Data
    @MainActor
    func refreshFromCloud() async {
        // Clear transient UI/model caches
        avgs.removeAll()
        graphData.removeAll()
        // Reset context to drop any cached faults; CloudKit merges will re-populate
        managedObjectContext.reset()
        // Re-fetch and rebuild derived data
        fetchRounds()
//        fetchGraphs()
        calcAvgs()
    }
}
