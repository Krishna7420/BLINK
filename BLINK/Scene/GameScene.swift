//
//  GameScene.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import SceneKit
import UIKit
import AVFoundation

final class GameScene {
    
    var gameMusicPlayer: AVAudioPlayer?
    
    let scene = SCNScene()
    
    let monsterNode = SCNNode()
    let cameraNode = SCNNode()
    let hallwayNode = SCNNode()
    
    init() {
        
        setupEnvironment()
        setupCamera()
        setupCameraBreathing()
        
        setupLighting()
        setupLightning()
        
        setupHallway()
        
        setupMoon()
        setupStars()
        setupBirds()
        
        setupMonster()
        
        setupFog()
        startHallwayMovement()
        playGameMusic()
    }
}

// MARK: - ENVIRONMENT
extension GameScene {
    
    func setupEnvironment() {
        
        scene.background.contents = UIColor(
            red: 0.03,
            green: 0.01,
            blue: 0.05,
            alpha: 1
        )
    }
}

// MARK: - CAMERA
extension GameScene {
    
    func setupCamera() {
        
        let camera = SCNCamera()
        
        camera.zFar = 150
        
        // CINEMATIC EFFECTS
        camera.wantsHDR = true
        camera.bloomIntensity = 1
        camera.bloomThreshold = 0.2
        
        cameraNode.camera = camera
        
        cameraNode.position = SCNVector3(
            0,
            2,
            8
        )
        
        scene.rootNode.addChildNode(cameraNode)
    }
}

// MARK: - CAMERA BREATHING
extension GameScene {
    
    func setupCameraBreathing() {
        
        let moveUp = SCNAction.moveBy(
            x: 0,
            y: 0.08,
            z: 0,
            duration: 2
        )
        
        moveUp.timingMode = .easeInEaseOut
        
        let moveDown = moveUp.reversed()
        
        let breathing = SCNAction.sequence([
            moveUp,
            moveDown
        ])
        
        cameraNode.runAction(
            .repeatForever(breathing)
        )
    }
}

// MARK: - CAMERA SHAKE
extension GameScene {
    
    func cameraShake(intensity: Float) {
        
        let moveLeft = SCNAction.moveBy(
            x: CGFloat(-intensity),
            y: 0,
            z: 0,
            duration: 0.05
        )
        
        let moveRight = SCNAction.moveBy(
            x: CGFloat(intensity),
            y: 0,
            z: 0,
            duration: 0.05
        )
        
        let shake = SCNAction.sequence([
            moveLeft,
            moveRight,
            moveLeft,
            moveRight
        ])
        
        cameraNode.runAction(shake)
    }
}

// MARK: - CAMERA WALK
extension GameScene {
    
    func moveCameraForward() {
        
        let move = SCNAction.moveBy(
            x: 0,
            y: 0,
            z: -2,
            duration: 1.5
        )
        
        move.timingMode = .easeInEaseOut
        
        cameraNode.runAction(move)
    }
}

// MARK: - LIGHTING
extension GameScene {
    
    func setupLighting() {
        
        // AMBIENT LIGHT
        let ambient = SCNLight()
        
        ambient.type = .ambient
        ambient.intensity = 600
        
        let ambientNode = SCNNode()
        
        ambientNode.light = ambient
        
        scene.rootNode.addChildNode(ambientNode)
        
        // MOON LIGHT
        let moonLight = SCNLight()
        
        moonLight.type = .omni
        
        moonLight.color = UIColor(
            red: 0.6,
            green: 0.7,
            blue: 1,
            alpha: 1
        )
        
        moonLight.intensity = 1200
        
        let moonLightNode = SCNNode()
        
        moonLightNode.light = moonLight
        
        moonLightNode.position = SCNVector3(
            0,
            14,
            -35
        )
        
        scene.rootNode.addChildNode(moonLightNode)
    }
}

// MARK: - LIGHTNING
extension GameScene {
    
