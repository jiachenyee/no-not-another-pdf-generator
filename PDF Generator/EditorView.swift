//
//  EditorView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import SwiftUI

struct EditorView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var document: Document
    @State var scale: CGFloat = 1.0

    @State var selectedAttachment: UUID?
    
    @State var isNewItemViewPresented = false
    
    var body: some View {
        GeometryReader { context in
            HSplitStack {
                VStack {
                    HStack {
                        Text("Objects")
                            .font(.headline)
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            isNewItemViewPresented = true
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                        }
                        .popover(isPresented: $isNewItemViewPresented) {
                            List {
                                Button {
                                    let newAttachment = Attachment(type: .text, text: "Text", rect: .init(x: 20, y: 20, width: 100, height: 100), fontSize: 20)
                                    document.attachments.append(newAttachment)
                                    
                                    selectedAttachment = newAttachment.id
                                } label: {
                                    Label("Text", systemImage: "character.textbox")
                                }
                                Button {
                                    
                                } label: {
                                    Label("Image", systemImage: "photo")
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.trailing)
                    }
                    .frame(maxWidth: context.size.width / 3)
                    
                    List(selection: $selectedAttachment) {
                        ForEach(document.attachments) { attachment in
                            VStack {
                                Text(attachment.type == .text ? "Text" : "Image")
                            }
                            .id(attachment.id)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
#if os(iOS)
                Divider()
#endif
                
                HStack {
                    ScrollView([.horizontal, .vertical]) {
                        ZStack {
                            Image(data: document.image)
                                .background(.white)
                                .onTapGesture {
                                    selectedAttachment = nil
                                }
                            
                            ForEach($document.attachments) { $attachment in
                                Button {
                                    selectedAttachment = attachment.id
                                } label: {
                                    switch attachment.type {
                                    case .text:
                                        Text(attachment.text ?? "")
                                            .font(.custom(attachment.style, size: attachment.fontSize))
                                            .foregroundColor(.black)
                                            .border(attachment.id == selectedAttachment ? Color.accentColor : Color.clear)
                                        
                                    case .image:
                                        if let imageURL = attachment.url {
                                            AsyncImage(url: imageURL)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                .position(attachment.rect.origin)
                                .highPriorityGesture(DragGesture().onChanged { value in
                                    selectedAttachment = attachment.id
                                    var finalLocation = value.location
                                    
                                    if finalLocation.x < 0 {
                                        finalLocation.x = 0
                                    }
                                    
                                    if finalLocation.x > document.documentSize.width {
                                        finalLocation.x = document.documentSize.width
                                    }
                                    
                                    if finalLocation.y < 0 {
                                        finalLocation.y = 0
                                    }
                                    
                                    if finalLocation.y > document.documentSize.height {
                                        finalLocation.y = document.documentSize.height
                                    }
                                    
                                    attachment.rect.origin = finalLocation
                                })
                            }
                        }
                    }
                    
                    VStack {
                        if let attachmentIndex = document.attachments.firstIndex(where: {
                            $0.id == selectedAttachment
                        }) {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    let attachment = document.attachments[attachmentIndex]
                                    
                                    Section(attachment.type == .text ? "Text" : "Image") {
                                        let text = Binding {
                                            document.attachments[attachmentIndex].text ?? ""
                                        } set: { text in
                                            document.attachments[attachmentIndex].text = text
                                        }
                                        
                                        HStack {
                                            Text("Header Name")
                                                .font(.callout)
                                            TextField("Column Header Name", text: text)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Section("Font") {
                                        Picker(selection: $document.attachments[attachmentIndex].font) {
                                            ForEach(viewModel.fonts) { family in
                                                Text(family.familyName)
                                                    .tag(family.id)
                                            }
                                        } label: {
                                            Text("Family")
                                        }
                                        .onChange(of: document.attachments[attachmentIndex].font) { newValue in
                                            let family = viewModel.fonts.first(where: { $0.id == attachment.font })!
                                            
                                            document.attachments[attachmentIndex].style = family.fonts[0].id
                                        }
                                        
                                        Picker(selection: $document.attachments[attachmentIndex].style) {
                                            
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
                                            
                                            TextField(value: $document.attachments[attachmentIndex].fontSize, formatter: NumberFormatter()) {}
                                            Stepper(value: $document.attachments[attachmentIndex].fontSize) {}
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    Section("Position") {
                                        HStack {
                                            Text("X")
                                                .font(.callout)
                                            
                                            TextField(value: $document.attachments[attachmentIndex].rect.origin.x, formatter: NumberFormatter()) {}
                                            Stepper(value: $document.attachments[attachmentIndex].rect.origin.x) {}
                                            
                                            Spacer()
                                            
                                            Text("Y")
                                                .font(.callout)
                                            TextField(value: $document.attachments[attachmentIndex].rect.origin.y, formatter: NumberFormatter()) {}
                                            Stepper(value: $document.attachments[attachmentIndex].rect.origin.y) {}
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
        }
        .navigationTitle(document.name)
        .toolbar {
#if os(macOS)
            ToolbarItemGroup(placement: .navigation) {
                Button {
                    NSWorkspace.shared.activateFileViewerSelecting([document.imageURL])
                } label: {
                    Label("Show in Finder", systemImage: "doc")
                }
            }
#endif
            
            ToolbarItemGroup(placement: .principal) {
                Button {
                    let newAttachment = Attachment(type: .text, text: "Text", rect: .init(x: 20, y: 20, width: 100, height: 100), fontSize: 20)
                    document.attachments.append(newAttachment)
                    
                    selectedAttachment = newAttachment.id
                } label: {
                    Label("Text", systemImage: "character.textbox")
                }
                
                Button {
                    
                } label: {
                    Label("Image", systemImage: "photo")
                }
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(viewModel: .init(), document: .constant(.init(name: "Potato", image: .init(), imageURL: URL(string: "https://tk.sg")!, attachments: [])))
    }
}
