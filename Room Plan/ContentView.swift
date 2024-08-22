//
//  ContentView.swift
//  ForReal Demo
//
//  Created by Vatsal Patel  on 8/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var files: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(files, id: \.self) { file in
                        NavigationLink(destination: FileDetailView(fileName: file)) {
                            Text(file)
                        }
                    }
                    .onDelete(perform: deleteFiles)
                }
                
                if files.isEmpty {
                    VStack {
                        Image("roomImage3")
                            .resizable()
                            .frame(width: 250, height: 250)
                        Text("You have no existing scans")
                        Text("Make a new scan!")
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 120)
                }
            }
            .navigationTitle("Room Scans")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ScanNewRoomView()) {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                refreshFileList()
            }
        }
    }
    
    private func refreshFileList() {
        files = RoominatorFileManager.shared.listFiles()
    }
    
    private func deleteFiles(at offsets: IndexSet) {
        for index in offsets {
            let fileName = files[index]
            if RoominatorFileManager.shared.deleteFile(named: fileName) {
                files.remove(at: index)
            }
        }
    }
}

#Preview {
    ContentView()
}
