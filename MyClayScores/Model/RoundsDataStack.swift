//
//  Persistence.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftData
import SwiftUI
import CloudKit
import Charts

class RoundsDataStack: ObservableObject, Identifiable {
    
    @AppStorage("storedRange") var storedRange = String("No Range Selected")
    @AppStorage("scoringSet") var scoringSet = 0

    @Published var roundsData: [Round] = []
    
    var modelContext: ModelContext?
    
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
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func fetchRounds() {
        guard let modelContext = modelContext else { return }
        
        // First, check if there's any data at all (for debugging)
        let allRoundsDescriptor = FetchDescriptor<Round>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        do {
            let allRounds = try modelContext.fetch(allRoundsDescriptor)
            
            // Fix duplicate UUIDs if any exist
            var seenUUIDs = Set<UUID>()
            var duplicateCount = 0
            for round in allRounds {
                if let id = round.id {
                    if seenUUIDs.contains(id) {
                        // Duplicate UUID found - assign new UUID
                        round.id = UUID()
                        duplicateCount += 1
                    }
                    seenUUIDs.insert(id)
                } else {
                    // Missing UUID - assign new one
                    round.id = UUID()
                    duplicateCount += 1
                }
            }
            
            if duplicateCount > 0 {
                try modelContext.save()
                print("Fixed \(duplicateCount) rounds with duplicate or missing UUIDs")
            }
            
            print("Total rounds in database: \(allRounds.count)")
            if allRounds.count > 0 {
                let nonNilRanges = allRounds.compactMap { $0.range }.filter { !$0.isEmpty }
                let uniqueRanges = Set(nonNilRanges)
                print("Unique ranges found (\(uniqueRanges.count)): \(Array(uniqueRanges).sorted())")
                let nilCount = allRounds.filter { $0.range == nil || $0.range?.isEmpty == true }.count
                if nilCount > 0 {
                    print("WARNING: \(nilCount) rounds have nil or empty range")
                }
                // Show first few rounds as sample
                let sampleRounds = Array(allRounds.prefix(5))
                for (index, round) in sampleRounds.enumerated() {
                    let rangeStr = round.range ?? "nil"
                    let dateStr = round.date?.formatted(date: .abbreviated, time: .shortened) ?? "nil"
                    print("Sample round \(index + 1): range='\(rangeStr)', date=\(dateStr), total=\(round.total)")
                }
            }
        } catch {
            print("Error fetching all rounds: \(error)")
        }
        
        // Now fetch filtered by selected range
        // Handle both exact match and potential nil/empty cases
        let descriptor: FetchDescriptor<Round>
        if selectedRange.isEmpty || selectedRange == "No Range Selected" {
            // If no range selected, show all rounds
            descriptor = FetchDescriptor<Round>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            print("Fetching all rounds (no range selected)")
        } else {
            // Use optional chaining in predicate - SwiftData handles nil comparison
            let rangeToMatch = selectedRange
            descriptor = FetchDescriptor<Round>(
                predicate: #Predicate<Round> { round in
                    round.range == rangeToMatch
                },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            print("Fetching rounds for range: '\(selectedRange)'")
        }
        
        do {
            roundsData = try modelContext.fetch(descriptor)
            print("Fetched \(roundsData.count) rounds for range: '\(selectedRange)'")
            if roundsData.count == 0 && !selectedRange.isEmpty && selectedRange != "No Range Selected" {
                self.noRounds = true
                // Try to find what ranges actually exist
                let allRounds = try modelContext.fetch(FetchDescriptor<Round>())
                let availableRanges = Set(allRounds.compactMap { $0.range }.filter { !$0.isEmpty })
                print("Available ranges in database: \(availableRanges.sorted())")
            } else {
                self.noRounds = false
            }
        } catch let error {
            print ("Error fetching. \(error)")
        }
    }
    
    func fetchGraphs() {
        guard let modelContext = modelContext else { return }
        
        graphData.removeAll()
        
        let descriptor = FetchDescriptor<Round>(
            predicate: #Predicate<Round> { round in
                round.range == selectedRange
            },
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        
        do {
            roundsData = try modelContext.fetch(descriptor)
        } catch let error {
            print ("Error fetching. \(error)")
        }
        
        for x in 0..<roundsData.count {
            let seq = String(x)
            let date = roundsData[x].date?.formatted(date: .numeric, time: .standard) ?? "Date error"
            let score = Int(roundsData[x].total)
            let comment = roundsData[x].comment ?? "no comment"
            graphData.append(GraphData(seq: seq, date: date, score: score, comment: comment))
        }
    }
    
    func saveRounds() {
        guard let modelContext = modelContext else { return }
        do {
            try modelContext.save()
            fetchRounds()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64, exclude: Bool ) {
        guard let modelContext = modelContext else { return }
        
        let newRound = Round(
            comment: comment,
            date: date,
            exclude: exclude,
            pos1: pos1,
            pos2: pos2,
            pos3: pos3,
            pos4: pos4,
            pos5: pos5,
            pos6: pos6,
            pos7: pos7,
            pos8: pos8,
            pos9: pos9,
            range: range,
            total: total
        )
        modelContext.insert(newRound)
        saveRounds()
        calcAvgs()
    }
    
    func saveEdit(range: String, comment: String, date: Date, id: UUID, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64,total: Int64, exclude: Bool ) {
        guard let modelContext = modelContext else { return }
        
        // Find the existing round by id
        let descriptor = FetchDescriptor<Round>(
            predicate: #Predicate<Round> { round in
                round.id == id
            }
        )
        
        do {
            if let existingRound = try modelContext.fetch(descriptor).first {
                // Update existing round
                existingRound.range = range
                existingRound.comment = comment
                existingRound.date = date
                existingRound.pos1 = pos1
                existingRound.pos2 = pos2
                existingRound.pos3 = pos3
                existingRound.pos4 = pos4
                existingRound.pos5 = pos5
                existingRound.pos6 = pos6
                existingRound.pos7 = pos7
                existingRound.pos8 = pos8
                existingRound.pos9 = pos9
                existingRound.total = total
                existingRound.exclude = exclude
            }
        } catch {
            print("Error finding round to edit: \(error)")
        }
        
        saveRounds()
        calcAvgs()
    }
    
    func deleteRound(indexSet: IndexSet) {
        guard let index = indexSet.first, let modelContext = modelContext else { return }
        let entity = roundsData[index]
        modelContext.delete(entity)
        saveRounds()
        calcAvgs()
    }
    
    func deleteEditedRound(index: Int) {
        guard let modelContext = modelContext else { return }
        let entity = roundsData[index]
        modelContext.delete(entity)
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
}

