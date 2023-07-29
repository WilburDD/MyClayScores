//
//  EditView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData

struct EditView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @Environment(\.dismiss) var dismiss
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text ("New Round Edit")
                .font(.title)
                .underline()
                .italic()
                .padding(5)
            RangeSelectionView()
//            Spacer()
            VStack (spacing: 10) {
                Text("Score?")
                    .font(.largeTitle)
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
//                .padding()
            }
            VStack (alignment: .center, spacing: 0, content: {
                Text("Comment")
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
            Text("\(roundsData.roundDate .formatDate())")
                .font(.title2)
            HStack {
                Button(action: {
                    showAlert = true
                }, label: {
                    Text("DISCARD")
                })
                .padding(.all)
                .font(.title3.bold())
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $showAlert, content: {
                    Alert(
                        title: Text("WARNING"),
                        message: Text("All Round data will be lost upon DISCARD."),
                        primaryButton: .cancel(Text("Continue Edit")),
                        secondaryButton: .destructive(Text("DISCARD Data"), action: {
                            roundsData.clearData()
                            showAlert = false
                            roundsData.posSelected = false
                            roundsData.editDone = true
                            roundsData.selection = 0
                        }))
                })
                Spacer()
                Button(action: {
                    roundsData.addRound(
                        range: roundsData.selectedRange,
                        comment: roundsData.comment,
                        date: Date.now,
                        pos1: Int64(roundsData.posCount[0]),
                        pos2: Int64(roundsData.posCount[1]),
                        pos3: Int64(roundsData.posCount[2]),
                        pos4: Int64(roundsData.posCount[3]),
                        pos5: Int64(roundsData.posCount[4]),
                        total: Int64(roundsData.roundTotal))
                    roundsData.saveRounds()
                    roundsData.fetchRounds()
                    roundsData.calcAvgs()
                    roundsData.clearData()
                    roundsData.editDone = true
                    roundsData.selection = 0
                }, label: {
                    Text("SAVE")
                })
                .padding(.all)
                .font(.title3.bold())
                .background(.blue)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding()
            
            Text ("Tap on Range selection or a Position Score to change if desired. You can also enter or edit Comment. Then press SAVE or DISCARD. ")
                .font(.title3)
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
            .environmentObject(RoundsDataStack())
    }
}

