//
//  OpeningView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData

struct OpeningRoundsView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        NavigationStack(path: $roundsData.path) {

                TabView (selection: $roundsData.selection) {
                    SelectRange()
                        .tabItem{
                            Image(systemName: "figure.hunting")
                            Text("Range")
                                .font(.title)
                        }
                        .tag(0)
                    FivePosView()
                        .tabItem{
                            Image(systemName: "list.bullet")
                            Text("Rounds")
                        }
                        .tag(1)
                    FivePosView()
                        .tabItem{
                            Image(systemName: "plus.square.fill")
                            Text("New Round")
                        }
                        .tag(2)
                    FivePosView()
                        .tabItem{
                            Image(systemName: "chart.dots.scatter")
                            Text("Stats")
                        }
                        .tag(3)
                    InfoView()
                        .tabItem{
                            Image(systemName: "questionmark.circle")
                            Text("Info")
                        }
                        .tag(4)
                }
                .accentColor(.blue)
            }
        }
//    }

    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)

    }
}



struct OpeningRoundsView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningRoundsView()
            .environmentObject(RoundsDataStack())
    }
}
