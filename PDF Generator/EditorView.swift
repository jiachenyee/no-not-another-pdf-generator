//
//  EditorView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var isExportPresented = false
    
    var body: some View {
        HSplitStack {
            ObjectListView(document: $viewModel.document, selectedAttachment: $viewModel.selectedAttachment)
            
#if os(iOS)
            Divider()
#endif
            
            HStack {
                CanvasView(viewModel: viewModel)
                
                VStack {
                    if let attachmentIndex = viewModel.document.attachments.firstIndex(where: {
                        $0.id == viewModel.selectedAttachment
                    }) {
                        AttachmentInspectorView(viewModel: viewModel, attachmentIndex: attachmentIndex)
                        
                    } else {
                        
                        Spacer()
                        
                        Text("Nothing selected.")
                            .font(.headline)
                        Text("Select on an object to customise")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                }
                .frame(width: 256)
                .padding()
                .background(Color.primary.opacity(0.1), ignoresSafeAreaEdges: .all)
            }
        }
        .navigationTitle(viewModel.document.name)
        .toolbar {
#if os(macOS)
            ToolbarItemGroup(placement: .navigation) {
                Button {
                    NSWorkspace.shared.activateFileViewerSelecting([viewModel.document.imageURL])
                } label: {
                    Label("Show in Finder", systemImage: "doc")
                }
            }
#endif
            
            ToolbarItemGroup(placement: .principal) {
                Button {
                    let newAttachment = Attachment(type: .text, text: "", rect: .init(x: 20, y: 20, width: 100, height: 100), fontSize: 20)
                    viewModel.document.attachments.append(newAttachment)
                    
                    viewModel.selectedAttachment = newAttachment.id
                } label: {
                    Label("Text", systemImage: "character.textbox")
                }
                
                Button {
                    let newAttachment = Attachment(type: .image, text: "", rect: .init(x: 20, y: 20, width: 100, height: 100), fontSize: 20)
                    viewModel.document.attachments.append(newAttachment)
                    
                    viewModel.selectedAttachment = newAttachment.id
                } label: {
                    Label("Image", systemImage: "photo")
                }
                
                Button {
                    isExportPresented.toggle()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .sheet(isPresented: $isExportPresented) {
                    ExportView(viewModel: viewModel)
                }
            }
        }
        
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(viewModel: .init())
    }
}
