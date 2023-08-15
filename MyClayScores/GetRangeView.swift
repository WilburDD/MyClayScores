//
//  GetPositionView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import MediaPlayer
import AVFoundation

struct GetRangeView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack{
//            Spacer()
            SelectRange()
            ZStack {
                Image("range")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.2)
                VStack{
                    Text ("Position?")
                        .font(.title)
                        .fontWeight(.bold)
                        .italic()
                    HStack {
                        Button(action: {
                            roundsData.setData(pos: 0)
                        }, label: {
                            Text("1").font(.title)
                        })
                        .getPosButtonStyle()
                        .opacity(roundsData.seePos[0])
                        Spacer()
                        Button(action: {
                            roundsData.setData(pos: 1)
                        }, label: {
                            Text("2").font(.title)
                        })
                        .getPosButtonStyle()
                        .opacity(roundsData.seePos[1])
                        Spacer()
                        Button(action: {
                            roundsData.setData(pos: 2)
                        }, label: {
                            Text("3").font(.title)
                        })
                        .getPosButtonStyle()
                        .opacity(roundsData.seePos[2])
                        Spacer()
                        Button(action: {
                            roundsData.setData(pos: 3)
                        }, label: {
                            Text("4").font(.title)
                        })
                        .getPosButtonStyle()
                        .opacity(roundsData.seePos[3])
                        Spacer()
                        Button(action: {
                            roundsData.setData(pos: 4)
                        }, label: {
                            Text("5").font(.title)
                        })
                        .getPosButtonStyle()
                        .opacity(roundsData.seePos[4])
                    }
                    .padding()
                }
            }
            SelectRange()
            Spacer()

        }
        .onAppear{
            roundsData.clearData()
            roundsData.seePos = [0.3, 0.3, 0.3, 0.3, 0.3]
            roundsData.clickerConfirm = true
            roundsData.turnOnClicker()
            MPVolumeView.setVolume()
        }
        .navigationDestination(isPresented: $roundsData.posSelected, destination: {
            AmericanTrapNRView()
        })
    }
}

extension MPVolumeView {
    static func setVolume() -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = 0.5
        }
    }
}

extension Button {
    func getPosButtonStyle() -> some View {
        self
            .font(.headline)
            .padding(10)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
    }
}

struct GetRangeView_Previews: PreviewProvider {
    static var previews: some View {
        GetRangeView()
            .environmentObject(RoundsDataStack())
    }
}
