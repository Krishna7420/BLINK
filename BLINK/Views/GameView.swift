//
//  Gameview.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI
import SceneKit

struct GameView: View {
    
    @StateObject var vm = GameViewModel()
    
    var body: some View {
        
        ZStack {
            
            // MARK: - GAME WORLD
            
            SceneView(
                scene: vm.scene,
                options: []
            )
            .ignoresSafeArea()
            .onAppear {
                
                print("GAME VIEW APPEARED")
                
                vm.startMonsterEncounter()
            }
            .onDisappear {
                
                print("GAME VIEW DISAPPEARED")
                
                vm.stopMusic()
            }
            
            // MARK: - DARK VIGNETTE
            
            RadialGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.9)
                ],
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            // MARK: - BLINK FLASH
            
            BlinkOverlayView(
                opacity: vm.blinkOpacity
            )
            
            // MARK: - TOP HUD
            
            VStack {
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("SUBJECT")
                            .foregroundColor(.red)
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text("BLINK TEST")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.black)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        Text("STATUS")
                            .foregroundColor(.red)
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text(
                            vm.isMonsterActive
                            ? "ENTITY DETECTED"
                            : "CLEAR"
                        )
                        .foregroundColor(
                            vm.isMonsterActive
                            ? .red
                            : .green
                        )
                        .font(.headline)
                        .fontWeight(.black)
                    }
                }
                .padding()
                
                Spacer()
            }
            
            // MARK: - WARNING
            
            if vm.isMonsterActive && !vm.isGameOver {
                
                VStack {
                    
                    Spacer()
                    
                    Text("BLINK TO SURVIVE")
                        .foregroundColor(.red)
                        .font(
                            .system(
                                size: 32,
                                weight: .black
                            )
                        )
                        .shadow(
                            color: .red,
                            radius: 10
                        )
                        .padding(.bottom, 120)
                }
            }
            
            // MARK: - GAME OVER
            
            if vm.isGameOver {
                
                ZStack {
                    
                    Color.black
                        .opacity(0.75)
                        .ignoresSafeArea()
                    
                    Color.red
                        .opacity(0.15)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 25) {
                        
                        Text("YOU DIED")
                            .font(
                                .system(
                                    size: 60,
                                    weight: .black
                                )
                            )
                            .foregroundColor(.red)
                            .shadow(
                                color: .red,
                                radius: 20
                            )
                        
                        Text("THE ENTITY CONSUMED YOU")
                            .foregroundColor(.white)
                            .font(.headline)
                            .tracking(3)
                        
                        Button {
                            
                            print("RESTART PRESSED")
                            
                            vm.restartGame()
                            
                        } label: {
                            
                            Text("RESTART")
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                .frame(
                                    width: 220,
                                    height: 60
                                )
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(radius: 10)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            
            // MARK: - SCANLINES
            
            VStack(spacing: 6) {
                
                ForEach(
                    0..<80,
                    id: \.self
                ) { _ in
                    
                    Rectangle()
                        .fill(
                            Color.black.opacity(0.08)
                        )
                        .frame(height: 2)
                }
            }
            .ignoresSafeArea()
            .blendMode(.multiply)
            .allowsHitTesting(false)
        }

    }
}

#Preview {
    
    GameView()
}
