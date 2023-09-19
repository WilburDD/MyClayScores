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
            VStack {
                HStack {
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                RoundedRectangle(cornerRadius: 1)
                    .frame(height: 2)
                Text("Position Averages")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Chart {
                    ForEach (roundsData.avgs) {
                        let avgString = String(format: "%.1f", $0.avg)
                        let avgPct = String(format: "%.0f", $0.pct * 100)
                        let chartPos = String($0.pos)
                        let annote = avgString + " = " + avgPct + "%"
                        BarMark(
                            x: .value("", $0.avg),
                            y: .value("", chartPos)
                        )
                        .annotation (position: .overlay) {
                            Text("\(annote)")
                                .font(.headline)
                        }
                    }
                }
                .chartXScale(domain: 0...roundsData.posMax[0])
//                .chartXAxis(.hidden)
//                .chartYAxis {
//                    AxisMarks (position: .leading)
//                }
//                .font(.title)
//                .fontWeight(.bold)
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
                AvgChart()
                    .environmentObject(roundsData)
            }
            .onAppear {
                roundsData.clearData()
                roundsData.fetchGraphs()
                roundsData.calcAvgs()
            }
            .onDisappear{
                roundsData.clearData()
                roundsData.fetchRounds()
            }
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(RoundsDataStack())
    }
}

