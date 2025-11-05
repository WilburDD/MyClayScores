//
//  RoundsList.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct ListView: View {
    
    let item: Round
    @EnvironmentObject var roundsData: RoundsDataStack
    
    private func score(at position: Int) -> Int {
        switch position {
        case 1: return Int(item.pos1)
        case 2: return Int(item.pos2)
        case 3: return Int(item.pos3)
        case 4: return Int(item.pos4)
        case 5: return Int(item.pos5)
        case 6: return Int(item.pos6)
        case 7: return Int(item.pos7)
        case 8: return Int(item.pos8)
        case 9: return Int(item.pos9)
        default: return 0
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                ForEach(1...roundsData.positions, id: \.self) { element in
                    Text("\(score(at: element))")
                    Spacer()
                }
                HStack(spacing: 8) {
                    Text("\(item.total)")
                        .fontWeight(.bold)
                        .font(.title)
                    if item.exclude {
                        Image(systemName: "nosign")
                            .foregroundColor(.red)
                            .accessibilityLabel("Excluded from averages")
                    }
                }
            }
            .font(.title2)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading)
            HStack {
                Text(item.date?.formatDate() ?? Date.now.formatDate())
                Spacer()
                Text(item.comment ?? "")
            }
            .font(.caption.italic())
        }
        .opacity(item.exclude ? 0.85 : 1.0)
    }
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMM yyyy, HH:mm")
        return dateFormatter.string(from: self)
    }
}

//struct RoundsList_Previews: PreviewProvider {
//    static var previews: some View {
//        RoundsList(item: RoundEntity())
//    .environmentObject(RoundsDataStack())
//    }
//}
