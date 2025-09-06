//
//  AvgChart.swift
//  MyClayScores
//
//  Created by Doxie Davis on 9/16/23.
//

import SwiftUI
import Charts

struct AvgChart: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    @State private var showSelectionBar = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    @State private var selectedDay = ""
    @State private var selectedScore = 0
    @State private var selectedComment = ""
    
    var body: some View {
        
        let totalValues = stride(from: roundsData.minTotal, to: Int(roundsData.graphMax), by: 5) .map { $0 }
        
        Chart (roundsData.graphData, id: \.self) { item in
            LineMark (
                x: .value("", item.seq),
                y: .value("", item.score)
            )
            .foregroundStyle(Color.blue)
            .symbol(Circle())
            RuleMark(y:  .value("", roundsData.totalAvg))
                .foregroundStyle(.red)
        }
        .chartPlotStyle { content in
            content.frame(height: 100)
        }
        
        .chartOverlay { pr in
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.gray.opacity(0.2))
            GeometryReader { geoProxy in
                Rectangle().foregroundStyle(Color.green.gradient)
                    .frame(width: 4, height: geoProxy.size.height * 0.95)
                    .opacity(showSelectionBar ? 1.0 : 0.0)
                    .offset(x: offsetX)
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.green.gradient)
                    .frame(width: 250, height: 100)
                    .overlay {
                        VStack {
                            Text("\(selectedDay)")
                            Text("\(selectedScore)")
                                .fontWeight(.bold)
                            Text("\(selectedComment)")
                                .italic()
                        }
                        .foregroundStyle(.white.gradient)
                    }
                    .opacity(showSelectionBar ? 1.0 : 0.0)
                    .offset(x: 30, y: offsetY - 250)
                
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged { value in
                            if !showSelectionBar {
                                showSelectionBar = true
                            }
                            let origin = geoProxy[pr.plotAreaFrame].origin
                            let location = CGPoint(
                                x: value.location.x - origin.x,
                                y: value.location.y - origin.y
                            )
                            offsetX = location.x
                            offsetY = location.y
                            
                            let (seq, _ ) = pr.value(at: location, as: (String, Int).self) ?? ("-", 0)
                            let x = Int(seq) ?? 0
                            selectedDay = roundsData.graphData[x].date
                            selectedScore = roundsData.graphData[x].score
                            selectedComment = roundsData.graphData[x].comment
                        }
                        .onEnded({ _ in
                            showSelectionBar = false
                        }))
            }
        }
        .chartXAxis{
            AxisMarks {
                AxisGridLine()
            }}
        .chartXAxisLabel (position: .bottom, alignment: .center) {
            Text("Rounds/Time (Touch & Drag to see details)")
        }
        .chartYScale(domain: roundsData.minTotal...Int(roundsData.graphMax))
        .chartYAxis{
            AxisMarks(position: .trailing, values: totalValues)
        }
    }
}

struct AvgChart_Previews: PreviewProvider {
    static var previews: some View {
        AvgChart()
    }
}
