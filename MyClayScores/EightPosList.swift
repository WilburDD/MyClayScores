//
//  EightPosList.swift
//  MyClayScores
//
//  Created by Doxie Davis on 8/11/23.
//

import SwiftUI

struct EightPosList: View {
    
    let item: RoundEntity
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Text("\(item.pos1)")
                    Spacer()
                    Text("\(item.pos2)")
                    Spacer()
                    Text("\(item.pos3)")
                    Spacer()
                    Text("\(item.pos4)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos5)")
                    Spacer()
                    Text("\(item.pos6)")
                    Spacer()
                    Text("\(item.pos7)")
                    Spacer()
                    Text("\(item.pos8)")
                }
                .padding(.trailing)
                Text("\(item.total)")
                    .fontWeight(.bold)
            }
            .font(.title3)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading)
            HStack {
                Text("\(item.date! .formatDate())")
                Spacer()
                Text("\(item.comment!)")
            }
            .font(.caption.italic())
            
        }
    }
}

//struct EightPosList_Previews: PreviewProvider {
//    static var previews: some View {
//        EightPosList()
//            .environmentObject(RoundsDataStack())
//    }
//}
