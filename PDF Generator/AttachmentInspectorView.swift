//
//  AttachmentInspectorView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 28/8/22.
//

import SwiftUI

struct AttachmentInspectorView: View {
    
    @ObservedObject var viewModel: ViewModel
    var attachmentIndex: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                let attachment = viewModel.document.attachments[attachmentIndex]
                
                Section(attachment.type == .text ? "Text" : "Image") {
                    let text = Binding {
                        viewModel.document.attachments[attachmentIndex].text
                    } set: { text in
                        viewModel.document.attachments[attachmentIndex].text = text
                    }
                    
                    HStack {
                        Text(attachment.type == .text ? "Header Name" : "Image Name")
                            .font(.callout)
                        TextField("Column Header Name", text: text)
                    }
                }
                
                Divider()
                
                if attachment.type == .text {
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
                }
                
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
    }
}

struct AttachmentInspectorView_Previews: PreviewProvider {
    static var previews: some View {
        AttachmentInspectorView(viewModel: .init(), attachmentIndex: 0)
    }
}
