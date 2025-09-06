////
////  ContentView.swift
////  MyClayScores
////
////  Created by Doxie Davis on 6/23/23.
////
//
//import SwiftUI
//import CoreData
//
//struct CompakNRView: View {
//    
//    @EnvironmentObject var roundsData: RoundsDataStack
//    @State private var showAlert: Bool = false
//    @FocusState private var isFocused: Bool
//    @State private var keyboardHeight: CGFloat = 0
//    
//    var body: some View {
//        
//        ScrollViewReader { scrollProxy in
//            ScrollView {
//                VStack{
//                    HStack {
//                        Button(action: {
//                            if roundsData.roundTotal == 0 {
//                                roundsData.clearData()
//                                roundsData.selection = 0
//                            } else {
//                                showAlert = true
//                            }
//                        }, label: {
//                            HStack {
//                                Image(systemName: "arrow.left").font(.title2)
//                                Text("Back").font(.title2)
//                            }
//                        })
//                        .alert(isPresented: $showAlert, content: {
//                            Alert(
//                                title: Text("WARNING"),
//                                message: Text("Exiting without saving round  will discard any scoring input."),
//                                primaryButton: .cancel(Text("Continue Round")),
//                                secondaryButton: .destructive(Text("Discard Data"), action: {
//                                    roundsData.clearData()
//                                    roundsData.selection = 0
//                                }))
//                        })
//                        Spacer()
//                        Button(action: {
//                            roundsData.addRound(
//                                range: roundsData.selectedRange,
//                                comment: roundsData.comment,
//                                date: Date.now,
//                                pos1: Int64(roundsData.posCount[0]),
//                                pos2: Int64(roundsData.posCount[1]),
//                                pos3: Int64(roundsData.posCount[2]),
//                                pos4: Int64(roundsData.posCount[3]),
//                                pos5: Int64(roundsData.posCount[4]),
//                                total: Int64(roundsData.roundTotal))
//                            roundsData.saveRounds()
//                            roundsData.fetchRounds()
//                            roundsData.calcAvgs()
//                            roundsData.clearData()
//                            roundsData.editDone = true
//                            roundsData.selection = 0
//                        }, label: {
//                            Text("SAVE ROUND")
//                        })
//                        .padding(.all)
//                        .font(.title3.bold())
//                        .background(.blue)
//                        .background(.blue)
//                        .foregroundColor(.white)
//                        .clipShape(Capsule())
//                    }
//                    .id(0)
////                    Spacer()
//                    Spacer()
//                    VStack {
//                        Text("\(roundsData.selectedRange)")
//                            .font(.title)
//                            .underline()
//                            .fontWeight(.bold)
//                        Spacer()
//                        Text("New Round")
//                            .font(.title2.italic())
//                            .fontWeight(.bold)
//                    }
//                    .padding()
//                    VStack {
//                        FivePosButtons()
//                        
//                        
////                        HStack {
////                            VStack (spacing: 30) {
////                                Picker("", selection: $roundsData.posCount[4]) {
////                                    HStack {
////                                        Image(systemName: "circle")
////                                        Image(systemName: "circle.fill")
////                                    }
////                                    .tag(0)
////                                    Image(systemName: "circle.fill").tag(1)
////                                }
////                                .onChange(of: roundsData.posCount[4], perform: { (value) in
////                                    roundsData.addupScore()
////                                })
////                                .pickerStyle(MenuPickerStyle())
//////                                .opacity(0.1)
////                                Picker("", selection: $roundsData.posCount[4]) {
////                                    Image(systemName: "circle").tag(0)
////                                    Image(systemName: "circle.fill").tag(1)
////                                }
////                                .onChange(of: roundsData.posCount[4], perform: { (value) in
////                                    roundsData.addupScore()
////                                })
////                                .pickerStyle(MenuPickerStyle())
//////                                .opacity(0.1)
////                                Text("D")
////                                Text("0")
////                                    .underline()
////                            }
////                            Spacer()
////                            VStack (spacing: 30) {
////                                Text("S")
////                                Text("D")
////                                Text("D")
////                                Text("0")
////                                    .underline()
////                            }
////                            Spacer()
////                            VStack (spacing: 30) {
////                                Text("S")
////                                Text("D")
////                                Text("D")
////                                Text("0")
////                                    .underline()
////                            }
////                            Spacer()
////                            VStack (spacing: 30) {
////                                Text("S")
////                                Text("D")
////                                Text("D")
////                                Text("0")
////                                    .underline()
////                            }
////                            Spacer()
////                            VStack (spacing: 30) {
////                                Text("S")
////                                Text("D")
////                                Text("D")
////                                Text("0")
////                                    .underline()
////
////                            }
////                        }
////                        .padding(.leading)
////                        .padding(.trailing)
//                        Spacer()
//                        Spacer()
//                        Text("Total Score:  \(roundsData.roundTotal)")
//                            .font(.title.italic())
//                            .fontWeight(.bold)
//                            Spacer()
//                        VStack (alignment: .center, spacing: 0, content: {
//                            Text("Comment")
//                                .font(.title3)
//                            TextField (roundsData.comment, text: $roundsData.comment)
//                                .focused($isFocused)
//                                .font(.title3)
//                                .textFieldStyle(.roundedBorder)
//                                .onChange(of: self.roundsData.comment, perform : { value in
//                                    if value.count > 10 {
//                                        self.roundsData.comment = String(value.prefix(28))
//                                    }
//                                })
//                                .onSubmit {
//                                    withAnimation {
//                                        scrollProxy.scrollTo(0)
//                                    }
//                                }
//                                .multilineTextAlignment(.center)
////                                .padding()
//                        })
////                        .padding()
//                        Text ("Tap on a Position to enter score.")
//                            .font(.title3)
//                            .italic()
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .toolbar(.hidden, for: .tabBar)
//                    }
//
//                }
//                
//                .sheet(isPresented: $roundsData.showScoring) {
//                    CompakScoringView()
////                    presentationDetents([.large])
////                    presentationBackground(.ultraThinMaterial)
//
//                }
//                
//                .onTapGesture {
//                    isFocused = false
//                }
//                .padding()
//
//                
//            }
//        }
//    }
//    
//    
//    struct CompakNRView_Previews: PreviewProvider {
//        static var previews: some View {
//            CompakNRView()
//                .environmentObject(RoundsDataStack())
//        }
//    }
//}
