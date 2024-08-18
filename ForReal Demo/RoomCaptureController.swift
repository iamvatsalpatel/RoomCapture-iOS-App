//
//  RoomCaptureController.swift
//  ForReal Demo
//
//  Created by Vatsal Patel  on 8/17/24.
//

import Foundation
import RoomPlan
import Observation


@Observable
class RoomCaptureController: RoomCaptureViewDelegate, RoomCaptureSessionDelegate, ObservableObject {
    required init?(coder: NSCoder) {
      fatalError("Not needed.")
    }
    
    func encode(with coder: NSCoder) {
      fatalError("Not needed.")
    }
    
    var roomCaptureView: RoomCaptureView
    var showSaveButton = false
    var scanComplete = false
    var showNameInputSheet = false
    var fileName = ""
    
    var sessionConfig: RoomCaptureSession.Configuration
    var finalResult: CapturedRoom?
    
    init() {
        roomCaptureView = RoomCaptureView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        sessionConfig = RoomCaptureSession.Configuration()
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
    }
    
    func startSession() {
        roomCaptureView.captureSession.run(configuration: sessionConfig)
    }
    
    func stopSession() {
        roomCaptureView.captureSession.stop()
    }
    
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResult = processedResult
        showSaveButton = true
        scanComplete = true
    }
    
    func saveScan() {
        guard let finalResult = finalResult else {
            print("No scan result to save.")
            return
        }
        
        let fileNameWithExtension = fileName.hasSuffix(".usdz") ? fileName : "\(fileName).usdz"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileNameWithExtension)
        
        do {
            try finalResult.export(to: tempURL)
            if let data = try? Data(contentsOf: tempURL) {
                if RoominatorFileManager.shared.saveUSDZFile(data, withName: fileNameWithExtension) {
                    print("Scan saved successfully as \(fileNameWithExtension)")
                } else {
                    print("Failed to save scan file.")
                }
            }
        } catch {
            print("Error exporting and saving usdz scan: \(error)")
        }
        
        // Clean up temporary file
        try? FileManager.default.removeItem(at: tempURL)
    }
}
