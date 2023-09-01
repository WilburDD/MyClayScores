//
//  ScoringInfoView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import Charts

//struct StepCount: Identifiable {
//    let id = UUID()
//    let weekday: Date
//    let steps: Int
//
//    init(day: String, steps: Int) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd"
//
//        self.weekday = formatter.date(from: day) ?? Date.distantPast
//        self.steps = steps
//    }
//
//    var weekdayString: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .none
//        dateFormatter.locale = Locale(identifier: "en_US")
//        return  dateFormatter.string(from: weekday)
//    }
//}
//
//
//struct StatsView: View {
//    let currentWeek: [StepCount] = [
//        StepCount(day: "20220717", steps: 4200),
//        StepCount(day: "20220718", steps: 15000),
//        StepCount(day: "20220719", steps: 2800),
//        StepCount(day: "20220720", steps: 10800),
//        StepCount(day: "20220721", steps: 5300),
//        StepCount(day: "20220722", steps: 10400),
//        StepCount(day: "20220723", steps: 4000)
//    ]
//
//    var body: some View {
//        VStack {
//            GroupBox ( "Bar Chart - Step Count") {
//                Chart(currentWeek) {
//                    let steps = $0.steps
//                    BarMark(
//                        x: .value("Step Count", $0.steps),
//                        y: .value("Week Day", $0.weekday, unit: .day)
//                    )
//                    .foregroundStyle(Color.orange)
//                    .annotation(position: .overlay, alignment: .trailing, spacing: 5) {
//                        Text("\(steps)")
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                    }
//                }
//                .chartXAxis(.hidden)
//                .chartYAxis {
//                    AxisMarks (position: .leading, values: .stride (by: .day)) { value in
//                        AxisValueLabel(format: .dateTime.weekday(),
//                                       centered: true)
//                    }
//                }
//            }
//            .frame(height: 500)
//
//            Spacer()
//        }
//        .padding()
//    }
//}


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
                    Text(avgString + " / " + avgPct + "%")
                }
            }
            .cornerRadius(10)
            .chartXScale(domain: 0...roundsData.posMax[0]+1)
//            .chartXAxis (.hidden)
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

