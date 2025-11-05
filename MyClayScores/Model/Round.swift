//
//  Round.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import Foundation
import SwiftData

@Model
final class Round {
    var comment: String?
    var date: Date?
    var doubles: Int64 = 0
    var exclude: Bool = false
    var firsts: Int64 = 0
    var highs: Int64 = 0
    var id: UUID?
    var lows: Int64 = 0
    var pos1: Int64 = 0
    var pos2: Int64 = 0
    var pos3: Int64 = 0
    var pos4: Int64 = 0
    var pos5: Int64 = 0
    var pos6: Int64 = 0
    var pos7: Int64 = 0
    var pos8: Int64 = 0
    var pos9: Int64 = 0
    var range: String?
    var seconds: Int64 = 0
    var singles: Int64 = 0
    var total: Int64 = 0
    
    init() {
        self.id = UUID()
    }
    
    init(
        comment: String?,
        date: Date?,
        exclude: Bool,
        pos1: Int64,
        pos2: Int64,
        pos3: Int64,
        pos4: Int64,
        pos5: Int64,
        pos6: Int64,
        pos7: Int64,
        pos8: Int64,
        pos9: Int64,
        range: String?,
        total: Int64
    ) {
        self.comment = comment
        self.date = date
        self.exclude = exclude
        self.id = UUID()
        self.pos1 = pos1
        self.pos2 = pos2
        self.pos3 = pos3
        self.pos4 = pos4
        self.pos5 = pos5
        self.pos6 = pos6
        self.pos7 = pos7
        self.pos8 = pos8
        self.pos9 = pos9
        self.range = range
        self.total = total
    }
}

