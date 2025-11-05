//
//  Persistence.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import Foundation
import SwiftUI
import SwiftData
import WatchKit
import ClockKit
import CloudKit

class WatchData: ObservableObject, Identifiable {
        
    @Published var roundData: [Round] = []
    
    var modelContext: ModelContext?

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
        
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func fetchRounds() {
        guard let modelContext = modelContext else { return }
        
        let descriptor = FetchDescriptor<Round>(
            predicate: #Predicate<Round> { round in
                round.range == range
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            roundData = try modelContext.fetch(descriptor)
        } catch let error {
            print ("Error fetching. \(error)")
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
    
    func addRound(range: String, comment: String, date: Date, pos1: Int64, pos2: Int64, pos3: Int64, pos4: Int64, pos5: Int64, pos6: Int64, pos7: Int64, pos8: Int64, pos9: Int64, total: Int64 ) {
        guard let modelContext = modelContext else { return }
        
        let newRound = Round(
            comment: comment,
            date: date,
            exclude: false,
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

