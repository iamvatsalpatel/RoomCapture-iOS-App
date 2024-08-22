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
    var isScanComplete = false
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
        isScanComplete = true
    }
    
    func saveScan() {
        guard let finalResult = finalResult else {
            print("No scan result to save.")
            return
        }
        
        let fileNameWithExtension = fileName.hasSuffix(".usdz") ? fileName : "\(fileName).usdz"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileNameWithExtension)
        
        let categorizedObjects = categorizeRoomObjects(finalResult.objects)
        
        do {
            try finalResult.export(to: tempURL) // exportOptions: [.parametric, .mesh]
            if let data = try? Data(contentsOf: tempURL) {
                if RoominatorFileManager.shared.saveUSDZFile(data, withName: fileNameWithExtension) {
                    printCategorizedObjects(categorizedObjects)
                } else {
                    print("Failed to save processed scan file.")
                }
            } else {
                print("Failed to process USDZ file.")
            }
        } catch {
            print("Error exporting and saving usdz scan: \(error)")
        }
        
        try? FileManager.default.removeItem(at: tempURL)
    }
    
    
    private func categorizeRoomObjects(_ objects: [CapturedRoom.Object]) -> [String: [CapturedRoom.Object]] {
        var categorized = [String: [CapturedRoom.Object]]()
        
        for object in objects {
            let category: String
            switch object.category {
            case .refrigerator, .oven, .dishwasher, .washerDryer:
                category = "Appliance"
            case .table:
                category = "Table"
            case .bed:
                category = "Bed"
            case .chair, .sofa:
                category = "Seating"
            case .storage:
                category = "Storage"
            case .bathtub, .toilet:
                category = "Bathroom Fixture"
            case .sink:
                category = "Sink"
            case .television:
                category = "Television"
            default:
                category = "Other"
            }
            
            if categorized[category] == nil {
                categorized[category] = []
            }
            categorized[category]?.append(object)
        }
        
        return categorized
    }
    
    private func printCategorizedObjects(_ categorizedObjects: [String: [CapturedRoom.Object]]) {
        print("Categorized objects:")
        for (category, objects) in categorizedObjects {
            print("  \(category): \(objects.count) items")
            for object in objects {
                print("    - \(object.category): \(object.dimensions)")
            }
        }
    }
}


