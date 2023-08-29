//
//  RangeSelectionView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct SelectRange: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage ("storedRange") var storedRange = String()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Spacer()
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
                                dismiss()
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
                                dismiss()
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
                                dismiss()
                            }, label: {
                                Text("ISSF/Olympic").font(.title)
                            })
                            .getRangeButtonStyle()
                            Spacer()
                            Button(action: {
                                roundsData.selectedRange = "Double Trap"
                                storedRange = roundsData.selectedRange
                                roundsData.positions = 10
                                roundsData.fetchRounds()
                                roundsData.calcAvgs()
                                dismiss()
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
                                roundsData.positions = 8
                                roundsData.fetchRounds()
                                roundsData.calcAvgs()
                                dismiss()
                            }, label: {
                                Text("American").font(.title)
                            })
                            .getRangeButtonStyle()
                            Spacer()
                            Button(action: {
                                roundsData.selectedRange = "ISSF/Olympic Skeet"
                                storedRange = roundsData.selectedRange
                                roundsData.positions = 9
                                roundsData.fetchRounds()
                                roundsData.calcAvgs()
                                dismiss()
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
                            dismiss()
                        }, label: {
                            Text("Compak/5-Stand").font(.title)
                        })
                        .getRangeButtonStyle()
                    }
                    .padding()
                    Spacer()
                }
            }
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
    

