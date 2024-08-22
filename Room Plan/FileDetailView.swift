//
//  FileDetailView.swift
//  ForReal Demo
//
//  Created by Vatsal Patel  on 8/17/24.
//

import SwiftUI
import QuickLook
import UIKit

struct NativeQuickLookView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let url: URL
        
        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return url as QLPreviewItem
        }

        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            print("QuickLook view dismissed.")
        }
    }
}

struct FileDetailView: View {
    let fileName: String
    @State private var useARMode = true

    var body: some View {
        VStack {
            if let url = RoominatorFileManager.shared.getUSDZFileURL(for: fileName) {
                NativeQuickLookView(url: url)
                    .if(useARMode) { view in
                        view.edgesIgnoringSafeArea(.all)
                    }
                    .onAppear { print("Opening USDZ file: \(url) in \(useARMode ? "AR" : "Object") mode") }
            } else {
                Text("Unable to load file")
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(fileName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(useARMode ? "Object Mode" : "AR Mode") {
                    useARMode.toggle()
                }
            }
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
