//
//  BlinkDetector.swift
//  BLINK
//
//  Created by Shrikrishna Thodsare on 28/05/26.
//

import Foundation
import AVFoundation
import Vision

final class BlinkDetector: NSObject {
    
    // MARK: - CAMERA SESSION
    let session = AVCaptureSession()
    
    
    
    // MARK: - CALLBACK
    var onBlinkDetected: (() -> Void)?
    
    
    
    // MARK: - BLINK PROTECTION
    private var lastBlinkTime = Date()
    
    
    
    // MARK: - SETUP CAMERA
    func setupCamera() {
        
        session.beginConfiguration()
        
        session.sessionPreset = .medium
        
        guard let camera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else {
            
            print("Front camera not found")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(input) {
                
                session.addInput(input)
            }
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        let output = AVCaptureVideoDataOutput()
        
        output.alwaysDiscardsLateVideoFrames = true
        
        output.setSampleBufferDelegate(
            self,
            queue: DispatchQueue(label: "cameraQueue")
        )
        
        if session.canAddOutput(output) {
            
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        
        // START CAMERA ON BACKGROUND THREAD
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.session.startRunning()
        }
    }
    
    // MARK: - DETECT BLINK
    func detectBlink(face: VNFaceObservation) {
        
        guard let leftEye = face.landmarks?.leftEye,
              let rightEye = face.landmarks?.rightEye
        else {
            return
        }
        
        let leftClosed = eyeClosed(eye: leftEye)
        let rightClosed = eyeClosed(eye: rightEye)
        
        // BOTH EYES CLOSED
        if leftClosed && rightClosed {
            
            let now = Date()
            
            // PREVENT SPAM BLINKS
            if now.timeIntervalSince(lastBlinkTime) > 0.7 {
                
                lastBlinkTime = now
                
                DispatchQueue.main.async {
                    
                    self.onBlinkDetected?()
                }
            }
        }
    }
    
    // MARK: - CHECK EYE OPENNESS
    func eyeClosed(
        eye: VNFaceLandmarkRegion2D
    ) -> Bool {
        
        let points = eye.normalizedPoints
        
        guard points.count > 5 else {
            return false
        }
        
        let top = points[1]
        let bottom = points[5]
        
        let distance = abs(top.y - bottom.y)
        
        return distance < 0.015
    }
}

// MARK: - CAMERA OUTPUT
extension BlinkDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        
        guard let pixelBuffer =
                CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return
        }
        
        let request = VNDetectFaceLandmarksRequest {
            
            request, error in
            
            if let error = error {
                
                print(error.localizedDescription)
                return
            }
            
            guard let results =
                    request.results as? [VNFaceObservation]
            else {
                return
            }
            
            guard let face = results.first else {
                return
            }
            
            self.detectBlink(face: face)
        }
        
        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .leftMirrored,
            options: [:]
        )
        
        do {
            
            try handler.perform([request])
            
        } catch {
            
            print(error.localizedDescription)
        }
    }
}
