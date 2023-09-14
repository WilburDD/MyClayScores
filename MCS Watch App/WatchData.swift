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

class WatchData: ObservableObject, Identifiable {
    
    @Published var connectivityManager = WatchConnectivityManager.shared

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
    
    func clearData () {
        pos = 1
        posCount = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        roundTotal = 0
    }
    
    func addupScore () {
        roundTotal = posCount[0] + posCount[1] + posCount[2] + posCount[3] + posCount[4] + posCount[5] + posCount[6] + posCount[7] + posCount[8]
    }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // TODO: Finish implementing this required method.
    }
}

