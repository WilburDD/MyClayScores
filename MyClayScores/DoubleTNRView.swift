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

struct DoubleTNRView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @State private var showAlert: Bool = false
    @FocusState private var isFocused: Bool
    
    @State private var eightPos: Bool = false
    @State private var ninePos: Bool = false
    
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        
        ScrollViewReader {scrollProxy in
            ScrollView {
                VStack{
                    HStack {
                        Button(action: {
                            if roundsData.roundTotal == 0 {
                                roundsData.clearData()
                                roundsData.selection = 0
                            } else {
                                showAlert = true
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "arrow.left").font(.title2)
                                Text("Back").font(.title2)
                            }
                        })
                        .alert(isPresented: $showAlert, content: {
                            Alert(
                                title: Text("WARNING"),
                                message: Text("Exiting without saving round  will discard any scoring input."),
                                primaryButton: .cancel(Text("Continue Scoring")),
                                secondaryButton: .destructive(Text("Discard Data"), action: {
                                    roundsData.clearData()
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
                            Text("SAVE ROUND")
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
                        Text("New Round")
                            .font(.title2.italic())
                            .fontWeight(.bold)
                    }
                    //                    Spacer()
                    //                }
                    .padding()
                    VStack {
                        FivePosLabels()
                        HStack {
                            ZStack {
                                Text ("\(roundsData.posCount[0])")
                                    .font(.largeTitle).underline().fontWeight(.bold)
                                Picker("", selection:
                                        $roundsData.posCount[0]) {
                                    ForEach(1..<11) { count in
                                        Text("\(count)").tag(count)
                                    }
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
                                Picker("", selection:
                                        $roundsData.posCount[1]) {
                                    ForEach(1..<11) { count in
                                        Text("\(count)").tag(count)
                                    }
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
                                Picker("", selection:
                                        $roundsData.posCount[2]) {
                                    ForEach(1..<11) { count in
                                        Text("\(count)").tag(count)
                                    }
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
                                Picker("", selection:
                                        $roundsData.posCount[3]) {
                                    ForEach(1..<11) { count in
                                        Text("\(count)").tag(count)
                                    }
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
                                Picker("", selection:
                                        $roundsData.posCount[4]) {
                                    ForEach(1..<11) { count in
                                        Text("\(count)").tag(count)
                                    }
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
                                        self.roundsData.comment = String(value.prefix(28))
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
                        Text ("Tap on the '0' for a Position to enter score.")
                            .font(.title3)
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding()
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
                .onTapGesture {
                    isFocused = false
                }
                .padding()
            }
        }
    }
}

struct DoubleTNRView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTNRView()
            .environmentObject(RoundsDataStack())
    }
}



