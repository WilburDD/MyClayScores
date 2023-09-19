//
//  ContentView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData
import MediaPlayer
import AVFoundation

struct FivePosEditView: View {
    
    let item: RoundEntity
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @Environment(\.dismiss) var dismiss
    @State private var showAlert: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        
        ScrollViewReader {scrollProxy in
            ScrollView {
                VStack{
                    HStack {
                        Button(action: {
                            roundsData.clearData()
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            dismiss()
                        }, label: {
                            HStack {
                                Image(systemName: "arrow.left").font(.title2)
                                Text("Back").font(.title2)
                            }
                        })
                        Spacer()
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
                                pos6: Int64(roundsData.posCount[5]),
                                pos7: Int64(roundsData.posCount[6]),
                                pos8: Int64(roundsData.posCount[7]),
                                pos9: Int64(roundsData.posCount[8]),
                                total: Int64(roundsData.roundTotal))
                            roundsData.saveRounds()
                            roundsData.fetchRounds()
                            roundsData.clearData()
                            roundsData.calcAvgs()
                            roundsData.path.removeLast(roundsData.path.count)
                            dismiss()
                        }, label: {
                            Text("SAVE CHANGES")
                        })
                        .padding(.all)
                        .font(.title3.bold())
                        .background(.blue)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .id(0)
                    Spacer()
                    Spacer()
                    VStack {
                        Text("\(roundsData.selectedRange)")
                            .font(.title)
                            .underline()
                            .fontWeight(.bold)
                        Spacer()
                        Text("Saved Round Edit")
                            .font(.title2.italic())
                            .fontWeight(.bold)
                    }
                    .padding()
                    VStack {
                        FivePosLabels()
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
                                }
                                .onChange(of: roundsData.posCount[0], perform: { (value) in
                                    roundsData.addupScore()
                                })
                                .pickerStyle(MenuPickerStyle())
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
                                }
                                .onChange(of: roundsData.posCount[1], perform: { (value) in
                                    roundsData.addupScore()
                                })
                                .pickerStyle(MenuPickerStyle())
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
                                }
                                .onChange(of: roundsData.posCount[2], perform: { (value) in
                                    roundsData.addupScore()
                                })
                                .pickerStyle(MenuPickerStyle())
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
                                }
                                .onChange(of: roundsData.posCount[3], perform: { (value) in
                                    roundsData.addupScore()
                                })
                                .pickerStyle(MenuPickerStyle())
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
                                }
                                .onChange(of: roundsData.posCount[4], perform: { (value) in
                                    roundsData.addupScore()
                                })
                                .pickerStyle(MenuPickerStyle())
                                .opacity(0.1)
                            }
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("Total Score:  \(roundsData.roundTotal)")
                            .font(.title.italic())
                            .fontWeight(.bold)
                        VStack (alignment: .center, spacing: 0, content: {
                            Text("Comment")
                                .font(.title3)
                            TextField (roundsData.comment, text: $roundsData.comment)
                                .focused($isFocused)
                                .font(.title3)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: self.roundsData.comment, perform : { value in
                                    if value.count > 10 {
                                        self.roundsData.comment = String(value.prefix(18))
                                    }
                                })
                                .onSubmit {
                                    withAnimation {
                                        scrollProxy.scrollTo(0)
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .padding()
                        })
                        .padding()
                        HStack {
                            Text ("Tap on the  ")
                            + Text("'0'").underline()
                            + Text("  for a Position to enter score.")
                        }
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onTapGesture {
            isFocused = false
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
            roundsData.posCount[5] = Int(item.pos6)
            roundsData.posCount[6] = Int(item.pos7)
            roundsData.posCount[7] = Int(item.pos8)
            roundsData.posCount[8] = Int(item.pos9)
            roundsData.roundTotal = Int(item.total)
        }
        .environmentObject(roundsData)

    }
}

//struct FivePosEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        FivePosEditView(item: item)
//            .environmentObject(RoundsDataStack())
//    }
//}



