//
//  ContentView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData
//import MediaPlayer
//import AVFoundation

struct NewRoundView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @State private var showAlert: Bool = false
    @FocusState private var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var scoring: [Double] = [5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0]
    @AppStorage("scoringSet") var scoringSet = Int()
    
    var body: some View {
        
        ScrollViewReader {scrollProxy in
            ScrollView {
                VStack{
                    HStack {
                        Button(action: {
                            if roundsData.roundTotal == 0 {
                                roundsData.clearData()
                                roundsData.path.removeLast(roundsData.path.count)
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
                                    roundsData.path.removeLast(roundsData.path.count)
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
                        }, label: {
                            Text("SAVE ROUND")
                        })
                        .padding(.all)
                        .font(.title3.bold())
                        .background(.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .padding()
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
                    //                    .padding()
                    
                    VStack {
                        Text("Position")
                            .font(.title3)
                        HStack {
                            ForEach(0..<5, id: \.self) { item in
                                let maxScore = scoring[item]
                                VStack {
                                    ZStack{
                                        Image(systemName: "square")
                                            .font(.title)
                                        Text("\(item+1)")
                                            .font(.title3)
                                            .padding()
                                    }
                                    Spacer()
                                    
                                    ZStack {
                                        Text ("\(roundsData.posCount[item])")
                                            .font(.largeTitle).underline().fontWeight(.bold)
                                        Picker("", selection:
                                                $roundsData.posCount[item]) {
                                            ForEach(0..<Int(maxScore), id: \.self) { count in
                                                Text("\(count)").tag(count)
                                            }
                                        }
                                                .onChange(of: roundsData.posCount[item]) {
                                                    roundsData.addupScore()
                                                }
                                                .pickerStyle(MenuPickerStyle())
                                                .opacity(0.1)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                        if scoringSet == 2 || scoringSet == 3 {
                            HStack {
                                ForEach(5..<roundsData.positions, id: \.self) { item in
                                    let maxScore = scoring[item]
                                    VStack {
                                        ZStack{
                                            Image(systemName: "square")
                                                .font(.title)
                                            Text("\(item+1)")
                                                .font(.title3)
                                                .padding()
                                        }
                                        Spacer()
                                        
                                        ZStack {
                                            Text ("\(roundsData.posCount[item])")
                                                .font(.largeTitle).underline().fontWeight(.bold)
                                            Picker("", selection:
                                                    $roundsData.posCount[item]) {
                                                ForEach(0..<Int(maxScore), id: \.self) { count in
                                                    Text("\(count)").tag(count)
                                                }
                                            }
                                                    .onChange(of: roundsData.posCount[item]) {
                                                        roundsData.addupScore()
                                                    }
                                                    .pickerStyle(MenuPickerStyle())
                                                    .opacity(0.1)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                        }
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
                                .onChange(of: self.roundsData.comment) { value in
                                    if value.count > 18 {
                                        self.roundsData.comment = String(value.prefix(18))
                                    }
                                }
                                .onSubmit {
                                    withAnimation {
                                        scrollProxy.scrollTo(0)
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .padding()
                        })
//                        .padding()
                        HStack {
                            Text ("Tap on the  ")
                            + Text("'0'").underline()
                            + Text("  for a Position to enter score.")
                        }
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
//                        .padding()
                    }
                    .toolbar(.hidden, for: .tabBar)
                    .onTapGesture {
                        isFocused = false
                    }
                    .padding()
                }
            }
            .onAppear {
                for item in 0...8 {
                    scoring[item] = (roundsData.selectedScoring[roundsData.scoringSet][item])+1.0
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .environmentObject(roundsData)
        }
    }
    
}

struct FivePosNRView_Previews: PreviewProvider {
    static var previews: some View {
        FivePosNRView()
            .environmentObject(RoundsDataStack())
    }
}


extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

struct Header: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        HStack {
            Button(action: {
                if roundsData.roundTotal == 0 {
                    roundsData.clearData()
                    roundsData.path.removeLast(roundsData.path.count)
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
                        roundsData.path.removeLast(roundsData.path.count)
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
            }, label: {
                Text("SAVE ROUND")
            })
            .padding(.all)
            .font(.title3.bold())
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
        .id(0)
    }
}

