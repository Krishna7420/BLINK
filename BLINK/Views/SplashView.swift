//
//  Untitled.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct SplashView: View {
    
    // MARK: States
    @EnvironmentObject var appState: AppState
    @State private var showEyes = false
    @State private var showGhost = false
    @State private var jumpscare = false
    @State private var showLogo = false
    @State private var logoOpacity = 0.0
    @State private var screenFlash = false
    @State private var screenShake = false
    @State private var backgroundScale: CGFloat = 1.0
    @State private var ghostScale: CGFloat = 0.8
    @State private var ghostOffset: CGFloat = 200
    @State private var eyesOpacity = 0
    @State private var glitch = false
    @State private var blurAmount: CGFloat = 0
    
    // MARK: Audio
    
    @State private var ambientPlayer: AVAudioPlayer?
    @State private var boomPlayer: AVAudioPlayer?
    
    var body: some View {
        
        ZStack {
            
            // MARK: Background
            
            Color.black
                .ignoresSafeArea()
            
            // MARK: Fog
            
            Image("fog")
                .resizable()
                .scaledToFill()
                .opacity(0.18)
                .blur(radius: 20)
                .scaleEffect(backgroundScale)
                .ignoresSafeArea()
            
            // MARK: VHS Noise
            
            Image("noise")
                .resizable()
                .scaledToFill()
                .opacity(glitch ? 0.16 : 0.08)
                .blendMode(.screen)
                .ignoresSafeArea()
            
            // MARK: Eyes
            
            if showEyes {
                
                Image("eyes")
                    .resizable()
                    .scaledToFit()
                    .frame(width: jumpscare ? 500 : 170)
                    .opacity(Double(eyesOpacity))
                    .shadow(color: .red, radius: 20)
                    .scaleEffect(jumpscare ? 2.8 : 1)
                    .offset(y: jumpscare ? -40 : -10)
                    .animation(
                        .easeInOut(duration: 1.8),
                        value: eyesOpacity
                    )
                    .animation(
                        .spring(
                            response: 0.25,
                            dampingFraction: 0.45
                        ),
                        value: jumpscare
                    )
            }
            
            // MARK: Ghost
            
            if showGhost {
                
                Image("ghost")
                    .resizable()
                    .scaledToFit()
                    .frame(width: jumpscare ? 900 : 320)
                    .scaleEffect(ghostScale)
                    .offset(y: ghostOffset)
                    .blur(radius: blurAmount)
                    .rotationEffect(
                        .degrees(glitch ? -2 : 2)
                    )
                    .opacity(jumpscare ? 1 : 0.92)
                    .modifier(
                        ShakeEffect(
                            animatableData: CGFloat(
                                screenShake ? 1 : 0
                            )
                        )
                    )
                    .animation(
                        .easeInOut(duration: 2.2),
                        value: ghostOffset
                    )
                    .animation(
                        .easeInOut(duration: 2.2),
                        value: ghostScale
                    )
                    .animation(
                        .spring(
                            response: 0.22,
                            dampingFraction: 0.42
                        ),
                        value: jumpscare
                    )
            }
            
            // MARK: Flash
            
            if screenFlash {
                
                Color.white
                    .ignoresSafeArea()
                    .opacity(0.92)
                    .blendMode(.screen)
            }
            
            // MARK: HORROR LOGO
            
            if showLogo {
                
                ZStack {
                    
                    // MASSIVE RED HELL GLOW
                    
                    Circle()
                        .fill(Color.red.opacity(0.45))
                        .frame(width: 420, height: 420)
                        .blur(radius: 100)
                        .scaleEffect(glitch ? 1.12 : 1)
                    
                    // BLACK SMOKE
                    
                    Image("fog")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420)
                        .opacity(0.28)
                        .blur(radius: 18)
                        .scaleEffect(glitch ? 1.04 : 1)
                    
                    // MAIN BACKGROUND
                    
                    ZStack {
                        
                        // DEMONIC BASE
                        
                        UnevenRoundedRectangle(
                            cornerRadii: .init(
                                topLeading: 18,
                                bottomLeading: 44,
                                bottomTrailing: 14,
                                topTrailing: 36
                            )
                        )
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(
                                        red: 0.28,
                                        green: 0,
                                        blue: 0
                                    ),
                                    Color.black,
                                    Color(
                                        red: 0.08,
                                        green: 0,
                                        blue: 0
                                    )
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 280
                            )
                        )
                        .overlay {
                            
                            UnevenRoundedRectangle(
                                cornerRadii: .init(
                                    topLeading: 18,
                                    bottomLeading: 44,
                                    bottomTrailing: 14,
                                    topTrailing: 36
                                )
                            )
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.red.opacity(1),
                                        Color.orange.opacity(0.7),
                                        Color.black
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2.2
                            )
                            .blur(radius: 0.8)
                        }
                        .frame(width: 340, height: 150)
                        
                        // FIRE GLOW
                        
                        RoundedRectangle(cornerRadius: 32)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.red.opacity(0.45),
                                        Color.clear,
                                        Color.red.opacity(0.18)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 300, height: 120)
                            .blur(radius: 18)
                            .blendMode(.plusLighter)
                        
                        // SMOKE INSIDE
                        
                        Image("fog")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 340, height: 150)
                            .opacity(0.42)
                            .blur(radius: 10)
                            .blendMode(.screen)
                            .clipShape(
                                UnevenRoundedRectangle(
                                    cornerRadii: .init(
                                        topLeading: 18,
                                        bottomLeading: 44,
                                        bottomTrailing: 14,
                                        topTrailing: 36
                                    )
                                )
                            )
                        
                        // HELL ENERGY
                        
                        LinearGradient(
                            colors: [
                                .clear,
                                .red.opacity(0.55),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: 80, height: 200)
                        .blur(radius: 25)
                        .rotationEffect(.degrees(12))
                        .offset(x: -70)
                        
                        // BLOOD SCRATCH
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .red,
                                        .orange,
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 5, height: 130)
                            .blur(radius: 1.5)
                            .rotationEffect(.degrees(8))
                            .offset(x: -105)
                        
                        // STATIC CUT
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.22))
                            .frame(width: 2, height: 100)
                            .blur(radius: 1)
                            .rotationEffect(.degrees(-5))
                            .offset(x: 95)
                    }
                    .frame(width: 340, height: 150)
                    .shadow(
                        color: .red.opacity(
                            glitch ? 1 : 0.65
                        ),
                        radius: glitch ? 65 : 30
                    )
                    .shadow(
                        color: .orange.opacity(0.35),
                        radius: 18
                    )
                    .rotationEffect(
                        .degrees(glitch ? -1.5 : 0)
                    )
                    .scaleEffect(glitch ? 1.03 : 1)
                    .blur(radius: glitch ? 1 : 0)
                    
                    // TEXT
                    
                    VStack(spacing: 10) {
                        
                        Text("BLINK")
                            .font(
                                .system(
                                    size: 66,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white,
                                        .red,
                                        Color.red.opacity(0.55)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .tracking(5)
                            .shadow(
                                color: .red,
                                radius: 35
                            )
                            .shadow(
                                color: .black,
                                radius: 8
                            )
                            .blur(
                                radius: glitch ? 0.8 : 0
                            )
                            .scaleEffect(
                                glitch ? 1.08 : 1
                            )
                            .offset(
                                x: glitch ? -3 : 0,
                                y: glitch ? 2 : 0
                            )
                        
                        Text("DON'T BLINK")
                            .font(.caption2)
                            .tracking(10)
                            .foregroundColor(
                                .gray.opacity(0.7)
                            )
                    }
                }
                .transition(
                    .opacity
                        .combined(
                            with: .scale(scale: 1.4)
                        )
                )
            }
        }
        .onAppear {
            
            // PLAY AMBIENT SOUND ONCE
            
            playSound(
                name: "ambient",
                player: &ambientPlayer
            )
            
            ambientPlayer?.volume = 0.45
            
            startAnimationSequence()
        }
    }
    
    // MARK: Animation Sequence
    
    func startAnimationSequence() {
        
        // BACKGROUND ZOOM
        
        withAnimation(
            .easeInOut(duration: 6)
        ) {
            backgroundScale = 1.15
        }
        
        // EYES
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.2
        ) {
            
            showEyes = true
            
            withAnimation(
                .easeInOut(duration: 1.6)
            ) {
                eyesOpacity = 1
            }
        }
        
        // GHOST APPEAR
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.7
        ) {
            
            showGhost = true
            
            withAnimation(
                .easeInOut(duration: 1.65)
            ) {
                ghostOffset = 40
                ghostScale = 1.08
                blurAmount = 1
            }
        }
        
        // GLITCH
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 3.8
        ) {
            glitch.toggle()
        }
        
        // JUMPSCARE
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5.35
        ) {
            
            // HAPTICS
            
            UIImpactFeedbackGenerator(
                style: .heavy
            )
            .impactOccurred()
            
            AudioServicesPlaySystemSound(
                kSystemSoundID_Vibrate
            )
            
            // PLAY AUDIO
            
            playSound(
                name: "Splash",
                player: &boomPlayer
            )
            
            // SLOW HORROR AUDIO
            
            boomPlayer?.enableRate = true
            boomPlayer?.rate = 0.92
            boomPlayer?.volume = 1.0
            
            // FLASH
            
            screenFlash = true
            screenShake = true
            jumpscare = true
            
            // GHOST ATTACK
            
            withAnimation(
                .spring(
                    response: 0.14,
                    dampingFraction: 0.38
                )
            ) {
                ghostScale = 3.2
                ghostOffset = -180
                blurAmount = 0
            }
            
            // REMOVE FLASH
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.12
            ) {
                screenFlash = false
            }
        }
        
        // LOGO REVEAL
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5.9
        ) {
            
            showLogo = true
            
            withAnimation(
                .easeInOut(duration: 1.0)
            ) {
                logoOpacity = 1
            }
        }
        
        // MOVE TO MENU VIEW 😈
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 11.5
        ) {
            
            // FADE OUT AMBIENT AUDIO
            
            fadeOutAmbient()
            
            // MOVE TO MENU
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.5
            ) {
                
                withAnimation(
                    .easeInOut(duration: 2.0)
                ) {
                    appState.showSplash = false
                }
            }
        }
    }
    
    // MARK: Play Sound
    
    func playSound(
        name: String,
        player: inout AVAudioPlayer?
    ) {
        
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: "mp3"
        ) else {
            
            print("SOUND NOT FOUND:", name)
            return
        }
        
        do {
            
            player = try AVAudioPlayer(
                contentsOf: url
            )
            
            player?.prepareToPlay()
            player?.play()
            
        } catch {
            
            print(
                "ERROR:",
                error.localizedDescription
            )
        }
    }
    func fadeOutAmbient() {
        
        Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { timer in
            
            if let player = ambientPlayer {
                
                if player.volume > 0.05 {
                    
                    player.volume -= 0.02
                    
                } else {
                    
                    player.stop()
                    timer.invalidate()
                }
            }
        }
    }
}

// MARK: Screen Shake

struct ShakeEffect: GeometryEffect {
    
    var amount: CGFloat = 20
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(
        size: CGSize
    ) -> ProjectionTransform {
        
        ProjectionTransform(
            CGAffineTransform(
                translationX:
                    amount * sin(
                        animatableData *
                            .pi *
                        CGFloat(shakesPerUnit)
                    ),
                y: 0
            )
        )
    }
}

#Preview {
    SplashView()
}
