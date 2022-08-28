//
//  ObjectListView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 19/8/22.
//

import SwiftUI

struct ObjectListView: View {
    
    @Binding var document: Document
    @Binding var selectedAttachment: UUID?
    
    @State var isNewItemViewPresented = false
    
    var body: some View {
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
            
            List(selection: $selectedAttachment) {
                ForEach(document.attachments) { attachment in
                    HStack {
                        Image(systemName: attachment.type == .text ? "character.textbox" : "photo")
                        Text(attachment.text ?? "")
                    }
                        .id(attachment.id)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ObjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectListView(document: .constant(.init(name: "", image: .init(), imageURL: .applicationDirectory, attachments: .init())), selectedAttachment: .constant(.init()))
    }
}
