//
//  OpeningView.swift
//  MyClayScores
//
//  Created by Doxie Davis on 6/23/23.
//

import SwiftUI
import CoreData

struct OpeningTabView: View {
    
    @EnvironmentObject var roundsData: RoundsDataStack
    
    var body: some View {
        NavigationStack(path: $roundsData.path) {
            TabView (selection: $roundsData.selection) {
                AllRoundsView()
                    .tabItem{
                        Image(systemName: "list.bullet")
                        Text("Rounds")
                    }
                    .tag(0)

                GraphView()
                    .tabItem{
                        Image(systemName: "chart.xyaxis.line")
                        Text("Graphs")
                    }
                    .tag(1)
                GetPositionView()
                    .tabItem{
                        Image(systemName: "plus.square.fill")
                        Text("New Round")
                    }
                    .tag(2)
                ScoringInfoView()
                    .tabItem{
                        Image(systemName: "questionmark.circle")
                        Text("Info")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
        }
    }
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
    }
}


struct OpeningTabView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningTabView()
    }
}
