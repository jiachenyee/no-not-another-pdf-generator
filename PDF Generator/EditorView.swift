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
                        ScrollView {
                            VStack(alignment: .leading) {
                                let attachment = viewModel.document.attachments[attachmentIndex]
                                
                                Section(attachment.type == .text ? "Text" : "Image") {
                                    let text = Binding {
                                        viewModel.document.attachments[attachmentIndex].text ?? ""
                                    } set: { text in
                                        viewModel.document.attachments[attachmentIndex].text = text
                                    }
                                    
                                    HStack {
                                        Text("Header Name")
                                            .font(.callout)
                                        TextField("Column Header Name", text: text)
                                    }
                                }
                                
                                Divider()
                                
                                Section("Font") {
                                    Picker(selection: $viewModel.document.attachments[attachmentIndex].font) {
                                        ForEach(viewModel.fonts) { family in
                                            Text(family.familyName)
                                                .tag(family.id)
                                        }
                                    } label: {
                                        Text("Family")
                                    }
                                    .onChange(of: viewModel.document.attachments[attachmentIndex].font) { newValue in
                                        let family = viewModel.fonts.first(where: { $0.id == attachment.font })!
                                        
                                        viewModel.document.attachments[attachmentIndex].style = family.fonts[0].id
                                    }
                                    
                                    Picker(selection: $viewModel.document.attachments[attachmentIndex].style) {
                                        
                                        let family = viewModel.fonts.first(where: { $0.id == attachment.font })
                                        
                                        ForEach(family!.fonts) { font in
                                            Text(font.humanReadableName)
                                                .tag(font.id)
                                        }
                                    } label: {
                                        Text("Weight")
                                    }
                                    
                                    HStack {
                                        Text("Size")
                                            .font(.callout)
                                        
                                        TextField(value: $viewModel.document.attachments[attachmentIndex].fontSize, formatter: NumberFormatter()) {}
                                        Stepper(value: $viewModel.document.attachments[attachmentIndex].fontSize) {}
                                    }
                                }
                                
                                Divider()
                                
                                Section("Customisation") {
                                    ColorPicker("Text Color", selection: $viewModel.document.attachments[attachmentIndex].textColor)
                                }
                                
                                Divider()
                                
                                Section("Position") {
                                    HStack {
                                        Text("X")
                                            .font(.callout)
                                        
                                        TextField(value: $viewModel.document.attachments[attachmentIndex].rect.origin.x, formatter: NumberFormatter()) {}
                                        Stepper(value: $viewModel.document.attachments[attachmentIndex].rect.origin.x) {}
                                        
                                        Spacer()
                                        
                                        Text("Y")
                                            .font(.callout)
                                        TextField(value: $viewModel.document.attachments[attachmentIndex].rect.origin.y, formatter: NumberFormatter()) {}
                                        Stepper(value: $viewModel.document.attachments[attachmentIndex].rect.origin.y) {}
                                    }
                                }
                                
                                Spacer()
                                
                                Button(role: .destructive) {
                                    
                                } label: {
                                    Label("Delete Object", systemImage: "trash")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        
                        
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
                    let newAttachment = Attachment(type: .text, text: "Text", rect: .init(x: 20, y: 20, width: 100, height: 100), fontSize: 20)
                    viewModel.document.attachments.append(newAttachment)
                    
                    viewModel.selectedAttachment = newAttachment.id
                } label: {
                    Label("Text", systemImage: "character.textbox")
                }
                
                Button {
                    
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
