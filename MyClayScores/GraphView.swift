//
//  GraphView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData
import Charts

struct GraphView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    let yValues = stride(from: 0, to: 6, by: 1) .map { $0 }
    let totalValues = stride(from: 0, to: 26, by: 5) .map { $0 }
    
    let graphTitle = ["Pos 1", "Pos 2", "Pos 3", "Pos 4", "Pos 5"]
    let graphOrder = ["item.pos1", "item.pos2", "item.pos3", "item.pos4", "item.pos5"]
    let graphMark = ["pos1Avg", "pos2Avg", "pos3Avg", "pos4Avg", "pos5Avg"]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if roundsData.selectedRange == "American" {
                        roundsData.selectedRange = "Continental"
                        roundsData.contOpactity = 1.0
                        roundsData.amerOpactity = 0.5
                        roundsData.intlOpacity = 0.5
                    } else {
                        if roundsData.selectedRange == "Continental" {
                            roundsData.selectedRange = "Intl./Olympic"
                            roundsData.intlOpacity = 1.0
                            roundsData.contOpactity = 0.5
                            roundsData.amerOpactity = 0.5
                        } else {
                            if roundsData.selectedRange == "Intl./Olympic" {
                                roundsData.selectedRange = "American"
                                roundsData.intlOpacity = 0.5
                                roundsData.contOpactity = 0.5
                                roundsData.amerOpactity = 1.0
                            }}}
                    roundsData.fetchGraphs()
                    roundsData.calcAvgs()
                }, label: {
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(2)
                })
                Spacer()
            }
            .padding(10)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .numeric, time: .shortened)),
                                y: .value("", item.total)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.totalAvg))
                                .foregroundStyle(.red)
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: totalValues) // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.totalAvg, specifier: "%.1f")\n\(roundsData.totalAvg/25*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Total")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .numeric, time: .shortened)),
                                y: .value("Score", item.pos1)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.pos1Avg))
                                .foregroundStyle(.red)
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: yValues)  // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.pos1Avg, specifier: "%.1f")\n\(roundsData.pos1Avg/5*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Pos 1")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .numeric, time: .shortened)),
                                y: .value("", item.pos2)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.pos2Avg))
                                .foregroundStyle(.red)
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: yValues)  // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.pos2Avg, specifier: "%.1f")\n\(roundsData.pos2Avg/5*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Pos 2")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .numeric, time: .shortened)),
                                y: .value("", item.pos3)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.pos3Avg))
                                .foregroundStyle(.red)
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: yValues)  // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.pos3Avg, specifier: "%.1f")\n\(roundsData.pos3Avg/5*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Pos 3")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .long, time: .shortened)),
                                y: .value("", item.pos4)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.pos4Avg))
                                .foregroundStyle(.red)
                            
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: yValues)  // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.pos4Avg, specifier: "%.1f")\n\(roundsData.pos4Avg/5*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Pos 4")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
            ZStack(alignment: .bottomLeading) {
                HStack (spacing: 0) {
                    Chart {
                        ForEach(roundsData.roundsData, id: \.self) { item in
                            LineMark (
                                x: .value("", item.date!.formatted(date: .long, time: .shortened)),
                                y: .value("", item.pos5)
                            )
                            .foregroundStyle(Color.blue)
                            .symbol(Circle())
                            RuleMark(y:  .value("Average", roundsData.pos5Avg))
                                .foregroundStyle(.red)
                        }
                    }
                    .chartYAxis{
                        AxisMarks(position: .trailing, values: yValues)  // << here !!
                    }
                    .chartXAxis{
                        AxisMarks {
                            AxisGridLine()
                        }}
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(.gray.opacity(0.2))
                    }
                    Text("Avg\n\(roundsData.pos5Avg, specifier: "%.1f")\n\(roundsData.pos5Avg/5*100, specifier: "%.0f")%")
                        .foregroundColor(.red)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                }
                Text("Pos 5")
                    .fontWeight(.bold)
            }
            .padding(.leading, 5)
        }
        .padding(.bottom)
        .onAppear{
            roundsData.fetchGraphs()
        }
    }
}


struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
