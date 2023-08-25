//
//  RangeSelectionView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct SelectRange: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    @AppStorage ("storedRange") var storedRange = String()
        
    var body: some View {
        VStack {
            VStack {
                Text("Select Range")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .underline()
                    .padding(.top)
                Spacer()
                VStack{
                    Text("Trap")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "American Trap"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("American").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "Continental Trap"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("Continental").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "ISSF/Olympic Trap"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("ISSF/Olympic").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "Double Trap"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("Double").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                    }
                    .padding()
                    CustomDivider()
                }
                VStack {
                    Text("Skeet")
                        .font(.title)
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "American Skeet"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("American").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                        Button(action: {
                            roundsData.selectedRange = "ISSF/Olympic Skeet"
                            storedRange = roundsData.selectedRange
                            roundsData.positions = 5
                            roundsData.fetchRounds()
                            roundsData.calcAvgs()
                            roundsData.selection = 0
                        }, label: {
                            Text("ISSF/Olympic").font(.title)
                        })
                        .getRangeButtonStyle()
                        Spacer()
                    }
                    .padding(.bottom)
                    CustomDivider()
                }
                VStack {
                    Text("Sporting")
                        .font(.title)
                        .fontWeight(.bold)
                    Button(action: {
                        roundsData.selectedRange = "Compak/5-Stand"
                        storedRange = roundsData.selectedRange
                        roundsData.positions = 5
                        roundsData.fetchRounds()
                        roundsData.calcAvgs()
                        roundsData.selection = 0
                    }, label: {
                        Text("Compak/5-Stand").font(.title)
                    })
                    .getRangeButtonStyle()
                }
                .padding()
                //            CustomDivider()
                //            VStack {
                //                Text("Tap to set Preferred Range:")
                //                    .font(.title2)
                //                    .fontWeight(.bold)
                //                    .italic()
                //                Menu {
                //                    Picker("", selection: $roundsData.defaultRange) {
                //                        Text("None").tag("None")
                //                        Text("American Trap").tag("American Trap")
                //                        Text("Continental Trap").tag("Continental Trap")
                //                        Text("ISSF/Olympic Trap").tag("ISSF/Olympic Trap")
                //                        Text("Doubles Trap").tag("Doubles Trap")
                //                        Text("American Skeet").tag("American Skeet")
                //                        Text("ISSF/Olympic Skeet").tag("ISSF/Olympic Skeet")
                //                        Text("Compak/5-Stand").tag("Compak/5-Stand")
                //                    }
                //                    .onChange(of: roundsData.defaultRange) { newValue in
                //                        roundsData.selectedRange = newValue
                //                        roundsData.selection = 1
                //                    }
                //                }
                //            label: {
                //                Text(roundsData.defaultRange)
                //                .font(.title2)            }
                //            }
                Spacer()
            }

            
            Spacer()
            Spacer()
        }
    }
}

struct CustomDivider: View {
    let color: Color
    let height: CGFloat
    
    init(color: Color = .blue.opacity(1.0),
         height: CGFloat = 2.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

extension Button {
    func getRangeButtonStyle() -> some View {
        self
            .font(.headline)
            .padding(10)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
    }
}

struct RangeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRange()
            .environmentObject(RoundsDataStack())
    }
}
