//
//  ObjectInspector.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import SwiftUI

struct ObjectInspector: View {
    
    @StateObject var viewModel: ViewModel
    @Binding var selectedAttachment: Attachment?
    
    var body: some View {
        VStack {
            if let selectedAttachment {
                ScrollView {
                    VStack(alignment: .leading) {
                        Section(selectedAttachment.type == .text ? "Text" : "Image") {
                            let text = Binding {
                                selectedAttachment.text ?? ""
                            } set: { text in
                                self.selectedAttachment?.text = text
                            }
                            
                            HStack {
                                Text("Header Name")
                                    .font(.callout)
                                TextField("Column Header Name", text: text)
                            }
                            
                            let font = Binding {
                                selectedAttachment.font ?? ""
                            } set: { font in
                                self.selectedAttachment?.font = font
                            }
                            
                            Picker(selection: font) {
                                ForEach(viewModel.fonts) { family in
                                    Text(family.familyName)
                                        .id(family.id)
                                }
                            } label: {
                                Text("Font")
                            }
                            
                        }
                        
                        Divider()
                        
                        Section("Position") {
                            HStack {
                                Text("X")
                                    .font(.callout)
                                
//                                TextField(value: $selectedAttachment.rect.origin.x, formatter: NumberFormatter()) {}
//                                Stepper(value: $selectedAttachment.rect.origin.x) {}
                                
                                Spacer()
                                
                                Text("Y")
                                    .font(.callout)
//                                TextField(value: $selectedAttachment.rect.origin.y, formatter: NumberFormatter()) {}
//                                Stepper(value: $selectedAttachment.rect.origin.x) {}
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

struct ObjectInspector_Previews: PreviewProvider {
    static var previews: some View {
        ObjectInspector(viewModel: .init(), selectedAttachment: .constant(nil))
    }
}
