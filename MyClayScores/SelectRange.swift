//
//  RangeSelectionView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI

struct SelectRange: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        VStack {
            Text("Select Range")
                .font(.title)
                .fontWeight(.bold)
                .italic()
                .underline()
            Spacer()
            VStack{
                Text("Trap")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    Spacer()
                    Button(action: {
                        roundsData.selectedRange = "American Trap"
                        roundsData.selection = 1
                    }, label: {
                        Text("American").font(.title)
                    })
                    .getRangeButtonStyle()
                    Spacer()
                    Button(action: {
                        roundsData.selectedRange = "Continental Trap"
                        roundsData.selection = 1
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
                    }, label: {
                        Text("ISSF/Olympic").font(.title)
                    })
                    .getRangeButtonStyle()
                    Spacer()
                    Button(action: {
                        roundsData.selectedRange = "Double Trap"
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
                        roundsData.rangeSelected = true
                    }, label: {
                        Text("American").font(.title)
                    })
                    .getRangeButtonStyle()
                    Spacer()
                    Button(action: {
                        roundsData.selectedRange = "ISSF/Olympic Skeet"
                    }, label: {
                        Text("ISSF/Olympic").font(.title)
                    })
                    .getRangeButtonStyle()
                    Spacer()
                }
                .padding()
                CustomDivider()
            }
            VStack {
                Text("Sporting")
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    //                    Spacer()
                    Button(action: {
                        roundsData.selectedRange = "Compak/5-Stand"
                    }, label: {
                        Text("Compak/5-Stand").font(.title)
                    })
                    .getRangeButtonStyle()
                    
                    //                    Spacer()
                }
            }
            .padding()
            CustomDivider()
            Spacer()
            VStack {
                Text("Tap to set Preferred Range:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .italic()
                Menu {
                    Picker("", selection: $roundsData.defaultRange) {
                        Text("None").tag("None")
                        Text("American Trap").tag("American Trap")
                        Text("Continental Trap").tag("Continental Trap")
                        Text("Olympic Trap").tag("Olympic Trap")
                        Text("Doubles Trap").tag("Doubles Trap")
                        Text("American Skeet").tag("American Skeet")
                        Text("Olympic Skeet").tag("Olympic Skeet")
                        Text("Compak/5-Stand").tag("Compak/5-Stand")
                    }
                } label: {
                    Text(roundsData.defaultRange)
                    .font(.title2)            }
            }
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
