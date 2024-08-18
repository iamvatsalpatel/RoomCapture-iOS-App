//
//  FileManager.swift
//  ForReal Demo
//
//  Created by Vatsal Patel  on 8/17/24.
//

import Foundation

class RoominatorFileManager {
    static let shared = RoominatorFileManager()
    
    private init() {
        createRoominatorFolder()
    }
    
    private let folderName = "RoominatorScans"
    
    private var roominatorFolderURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(folderName)
    }
    
    private func createRoominatorFolder() {
        guard let folderURL = roominatorFolderURL else {
            print("Unable to access documents directory")
            return
        }
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                print("Roominator folder created successfully")
            } catch {
                print("Error creating Roominator folder: \(error)")
            }
        } else {
            print("Roominator folder already exists")
        }
    }
    
    func saveUSDZFile(_ data: Data, withName fileName: String) -> Bool {
        guard let folderURL = roominatorFolderURL else {
            print("Unable to access Roominator folder")
            return false
        }
        
        let fileNameWithExtension = fileName.hasSuffix(".usdz") ? fileName : "\(fileName).usdz"
        let fileURL = folderURL.appendingPathComponent(fileNameWithExtension)
        
        do {
            try data.write(to: fileURL)
            print("File saved successfully: \(fileNameWithExtension)")
            return true
        } catch {
            print("Error saving file: \(error)")
            return false
        }
    }
    
    func getUSDZFileURL(for fileName: String) -> URL? {
        guard let folderURL = roominatorFolderURL else { return nil }
        let fileNameWithExtension = fileName.hasSuffix(".usdz") ? fileName : "\(fileName).usdz"
        return folderURL.appendingPathComponent(fileNameWithExtension)
    }
    
    func listFiles() -> [String] {
        guard let folderURL = roominatorFolderURL else {
            print("Unable to access Roominator folder")
            return []
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            return fileURLs.map { $0.lastPathComponent }.filter { $0.hasSuffix(".usdz") }
        } catch {
            print("Error listing files: \(error)")
            return []
        }
    }
    
    func deleteFile(named fileName: String) -> Bool {
        guard let fileURL = getUSDZFileURL(for: fileName) else {
            print("Unable to locate file: \(fileName)")
            return false
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("File deleted successfully: \(fileName)")
            return true
        } catch {
            print("Error deleting file: \(error)")
            return false
        }
    }
}
