//
//  ForReal_DemoApp.swift
//  ForReal Demo
//
//  Created by Vatsal Patel  on 8/18/24.
//

import SwiftUI
import SwiftData
import RoomPlan

@main
struct ForReal_DemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var roomCaptureController = RoomCaptureController()
    
    init() {
        // This will create the folder if it doesn't exist
        _ = RoominatorFileManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(roomCaptureController)
        }
    }
}
