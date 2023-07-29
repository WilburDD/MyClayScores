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

struct NewRoundView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    @State private var showAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack{
            HStack {
                Button(action: {
                    if roundsData.shotCount == 0 {
                        roundsData.clearData()
                        roundsData.turnOffClicker()
                        dismiss()
                    } else {
                        showAlert = true
                    }
                }, label: {
                    Image(systemName: "arrow.left").font(.title2)
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(
                        title: Text("WARNING"),
                        message: Text("Exiting before scoring is complete will discard all of this round's data."),
                        primaryButton: .cancel(Text("Continue Round")),
                        secondaryButton: .destructive(Text("Discard Data"), action: {
                            roundsData.clearData()
                            roundsData.turnOffClicker()
                            dismiss()
                        }))
                })
                Spacer()
                VStack {
                    Text("New Round")
                        .font(.title.italic())
                        .padding(5)
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding()
            
            //            ProgressView("", value: Double(roundsData.shotCount), total: 25).accentColor(.black)
            //            Text("\(timeRemaining)")
            .opacity(1.0)
            Spacer()
            HStack {
                VStack{
                    Text ("\(roundsData.posCount[0])")
                        .font(.largeTitle)
                        .underline()
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(roundsData.seePos[0])
                    Text("\(roundsData.pos1Avg, specifier: "%.1f")").italic()
                }
                Spacer()
                VStack{
                    Text ("\(roundsData.posCount[1])")
                        .font(.largeTitle)
                        .underline()
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(roundsData.seePos[1])
                    Text("\(roundsData.pos2Avg, specifier: "%.1f")").italic()
                }
                Spacer()
                VStack{
                    Text ("\(roundsData.posCount[2])")
                        .font(.largeTitle)
                        .underline()
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(roundsData.seePos[2])
                    Text("\(roundsData.pos3Avg, specifier: "%.1f")").italic()
                }
                Spacer()
                VStack{
                    Text ("\(roundsData.posCount[3])")
                        .font(.largeTitle)
                        .underline()
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(roundsData.seePos[3])
                    Text("\(roundsData.pos4Avg, specifier: "%.1f")").italic()
                }
                Spacer()
                VStack{
                    Text ("\(roundsData.posCount[4])")
                        .font(.largeTitle)
                        .underline()
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .opacity(roundsData.seePos[4])
                    Text("\(roundsData.pos5Avg, specifier: "%.1f")").italic()
                }
            }
            .padding()
            Spacer()
            HStack{
                Spacer()
                VStack{
                    Text("Shots").font(.largeTitle).fontWeight(.bold)
                    Text("\(roundsData.shotCount)").font(.largeTitle).fontWeight(.bold)
                }
                Spacer()
                VStack{
                    Text("Hits").font(.largeTitle).fontWeight(.bold)
                    Text("\(roundsData.roundTotal)").font(.largeTitle).fontWeight(.bold)
                }
                Spacer()
                VStack{
                    Text("Average").font(.largeTitle).fontWeight(.bold).italic()
                    Text ("\(roundsData.totalAvg, specifier: "%.1f")").font(.largeTitle).italic().fontWeight(.bold)
                }
                Spacer()
            }
            Spacer()
            Image("TrapShooter")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
            Spacer()
            if roundsData.phoneScoring == true {
                ScoringButtonsView()
                Spacer()
            } else {
                EmptyView()
            }
        }
        .navigationDestination(isPresented: $roundsData.roundComplete, destination: {
            EditView()
        })
        .multilineTextAlignment(.center)
        .navigationBarHidden(true)
        .onAppear{
            roundsData.viewSet = true
            roundsData.scoringStarted = true
            //            timeRemaining = 300
            MPVolumeView.setVolume()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                roundsData.viewSet = false
            }
            roundsData.turnOnClicker()
            roundsData.observeVolume()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onChange(of: roundsData.resetVolume) { newValue in
            roundsData.viewSet = true
            MPVolumeView.setVolume()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                roundsData.viewSet = false
            }
        }
    }
}


struct NewRoundView_Previews: PreviewProvider {
    static var previews: some View {
        NewRoundView()
            .environmentObject(RoundsDataStack())
    }
}

