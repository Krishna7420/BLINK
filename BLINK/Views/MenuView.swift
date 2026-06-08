//
//  MenuView.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI

struct MenuView: View {
    
    @State private var showHowToPlay = false
    @State private var showSettings = false
    @State private var showCredits = false
    @State private var startGame = false
    
    @State private var pulse = false
    
    var body: some View {
        
        NavigationStack {
            
        
        ZStack {
            
            // BACKGROUND
            LinearGradient(
                colors: [
                    Color.black,
                    Color.red.opacity(0.2),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // RED GLOW
            Circle()
                .fill(Color.red.opacity(0.15))
                .frame(width: 350)
                .blur(radius: 90)
                .scaleEffect(pulse ? 1.2 : 0.8)
                .animation(
                    .easeInOut(duration: 3)
                    .repeatForever(),
                    value: pulse
                )
            
            // DARK VIGNETTE
            RadialGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.95)
                ],
                center: .center,
                startRadius: 100,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer()
                
                // TITLE
                VStack(spacing: 10) {
                    
                    Text("BLINK")
                        .font(
                            .system(
                                size: 75,
                                weight: .black
                            )
                        )
                        .foregroundColor(.red)
                        .shadow(color: .red, radius: 20)
                    
                    Text("DON'T LET IT REACH YOU")
                        .foregroundColor(.white.opacity(0.8))
                        .tracking(4)
                        .font(.caption)
                }
                
                Spacer()
                
                // NEW GAME
                
                NavigationLink(
                    destination: GameView(),                    isActive: $startGame
                ) {
                    EmptyView()
                }
                
                menuButton(title: "NEW GAME") {
                    
                    print("BUTTON TAPPED")
                    
                    startGame = true
                    
                }
                
                
                // HOW TO PLAY
                menuButton(
                    title: "HOW TO PLAY"
                ) {
                    
                    showHowToPlay = true
                }
                
                // SETTINGS
                menuButton(
                    title: "SETTINGS"
                ) {
                    
                    showSettings = true
                }
                
                Spacer()
                
                Text("ENTITY DETECTION SYSTEM ACTIVE")
                    .foregroundColor(.red.opacity(0.7))
                    .font(.caption2)
                    .tracking(3)
                    .padding(.bottom, 30)
            }
            
            // SCANLINES
            VStack(spacing: 6) {
                
                ForEach(0..<80, id: \.self) { _ in
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.08))
                        .frame(height: 2)
                }
            }
            .ignoresSafeArea()
            .blendMode(.multiply)
            .allowsHitTesting(false)
        }
  }
        .onAppear {
            
            pulse = true
        }
        
        // SHEETS
        .sheet(isPresented: $showHowToPlay) {
            
           HowToPlayView()
        }
        
        .sheet(isPresented: $showSettings) {
            
            SettingsView()
        }
        
    }
    
    // MENU BUTTON
    func menuButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        
        Button {
            
            action()
            
        } label: {
            
            Text(title)
                .font(.headline)
                .fontWeight(.black)
                .foregroundColor(.white)
                .frame(width: 280, height: 60)
                .background(Color.white.opacity(0.08))
                .overlay {
                    
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color.red.opacity(0.5),
                            lineWidth: 1
                        )
                }
                .cornerRadius(18)
        }
    }
}

#Preview {
    
    NavigationStack {
        
        MenuView()
    }
}
