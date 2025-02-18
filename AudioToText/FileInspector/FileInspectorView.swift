//
//  FileInspectorView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 26/01/25.
//

import SwiftUI

struct FileInspectorView: View {
    @ObservedObject var viewModel = FileInspectorViewModel()
    
    @State private var showFileImporter = false
    
//    var onAudiosDirectoryPicked: (_ url: URL) -> Void = { url in
//        print(url)
//    }
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Drag your .mp3 file to start the transcription")
            
            Button(action:{
                showFileImporter = true
            }, label: {
                Text("Browse Files")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .cornerRadius(10)
            }).padding(.horizontal)
                .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.mp3]){
                    result in
                    switch result {
                    case .success(let directory):
                        //gain access to dic
                        let gotAccess = directory.startAccessingSecurityScopedResource()
                        if !gotAccess {return}
                        // access the directory URL
                        viewModel.audioDirectoryPicked(directory)
                        //release access
                        directory.stopAccessingSecurityScopedResource()
                    case .failure(let error):
                        print(error)
                    }
                }
            
        }.padding(.vertical)
    }
}

#Preview {
    FileInspectorView()
}
