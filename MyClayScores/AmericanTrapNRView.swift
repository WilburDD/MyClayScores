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

struct AmericanTrapNRView: View {
    
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
                        message: Text("Exiting without saving round  will discard any scoring input."),
                        primaryButton: .cancel(Text("Continue Round")),
                        secondaryButton: .destructive(Text("Discard Data"), action: {
                            roundsData.clearData()
                            roundsData.turnOffClicker()
                            dismiss()
                        }))
                })
                Spacer()
                VStack {
                    Text("\(roundsData.selectedRange)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("New Round")
                        .font(.title3.italic())
                }
                Spacer()
            }
            .padding()
            FivePosLabels()
            FiveSinglesView()
            FiveSinglesView()
            FiveSinglesView()
            FiveSinglesView()
            FiveSinglesView()
            Text("Score:  \(roundsData.shotCount)")
                .font(.title.italic())
                .fontWeight(.bold)
            VStack (alignment: .center, spacing: 0, content: {
                Text("Comment")
                    .font(.title3)
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
            .padding()
//            Spacer()
        }
        .padding()
        
    }
    
    
    struct AmericanTrapNRView_Previews: PreviewProvider {
        static var previews: some View {
            AmericanTrapNRView()
                .environmentObject(RoundsDataStack())
        }
    }
    
}
