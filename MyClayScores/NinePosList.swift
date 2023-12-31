//
//  EightPosList.swift
//  MyClayScores
//
//  Created by Doxie Davis on 8/11/23.
//

import SwiftUI

struct NinePosList: View {
    
    let item: RoundEntity
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                Text("\(item.pos1)")
                Spacer()
                HStack {
                    Text("\(item.pos2)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos3)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos4)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos5)")
                    Spacer()
                }
            }
                HStack {
                    Text("\(item.pos6)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos7)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos8)")
                    Spacer()
                }
                HStack {
                    Text("\(item.pos9)")
                    Spacer()
                }
                Text("\(item.total)")
                    .fontWeight(.bold)
            }
            .font(.title2)
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

//struct NinePosList_Previews: PreviewProvider {
//    static var previews: some View {
//        NinePosList(item: RoundEntity)
//    }
//}
