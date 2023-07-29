//
//  SavedRoundEdit.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData

struct SavedRoundEdit: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @Environment(\.dismiss) var dismiss
    @State private var showAlert: Bool = false
//    var editedIndex: IndexSet
    
    let item: RoundEntity
    
    var body: some View {
        VStack {
            Text ("Saved Round Edit")
                .font(.title)
                .italic()
                .underline()
                .padding(5)
            
            RangeSelectionView()
                .padding(10)
            VStack {
                Text("Score?")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                HStack {
                    ZStack {
                        Text ("\(roundsData.posCount[0])")
                            .font(.largeTitle).underline().fontWeight(.bold)
                        Picker("", selection: $roundsData.posCount[0]) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                                .pickerStyle(MenuPickerStyle())
                        }
                        .opacity(0.1)
                    }
                    Spacer()
                    ZStack {
                        Text ("\(roundsData.posCount[1])")
                            .font(.largeTitle).underline().fontWeight(.bold)
                        Picker("", selection: $roundsData.posCount[1]) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                                .pickerStyle(MenuPickerStyle())
                        }
                        .opacity(0.1)
                    }
                    Spacer()
                    ZStack {
                        Text ("\(roundsData.posCount[2])")
                            .font(.largeTitle).underline().fontWeight(.bold)
                        Picker("", selection: $roundsData.posCount[2]) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                                .pickerStyle(MenuPickerStyle())
                        }
                        .opacity(0.1)
                    }
                    Spacer()
                    ZStack {
                        Text ("\(roundsData.posCount[3])")
                            .font(.largeTitle).underline().fontWeight(.bold)
                        Picker("", selection: $roundsData.posCount[3]) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                                .pickerStyle(MenuPickerStyle())
                        }
                        .opacity(0.1)
                    }
                    Spacer()
                    ZStack {
                        Text ("\(roundsData.posCount[4])")
                            .font(.largeTitle).underline().fontWeight(.bold)
                        Picker("", selection: $roundsData.posCount[4]) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                            Text("5").tag(5)
                                .pickerStyle(MenuPickerStyle())
                        }
                        .opacity(0.1)
                    }
                }
                .padding()
            }
            VStack (alignment: .center, spacing: 0, content: {
                Text("Comment (28 char. max)")
                    .font(.title2)
                TextField (roundsData.comment, text: $roundsData.comment)
                    .font(.title3)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: self.roundsData.comment, perform : { value in
                        if value.count > 10 {
                            self.roundsData.comment = String(value.prefix(28))
                        }
                    })
                    .multilineTextAlignment(.center)
                    .padding()
            })
            Spacer()
            Text("\(roundsData.roundDate .formatDate())")
                .font(.title2)
                .padding()
            Button(action: {
                
                roundsData.deleteEditedRound(index: roundsData.editedIndex)
                
                roundsData.saveEdit(
                    range: roundsData.selectedRange,
                    comment: roundsData.comment,
                    date: roundsData.roundDate,
                    id: roundsData.roundID,
                    pos1: Int64(roundsData.posCount[0]),
                    pos2: Int64(roundsData.posCount[1]),
                    pos3: Int64(roundsData.posCount[2]),
                    pos4: Int64(roundsData.posCount[3]),
                    pos5: Int64(roundsData.posCount[4]),
                    total: Int64(roundsData.posCount[0]+roundsData.posCount[1]+roundsData.posCount[2]+roundsData.posCount[3]+roundsData.posCount[4]))
                roundsData.saveRounds()
                roundsData.fetchRounds()
                roundsData.calcAvgs()
                roundsData.clearData()
                roundsData.editDone = true
                roundsData.selection = 0
                dismiss()
            }, label: {
                Text("SAVE EDIT")
            })
            .padding(.all)
            .font(.title3.bold())
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Capsule())

            //
            //            Spacer()
            //
            //            Text ("Tap on Range selection or a Position Score to change if desired. You can also enter or edit Comment. Then press SAVE EDIT or Back. ")
            //                .font(.title3)
            //                .italic()
            //                .multilineTextAlignment(.center)
            //                .padding()
        }
        .onAppear {
            roundsData.editedIndex = roundsData.roundsData.firstIndex(of: item) ?? 0
            roundsData.selectedRange = item.range!
            roundsData.comment = item.comment!
            roundsData.roundDate = item.date!
            roundsData.roundID = item.id ?? UUID()
            roundsData.posCount[0] = Int(item.pos1)
            roundsData.posCount[1] = Int(item.pos2)
            roundsData.posCount[2] = Int(item.pos3)
            roundsData.posCount[3] = Int(item.pos4)
            roundsData.posCount[4] = Int(item.pos5)
            roundsData.roundTotal = Int(item.total)
        }
    }
}

//struct SavedRoundEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedRoundEdit(item: item)
//            .environmentObject(RoundsDataStack())
//    }
//}

