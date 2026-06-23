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
    
    private var encounterID = UUID()
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
        
        let currentEncounter = encounterID
        
        guard !isMonsterActive else {
            return
        }
        
        isMonsterActive = true
        canKillMonster = true
        
        // RESET MONSTER
        
        gameScene.monsterNode.removeAllActions()
        
        gameScene.monsterNode.isHidden = false
        
        gameScene.monsterNode.position = SCNVector3(
            0,
            2,
            -20
        )
        
        gameScene.monsterNode.scale = SCNVector3(
            1,
            1,
            1
        )
        
        gameScene.monsterNode.opacity = 1
        
        // APPROACH PLAYER
        
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 8
        
        gameScene.monsterNode.position = SCNVector3(
            0,
            2,
            1
        )
        
        SCNTransaction.commit()
        
        // FAIL IF PLAYER DOESN'T BLINK
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 8
        ) {
            
            guard currentEncounter == self.encounterID else {
                return
            }
            
            guard self.isMonsterActive else {
                return
            }
            
            self.triggerGameOver()
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
        if canKillMonster && isMonsterActive {
            
            killMonster()
        }
    }
    
    // MARK: - KILL MONSTER
    func killMonster() {
        
        guard isMonsterActive else {
            return
        }
        
        canKillMonster = false
        isMonsterActive = false
        
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = 0.2
        
        gameScene.monsterNode.scale = SCNVector3(
            0.01,
            0.01,
            0.01
        )
        
        gameScene.monsterNode.opacity = 0
        
        SCNTransaction.commit()
        
        gameScene.cameraShake(
            intensity: 0.08
        )
        
        let currentEncounter = encounterID
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {
            
            guard currentEncounter == self.encounterID else {
                return
            }
            
            guard !self.isGameOver else {
                return
            }
            
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
            2,
            1
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
        
        
        
        encounterID = UUID()
        isGameOver = false
        blinkOpacity = 0
        
        isMonsterActive = false
        canKillMonster = false
        
        // STOP ANY OLD ANIMATIONS
        gameScene.monsterNode.removeAllActions()
        
        // RESET MONSTER VISIBILITY
        gameScene.monsterNode.opacity = 1
        
        // RESET SCALE
        gameScene.monsterNode.scale = SCNVector3(
            1,
            1,
            1
        )
        
        // RESET POSITION
        gameScene.monsterNode.position = SCNVector3(
            0,
            2,
            -20
        )
        
        // SMALL DELAY TO LET UI UPDATE
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.1
        ) {
            
            self.startMonsterEncounter()
        }
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
