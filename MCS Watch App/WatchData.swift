//
//  Persistence.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//


import SwiftUI
import WatchKit

class WatchData: ObservableObject, Identifiable {

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
    @Published var path = NavigationPath()
//    @Published var posMax = [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 25.0]
    
    func clearData () {
        pos = 1
        posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        roundTotal = 0
    }
    
    func addupScore () {
        roundTotal = posCount[0] + posCount[1] + posCount[2] + posCount[3] + posCount[4] + posCount[5] + posCount[6] + posCount[7] + posCount[8]
    }
}

