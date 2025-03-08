//
//  FileInspectorView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 26/01/25.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 6)
            .padding(.horizontal, 25)
            .background(.grayLight)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    
    var foreground = Color.white
    var background = Color.blueAccent
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .foregroundStyle(.white)
            .background(isEnabled ? background : background.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct FileInspectorView: View {
    
    @State private var hasSelectedFile: Bool = false
    
    var body: some View {
        VStack{
            HStack(spacing: 2){
                Image(systemName: "music.note.list")
                    .font(.title)
                
                Text("New Transcription")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
            
            if hasSelectedFile {
                AudioFileCell(hasSelectedFile: $hasSelectedFile)
            } else {
                SelectFilesSection(hasSelectedFile: $hasSelectedFile)
                Text("Only .mp3 files. 800kb file size.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
            }
            
            Group {
                Button(action: {print("star transcript")}){
                    Text("Start Transcript")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.vertical, 20)
                .disabled(!hasSelectedFile)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .frame(width: 520)
    }
}

#Preview {
    FileInspectorView().preferredColorScheme(.light)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
        .background(Color.backgroundLight)
}

struct SelectFilesSection: View {
    
    @ObservedObject var viewModel = FileInspectorViewModel()
    
    @State private var showFileInspector: Bool = false
    
    @State private var selectedFileURL: URL? = nil
    @Binding var hasSelectedFile: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    .grayLight,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .square,
                        lineJoin: .miter,
                        miterLimit: 0,
                        dash: [1,6],
                        dashPhase: 0
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 280)
            
            VStack(spacing: 10){
                Image(systemName: "arrow.up.doc.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.blueAccent)
                
                Text("Drag & drop your audio file here or")
                    .padding(.bottom, 26)
                
                Button(
                    action: {
                        showFileInspector = true
                    }){
                    Text("Choose files")
                }
                .buttonStyle(SecondaryButtonStyle())
                .fileImporter(
                    isPresented: $showFileInspector,
                    allowedContentTypes: [.mp3]){ result in
                        switch result {
                        case .success(let directory):
                            //Gain access to directory
                            let gotAccess = directory.startAccessingSecurityScopedResource()
                            if !gotAccess { return }
                            //Access the directory URL
                            print(directory)
                            viewModel.audioDirectoryPicked(directory)
                            
                            if let validFile = viewModel.selectedFileURL {
                                selectedFileURL = validFile
                                hasSelectedFile = true
                            }
                            
                            directory.stopAccessingSecurityScopedResource()
                        case .failure(let error):
                            print(error)
                        }
                    }
                
            }
            
        }
    }
}

struct AudioFileCell: View {
    
    @Binding var hasSelectedFile: Bool
    
    var body: some View {
        HStack(spacing: 0){
            Image(systemName: "music.note")
                .font(.system(size: 24))
                .padding(.horizontal, 24)
            
            VStack(alignment: .leading, spacing: 6){
                Text("Podcast ep.102 - French")
                
                Text("MP3 - 20GB")
                    .foregroundStyle(.gray)
                
            }.padding(.vertical, 16)
            
            Spacer()
            
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .padding(.trailing, 26)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
                .onTapGesture {
                    hasSelectedFile = false
                }
        }
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.grayLight, lineWidth: 1)
        }
    }
}