    func setupLightning() {
        
        let lightning = SCNLight()
        
        lightning.type = .omni
        lightning.intensity = 0
        
        lightning.color = UIColor.white
        
        let lightningNode = SCNNode()
        
        lightningNode.light = lightning
        
        lightningNode.position = SCNVector3(
            0,
            20,
            -20
        )
        
        scene.rootNode.addChildNode(lightningNode)
        
        // FLASH EFFECT
        let flashOn = SCNAction.run { _ in
            
            lightning.intensity = 4000
        }
        
        let flashOff = SCNAction.run { _ in
            
            lightning.intensity = 0
        }
        
        let wait = SCNAction.wait(
            duration: Double.random(in: 4...8)
        )
        
        let lightningSequence = SCNAction.sequence([
            
            wait,
            
            flashOn,
            .wait(duration: 0.08),
            
            flashOff,
            .wait(duration: 0.1),
            
            flashOn,
            .wait(duration: 0.05),
            
            flashOff
        ])
        
        lightningNode.runAction(
            .repeatForever(lightningSequence)
        )
    }
}

    // MARK: - HALLWAY
    extension GameScene {
        
        func setupHallway() {
            
            // MAIN MOVING HALLWAY NODE
            scene.rootNode.addChildNode(hallwayNode)
            
            // FLOOR PANELS
            for i in 0...20 {
                
                let floor = SCNBox(
                    width: 8,
                    height: 0.2,
                    length: 3,
                    chamferRadius: 0
                )
                
                floor.firstMaterial?.diffuse.contents = UIColor(
                    white: 0.08,
                    alpha: 1
                )
                
                let floorNode = SCNNode(geometry: floor)
                
                floorNode.position = SCNVector3(
                    0,
                    -0.1,
                    Float(-i * 3)
                )
                
                hallwayNode.addChildNode(floorNode)
            }
            
            // WALL SEGMENTS
            for i in 0...20 {
                
                // LEFT WALL
                let leftWall = SCNBox(
                    width: 0.4,
                    height: 6,
                    length: 3,
                    chamferRadius: 0
                )
                
                leftWall.firstMaterial?.diffuse.contents = UIColor(
                    white: 0.12,
                    alpha: 1
                )
                
                let leftNode = SCNNode(geometry: leftWall)
                
                leftNode.position = SCNVector3(
                    -4,
                     3,
                     Float(-i * 3)
                )
                
                hallwayNode.addChildNode(leftNode)
                
                // RIGHT WALL
                let rightWall = SCNBox(
                    width: 0.4,
                    height: 6,
                    length: 3,
                    chamferRadius: 0
                )
                
                rightWall.firstMaterial?.diffuse.contents = UIColor(
                    white: 0.12,
                    alpha: 1
                )
                
                let rightNode = SCNNode(geometry: rightWall)
                
                rightNode.position = SCNVector3(
                    4,
                    3,
                    Float(-i * 3)
                )
                
                hallwayNode.addChildNode(rightNode)
                
                // CEILING
                let ceiling = SCNBox(
                    width: 8,
                    height: 0.2,
                    length: 3,
                    chamferRadius: 0
                )
                
                ceiling.firstMaterial?.diffuse.contents = UIColor(
                    white: 0.05,
                    alpha: 1
                )
                
                let ceilingNode = SCNNode(geometry: ceiling)
                
                ceilingNode.position = SCNVector3(
                    0,
                    6,
                    Float(-i * 3)
                )
                
                hallwayNode.addChildNode(ceilingNode)
                
                // SUPPORT BEAMS
                let beam = SCNBox(
                    width: 8,
                    height: 6,
                    length: 0.15,
                    chamferRadius: 0
                )
                
                beam.firstMaterial?.diffuse.contents = UIColor(
                    white: 0.18,
                    alpha: 1
                )
                
                let beamNode = SCNNode(geometry: beam)
                
                beamNode.position = SCNVector3(
                    0,
                    3,
                    Float(-i * 3) - 1.5
                )
                
                beamNode.opacity = 0.25
                
                hallwayNode.addChildNode(beamNode)
                
                // CEILING LIGHTS
                let lightBox = SCNBox(
                    width: 1,
                    height: 0.1,
                    length: 2,
                    chamferRadius: 0
                )
                
                lightBox.firstMaterial?.emission.contents = UIColor(
                    white: 0.7,
                    alpha: 1
                )
                
                let lightNode = SCNNode(geometry: lightBox)
                
                lightNode.position = SCNVector3(
                    0,
                    5.8,
                    Float(-5 - (i * 10))
                )
                
                hallwayNode.addChildNode(lightNode)
                
                // REAL LIGHT
                let light = SCNLight()
                
                light.type = .omni
                light.intensity = 1200
                
                let realLightNode = SCNNode()
                
                realLightNode.light = light
                
                realLightNode.position = SCNVector3(
                    0,
                    5.5,
                    Float(-5 - (i * 10))
                )
                
                hallwayNode.addChildNode(realLightNode)
            }
        }
    }
    
    // MARK: - HALLWAY MOVEMENT
    extension GameScene {
        
        func startHallwayMovement() {
            
            let move = SCNAction.moveBy(
                x: 0,
                y: 0,
                z: 30,
                duration: 6
            )
            
            move.timingMode = .linear
            
            let reset = SCNAction.run { _ in
                
                self.hallwayNode.position.z = 0
            }
            
            let sequence = SCNAction.sequence([
                move,
                reset
            ])
            
            hallwayNode.runAction(
                .repeatForever(sequence)
            )
        }
    }


