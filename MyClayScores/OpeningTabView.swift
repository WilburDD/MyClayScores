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
    
    @AppStorage ("storedRange") var storedRange = String()
    
    var body: some View {
        NavigationStack(path: $roundsData.path) {
            TabView (selection: $roundsData.selection) {
                RoundsView()
                    .tabItem{
                        Image(systemName: "list.bullet")
                        Text("Rounds")
                    }
                    .tag(0)
                SelectRange()
                    .tabItem{
                        Image(systemName: "figure.hunting")
                        Text("Range")
                            .font(.title)
                    }
                    .tag(1)
                FivePosNRView()
                    .tabItem{
                        Image(systemName: "plus.square.fill")
                        Text("New Round")
                    }
                    .tag(2)
                Text("Stats View")
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
    
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
        
    }
}



struct OpeningTabView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningTabView()
            .environmentObject(RoundsDataStack())
    }
}
