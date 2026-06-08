//
//  SettingsView.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI

struct SettingsView: View {
   
  
    
    var body: some View {
        
        ZStack {
            
            // MARK: Background
            
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
            
            // Red Glow
            
            Circle()
                .fill(Color.red.opacity(0.15))
                .frame(width: 400)
                .blur(radius: 120)
            
            ScrollView {
                
                VStack(spacing: 25) {
                    
                    // MARK: Title
                    
                    VStack(spacing: 10) {
                        
                        Text("SETTINGS")
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
                        
                        Text("ENTITY CONTROL PANEL")
                            .font(.caption)
                            .tracking(5)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
    
                    
                    // MARK: System Status
                    
                    VStack(spacing: 15) {
                        
                        Text("SYSTEM STATUS")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        statusRow(
                            title: "Blink Detection",
                            value: "ONLINE"
                        )
                        
                        statusRow(
                            title: "Entity Tracking",
                            value: "ACTIVE"
                        )
                        
                        statusRow(
                            title: "Survival Protocol",
                            value: "ENABLED"
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white.opacity(0.05)
                    )
                    .overlay {
                        
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .stroke(
                            Color.red.opacity(0.35),
                            lineWidth: 1
                        )
                    }
                    .cornerRadius(20)
                    
                    // MARK: Version
                    
                    VStack(spacing: 8) {
                        
                        Text("BLINK")
                            .foregroundColor(.red)
                            .fontWeight(.black)
                        
                        Text("Version 1.0")
                            .foregroundColor(.gray)
                        
                        Text("ENTITY DETECTION BUILD")
                            .foregroundColor(.gray.opacity(0.7))
                            .font(.caption2)
                            .tracking(3)
                    }
                    .padding(.top, 10)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
        }
    }
    
    // MARK: Settings Card
    
    func settingsCard(
        icon: String,
        title: String,
        isOn: Binding<Bool>
    ) -> some View {
        
        HStack {
            
            Text(icon)
                .font(.title2)
            
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Spacer()
            
            Toggle(
                "",
                isOn: isOn
            )
            .tint(.red)
        }
        .padding()
        .background(
            Color.white.opacity(0.05)
        )
        .overlay {
            
            RoundedRectangle(
                cornerRadius: 20
            )
            .stroke(
                Color.red.opacity(0.35),
                lineWidth: 1
            )
        }
        .cornerRadius(20)
    }
    
    // MARK: Status Row
    
    func statusRow(
        title: String,
        value: String
    ) -> some View {
        
        HStack {
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.green)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    SettingsView()
}