// MARK: - MOON
extension GameScene {
    
    func setupMoon() {
        
        let moon = SCNSphere(radius: 1.5)
        
        moon.firstMaterial?.emission.contents = UIColor(
            red: 0.8,
            green: 0.2,
            blue: 0.2,
            alpha: 1
        )
        
        let moonNode = SCNNode(geometry: moon)
        
        moonNode.opacity = 0.9
        
        moonNode.position = SCNVector3(
            0,
            14,
            -40
        )
        
        scene.rootNode.addChildNode(moonNode)
    }
}

// MARK: - STARS
extension GameScene {
    
    func setupStars() {
        
        for _ in 0...150 {
            
            let star = SCNSphere(radius: 0.05)
            
            star.firstMaterial?.emission.contents = UIColor.white
            
            star.firstMaterial?.lightingModel = .constant
            
            let starNode = SCNNode(geometry: star)
            
            starNode.position = SCNVector3(
                Float.random(in: -60...60),
                Float.random(in: 10...40),
                Float.random(in: -100 ... -10)
            )
            
            scene.rootNode.addChildNode(starNode)
        }
    }
}

// MARK: - BIRDS
extension GameScene {
    
    func setupBirds() {
        
        for i in 0...5 {
            
            let bird = SCNPlane(
                width: 0.8,
                height: 0.2
            )
            
            bird.firstMaterial?.diffuse.contents = UIColor.black
            
            let birdNode = SCNNode(geometry: bird)
            
            birdNode.position = SCNVector3(
                Float(-10 + i),
                Float(12 + i),
                -30
            )
            
            scene.rootNode.addChildNode(birdNode)
            
            let move = SCNAction.moveBy(
                x: 30,
                y: 0,
                z: 0,
                duration: 20
            )
            
            birdNode.runAction(
                .repeatForever(move)
            )
        }
    }
}

// MARK: - MONSTER
extension GameScene {
        
