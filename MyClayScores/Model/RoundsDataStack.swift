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
    
    @AppStorage ("storedRange") var storedRange = String("")
    
    @Published var roundsData: [RoundEntity] = []
    
    @Published var editedIndex = 0
    
    @Published var positions = 0
    @Published var scoringPos = Int()
    @Published var showScoring = false
    @Published var selectedRange = String("")
    @Published var range = String()
    @Published var comment = ""
    @Published var posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    @Published var roundTotal = 0
    @Published var roundDate = Date()
    @Published var roundID = UUID()
    @Published var selection = Int()
    @Published var path = NavigationPath()
    
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
    
    @Published var avgs: [AvgData] = []
    
    
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
    
    init() {
        //        self.selectedRange = storedRange
        //        self.fetchRounds()
        //        self.calcAvgs()
    }
    
    func fetchRounds() {
        let request = NSFetchRequest<RoundEntity>(entityName: "RoundEntity")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let predicate = NSPredicate(format: "range == %@", selectedRange)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        do {
            roundsData = try managedObjectContext.fetch(request)
        } catch let error {
            print ("Error fetching. \(error)")
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
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64 ) {
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
        saveRounds()
        calcAvgs()
    }
    
        func saveEdit(range: String, comment: String, date: Date, id: UUID, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64,total: Int64 ) {
            let editedRound = RoundEntity(context: managedObjectContext)
            editedRound.range = range
            editedRound.comment = comment
            editedRound.date = date
            editedRound.id = id
            editedRound.pos1 = pos1
            editedRound.pos2 = pos2
            editedRound.pos3 = pos3
            editedRound.pos4 = pos4
            editedRound.pos5 = pos5
            editedRound.pos6 = pos6
            editedRound.pos7 = pos7
            editedRound.pos8 = pos8
            editedRound.pos9 = pos9
            editedRound.total = total
            saveRounds()
            calcAvgs()
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
        for _ in 0...roundsData.count {
            pos1Avg = Double(roundsData.reduce(0, {$0 + $1.pos1}))/Double(roundsData.count)
            pos2Avg = Double(roundsData.reduce(0, {$0 + $1.pos2}))/Double(roundsData.count)
            pos3Avg = Double(roundsData.reduce(0, {$0 + $1.pos3}))/Double(roundsData.count)
            pos4Avg = Double(roundsData.reduce(0, {$0 + $1.pos4}))/Double(roundsData.count)
            pos5Avg = Double(roundsData.reduce(0, {$0 + $1.pos5}))/Double(roundsData.count)
            pos6Avg = Double(roundsData.reduce(0, {$0 + $1.pos6}))/Double(roundsData.count)
            pos7Avg = Double(roundsData.reduce(0, {$0 + $1.pos7}))/Double(roundsData.count)
            pos8Avg = Double(roundsData.reduce(0, {$0 + $1.pos8}))/Double(roundsData.count)
            pos9Avg = Double(roundsData.reduce(0, {$0 + $1.pos9}))/Double(roundsData.count)
            totalAvg = Double(roundsData.reduce(0, {$0 + $1.total}))/Double(roundsData.count)
        }
        
        posAvgs = [pos1Avg, pos2Avg, pos3Avg, pos4Avg, pos5Avg, pos6Avg, pos7Avg, pos8Avg, pos9Avg, totalAvg]
        
        for x in 1...positions {
            avgs.append(AvgData(id: UUID(), pos: x, avg: posAvgs[x-1], pct: posAvgs[x-1]/posMax[x-1]))
        }
        
        totalPct = posAvgs[9]/posMax[9]
        totalRnds = roundsData.count
        
//        print(avgs)
        
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
        posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        comment = ""
        roundTotal = 0
    }
    
    func addupScore () {
        roundTotal = posCount[0] + posCount[1] + posCount[2] + posCount[3] + posCount[4] + posCount[5] + posCount[6] + posCount[7] + posCount[8]
    }
    
    struct AvgData: Identifiable, Hashable {
        public var id = UUID()
        public var pos = Int()
        public var avg = Double()
        public var pct = Double()
    }
    
    //    enum NRView: Int, Hashable, View {
    //        case view1 = 5
    //        case view2 = 8
    //        case view3 = 9
    //        case view4 = 10
    //
    ////        var id: String {
    ////            self.rawValue
    ////        }
    //
    //        var body: some View {
    //            switch self {
    //            case .view1:
    //                FivePosNRView()
    //            case .view2:
    //                EightPosNRView()
    //            case .view3:
    //                NinePosNRView()
    //            case .view4:
    //                DoubleTNRView()
    //            }
    //        }
    //    }
}
