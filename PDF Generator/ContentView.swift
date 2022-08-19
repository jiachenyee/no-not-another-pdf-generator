//
//  ContentView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var isFileImporterPresented = false
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.adaptive(minimum: 150))]) {
                    Button {
                        isFileImporterPresented.toggle()
                    } label: {
                        VStack {
                            Spacer()
                            
                            Image(systemName: "plus")
                                .imageScale(.large)
                            
                            Spacer()
                            
                            Text("New Project")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            Text("Create a new project\nwith a PDF file")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.primary.opacity(0.1))
                        .cornerRadius(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(width: 150, height: 200)
                    
                    ForEach($viewModel.documents) { $document in
                        NavigationLink(destination: EditorView(viewModel: viewModel, document: $document)) {
                            VStack {
                                Image(data: document.image)
                                    .resizable()
                                    .scaledToFit()
                                    .background(.white)
                                    .padding(4)
                                
                                Text(document.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(.primary.opacity(0.01))
                            .cornerRadius(8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray)
                            }
                        }
                        .frame(width: 150, height: 200)
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("PDF Generator")
            .fileImporter(isPresented: $isFileImporterPresented,
                          allowedContentTypes: [.pdf],
                          allowsMultipleSelection: false) { result in
                switch result {
                case .success(let success):
                    if let url = success.first, let data = try? Data(contentsOf: url) {
                        var doc = Document(name: url.lastPathComponent, image: data, imageURL: url, attachments: [])
                        
                        doc.documentSize = doc.uinsImage.size
                        
                        viewModel.documents.append(doc)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
