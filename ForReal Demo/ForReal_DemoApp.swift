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
    @StateObject private var roomCaptureController = RoomCaptureController()
    
    init() {
        _ = RoominatorFileManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(roomCaptureController)
        }
    }
}
