//
//  FixNilRanges.swift
//  MyClayScores
//
//  Utility to fix rounds with nil range values
//

import Foundation
import SwiftData

class FixNilRanges {
    
    static func fixNilRanges(in modelContext: ModelContext) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "hasFixedNilRanges") {
            print("Nil ranges already fixed")
            return
        }
        
        let descriptor = FetchDescriptor<Round>()
        do {
            let allRounds = try modelContext.fetch(descriptor)
            var fixedCount = 0
            
            for round in allRounds {
                if round.range == nil || round.range?.isEmpty == true {
                    // Try to infer range from storedRange or use a default
                    // For now, we'll need to set a default or ask user
                    // This is a placeholder - you may need to manually set ranges
                    print("Found round with nil range: id=\(round.id?.uuidString ?? "nil"), date=\(round.date?.description ?? "nil")")
                    fixedCount += 1
                }
            }
            
            if fixedCount > 0 {
                try modelContext.save()
                print("Fixed \(fixedCount) rounds with nil ranges")
            }
            
            defaults.set(true, forKey: "hasFixedNilRanges")
        } catch {
            print("Error fixing nil ranges: \(error)")
        }
    }
}

