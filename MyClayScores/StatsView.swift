//
//  ScoringInfoView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import Charts

struct StatsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
        
    var body: some View {
            VStack {
                HStack {
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
                Text("Position")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Chart (roundsData.avgs) {
                    let avgString = String(format: "%.1f", $0.avg)
                    let avgPct = String(format: "%.0f", $0.pct * 100)
                    let chartPos = String($0.pos)
                    BarMark(
                        x: .value("Avg", $0.avg),
                        y: .value("Pos", chartPos)
                    )
                    .annotation(position: .leading) {
                        Text(chartPos)
                    }
                    .annotation(position: .trailing) {
                        Text(avgString + "\n" + avgPct + "%")
                    }
                }
                .cornerRadius(10)
                .chartXScale(domain: 0...roundsData.posMax[0]+3)
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks (position: .leading)
                }
                .font(.title3)
                .fontWeight(.bold)
            }
        Spacer()
        VStack {
            Text("Rounds:   \(roundsData.totalRnds)")
            HStack{
                Spacer()
                Text("Avg. Score:  " + String(format: "%.1f", roundsData.totalAvg))
                Text(" =  " + String(format: "%.0f", roundsData.totalPct * 100) + " %")
                Spacer()
            }
        }
        .font(.title2)
        .fontWeight(.bold)
        Spacer()
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(RoundsDataStack())
    }
}

