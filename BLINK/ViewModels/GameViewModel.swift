//
//  GameViewModel.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SwiftUI
import SceneKit
import Combine

final class GameViewModel: ObservableObject {
    
    // MARK: - SCENE
    let gameScene = GameScene()
    
    // MARK: - BLINK DETECTOR
    let blinkDetector = BlinkDetector()
    
    // MARK: - STATES
    @Published var blinkOpacity = 0.0
    @Published var isMonsterActive = false
    @Published var canKillMonster = false
    @Published var isGameOver = false
    
    // MARK: - SCENE ACCESS
    var scene: SCNScene {
        gameScene.scene
    }
    
    // MARK: - INIT
    init() {
        
        blinkDetector.setupCamera()
        
        blinkDetector.onBlinkDetected = {
            
            DispatchQueue.main.async {
                
                self.playerBlink()
            }
        }
    }
    
    // MARK: - START ENCOUNTER
    func startMonsterEncounter() {
        
        guard !isMonsterActive else { return }
        
        isMonsterActive = true
        
        // RESET MONSTER
        gameScene.monsterNode.position = SCNVector3(
            0,
            1,
            -35
        )
        
        gameScene.monsterNode.scale = SCNVector3(
            1,
            1,
            1
        )
        
        gameScene.monsterNode.opacity = 1
        
        canKillMonster = true
        
        // APPROACH PLAYER
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 4
        
        gameScene.monsterNode.position.z = 3
        
        SCNTransaction.commit()
        
        // FAIL
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            if self.isMonsterActive {
                
                self.triggerGameOver()
            }
        }
    }
    
    // MARK: - PLAYER BLINK
    func playerBlink() {
        
        guard !isGameOver else { return }
        
        // BLINK EFFECT
        withAnimation(.easeInOut(duration: 0.08)) {
            
            blinkOpacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            
            withAnimation(.easeOut(duration: 0.08)) {
                
                self.blinkOpacity = 0
            }
        }
        
        // KILL MONSTER
        if canKillMonster {
            
            killMonster()
        }
    }
    
    // MARK: - KILL MONSTER
    func killMonster() {
        
        canKillMonster = false
        isMonsterActive = false
        
        // DEATH ANIMATION
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 0.2
        
        gameScene.monsterNode.scale = SCNVector3(
            0.01,
            0.01,
            0.01
        )
        
        gameScene.monsterNode.opacity = 0
        
        SCNTransaction.commit()
        
        // SHAKE
        gameScene.cameraShake(
            intensity: 0.08
        )
        
        // NEXT ENCOUNTER
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.startMonsterEncounter()
        }
    }
    
    // MARK: - GAME OVER
    func triggerGameOver() {
        
        isGameOver = true
        
        canKillMonster = false
        isMonsterActive = false
        
        // JUMPSCARE
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 0.15
        
        gameScene.monsterNode.position = SCNVector3(
            0,
            1,
            2
        )
        
        gameScene.monsterNode.scale = SCNVector3(
            4,
            4,
            4
        )
        
        SCNTransaction.commit()
        
        // SHAKE
        gameScene.cameraShake(
            intensity: 0.4
        )
        
        // BLACKOUT
        withAnimation(.easeIn(duration: 0.1)) {
            
            blinkOpacity = 1
        }
    }
    
    // MARK: - RESTART GAME
    func restartGame() {
        
        isGameOver = false
        
        blinkOpacity = 0
        
        isMonsterActive = false
        canKillMonster = false
        
        // RESET MONSTER
        gameScene.monsterNode.position = SCNVector3(
            0,
            1,
            -35
        )
        
        gameScene.monsterNode.scale = SCNVector3(
            1,
            1,
            1
        )
        
        gameScene.monsterNode.opacity = 1
        
        startMonsterEncounter()
    }
    
    // MARK: - AUDIO
    
    func stopMusic() {
        
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0
        ) {
            
            self.gameScene.stopMusic()
        }
    }
}
