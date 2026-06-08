//
//  BLINKApp.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI

@main
struct BLINKApp: App {
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        
        WindowGroup {
            
            NavigationStack {
                
                if appState.showSplash {
                    
                    SplashView()
                        .environmentObject(appState)
                    
                } else {
                    
                    MenuView()
                        .environmentObject(appState)
                }
            }
        }
    }
}