        func setupMonster() {
            
            // MAIN BODY
            let body = SCNCapsule(
                capRadius: 0.25,
                height: 3.8
            )
            
            body.firstMaterial?.diffuse.contents = UIColor(
                white: 0.02,
                alpha: 1
            )
            
            monsterNode.geometry = body
            
            monsterNode.position = SCNVector3(
                0,
                2,
                -35
            )
            
            scene.rootNode.addChildNode(monsterNode)
            
            // HEAD
            let head = SCNSphere(radius: 0.45)
            
            head.firstMaterial?.diffuse.contents = UIColor.black
            
            let headNode = SCNNode(geometry: head)
            
            headNode.position = SCNVector3(
                0,
                2.1,
                0
            )
            
            // TILT HEAD
            headNode.eulerAngles.z = -.pi / 10
            
            monsterNode.addChildNode(headNode)
            
            // LEFT EYE
            let leftEye = SCNSphere(radius: 0.05)
            
            leftEye.firstMaterial?.emission.contents = UIColor.white
            
            let leftEyeNode = SCNNode(geometry: leftEye)
            
            leftEyeNode.position = SCNVector3(
                -0.12,
                 0.05,
                 0.38
            )
            
            headNode.addChildNode(leftEyeNode)
            
            // RIGHT EYE
            let rightEye = SCNSphere(radius: 0.05)
            
            rightEye.firstMaterial?.emission.contents = UIColor.white
            
            let rightEyeNode = SCNNode(geometry: rightEye)
            
            rightEyeNode.position = SCNVector3(
                0.12,
                0.05,
                0.38
            )
            
            headNode.addChildNode(rightEyeNode)
            
            // LEFT ARM
            let leftArm = SCNCylinder(
                radius: 0.08,
                height: 3
            )
            
            leftArm.firstMaterial?.diffuse.contents = UIColor.black
            
            let leftArmNode = SCNNode(geometry: leftArm)
            
            leftArmNode.position = SCNVector3(
                -0.5,
                 0.3,
                 0
            )
            
            leftArmNode.eulerAngles.z = .pi / 6
            
            monsterNode.addChildNode(leftArmNode)
            
            // RIGHT ARM
            let rightArm = SCNCylinder(
                radius: 0.08,
                height: 3
            )
            
            rightArm.firstMaterial?.diffuse.contents = UIColor.black
            
            let rightArmNode = SCNNode(geometry: rightArm)
            
            rightArmNode.position = SCNVector3(
                0.5,
                0.3,
                0
            )
            
            rightArmNode.eulerAngles.z = -.pi / 6
            
            monsterNode.addChildNode(rightArmNode)
            
            // FLOATING ANIMATION
            let floatUp = SCNAction.moveBy(
                x: 0,
                y: 0.25,
                z: 0,
                duration: 2
            )
            
            floatUp.timingMode = .easeInEaseOut
            
            let floatDown = floatUp.reversed()
            
            let floating = SCNAction.sequence([
                floatUp,
                floatDown
            ])
            
            monsterNode.runAction(
                .repeatForever(floating)
            )
            
            // SLIGHT ROTATION
            let rotateLeft = SCNAction.rotateBy(
                x: 0,
                y: 0.1,
                z: 0,
                duration: 2
            )
            
            let rotateRight = rotateLeft.reversed()
            
            let sway = SCNAction.sequence([
                rotateLeft,
                rotateRight
            ])
            
            monsterNode.runAction(
                .repeatForever(sway)
            )
    }
}

// MARK: - FOG
extension GameScene {
    
    func setupFog() {
        
        scene.fogStartDistance = 25
        scene.fogEndDistance = 60
        
        scene.fogColor = UIColor(
            red: 0.02,
            green: 0.02,
            blue: 0.03,
            alpha: 1
        )
    }
}
// MARK: - AUDIO

extension GameScene {
    
    func playGameMusic() {
        
        guard let url = Bundle.main.url(
            forResource: "GameView",
            withExtension: "mp3"
        ) else {
            
            print("GAME MUSIC NOT FOUND")
            return
        }
        
        do {
            
            gameMusicPlayer = try AVAudioPlayer(
                contentsOf: url
            )
            
            gameMusicPlayer?.numberOfLoops = -1
            
            // Horror ambience volume
            gameMusicPlayer?.volume = 0.22
            
            gameMusicPlayer?.prepareToPlay()
            gameMusicPlayer?.play()
            
        } catch {
            
            print(
                "AUDIO ERROR:",
                error.localizedDescription
            )
        }
    }
    
    func stopMusic() {
        
        gameMusicPlayer?.stop()
        gameMusicPlayer = nil
    }
}


