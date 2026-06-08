//
//  HowToPlayView.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI
import Combine

    struct HowToPlayView: View {
    
    var body: some View {
        
        ZStack {
            
            // BACKGROUND
            LinearGradient(
                colors: [
                    .black,
                    Color.red.opacity(0.15),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 25) {
                    
                    // TITLE
                    VStack(spacing: 10) {
                        
                        Text("HOW TO SURVIVE")
                            .font(
                                .system(
                                    size: 42,
                                    weight: .black
                                )
                            )
                            .foregroundColor(.red)
                            .shadow(
                                color: .red,
                                radius: 15
                            )
                        
                        Text("ENTITY SURVIVAL PROTOCOL")
                            .font(.caption)
                            .tracking(5)
                            .foregroundColor(
                                .gray
                            )
                    }
                    .padding(.top, 30)
                    
                    // WARNING CARD
                    
                    infoCard(
                        icon: "⚠️",
                        title: "WARNING",
                        description:
                    """
                    An unidentified hostile entity has been detected.
                    Do not panic.
                    Follow the survival instructions carefully.
                    """
                    )
                    
                    // STEP 1
                    
                    infoCard(
                        icon: "👁️",
                        title: "WATCH THE ENTITY",
                        description:
                    """
                    The entity will appear somewhere in front of you.
                    
                    Stay alert and keep your eyes on it.
                    """
                    )
                    
                    // STEP 2
                    
                    infoCard(
                        icon: "😳",
                        title: "WAIT FOR THE APPROACH",
                        description:
                    """
                    The entity will slowly move closer.
                    
                    Do not blink immediately.
                    Timing is everything.
                    """
                    )
                    
                    // STEP 3
                    
                    infoCard(
                        icon: "😉",
                        title: "BLINK TO SURVIVE",
                        description:
                    """
                    When the entity gets close,
                    blink using your real eyes.
                    
                    Your camera detects the blink
                    and destroys the entity.
                    """
                    )
                    
                    // STEP 4
                    
                    infoCard(
                        icon: "💀",
                        title: "IF YOU FAIL",
                        description:
                    """
                    If the entity reaches you before
                    you blink, you die instantly.
                    
                    There are no second chances.
                    """
                    )
                    
                    // STEP 5
                    
                    infoCard(
                        icon: "📱",
                        title: "CAMERA REQUIRED",
                        description:
                    """
                    BLINK uses real-time blink detection.
                    
                    Make sure your face is visible
                    to the front camera.
                    """
                    )
                    
                    // SURVIVAL TIPS
                    
                    VStack(spacing: 15) {
                        
                        Text("SURVIVAL TIPS")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("• Keep your face visible")
                            
                            Text("• Play in a well-lit room")
                            
                            Text("• Don't spam blink")
                            
                            Text("• Stay calm under pressure")
                            
                            Text("• Trust your instincts")
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white.opacity(0.05)
                    )
                    .cornerRadius(20)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func infoCard(
        icon: String,
        title: String,
        description: String
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            HStack {
                
                Text(icon)
                    .font(.title)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.black)
                    .foregroundColor(.red)
            }
            
            Text(description)
                .foregroundColor(.white)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .padding()
        .frame(maxWidth: .infinity,
               alignment: .leading)
        .background(
            Color.white.opacity(0.05)
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                Color.red.opacity(0.35),
                lineWidth: 1
            )
        )
        .cornerRadius(20)
    }
    
}
