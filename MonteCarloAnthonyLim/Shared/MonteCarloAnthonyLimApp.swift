//
//  MonteCarloAnthonyLimApp.swift
//  Shared
//
//  Created by Anthony Lim on 2/20/21.
//


import SwiftUI

@main
struct MonteCarloAnthonyLimApp: App {
    
    @StateObject var plotDataModel = PlotDataClass(fromLine: true)
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(plotDataModel)
                    .tabItem {
                        Text("Plot")
                    }
                TextView()
                    .environmentObject(plotDataModel)
                    .tabItem {
                        Text("Text")
                    }
                            
                            
            }
            
        }
    }


}

