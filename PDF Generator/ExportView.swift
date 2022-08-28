//
//  ExportView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 24/8/22.
//

import SwiftUI
import SwiftCSV

struct ExportView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var isFileSelectorOpen = false
    
    @State var csv: CSV<Named>?
    
    @State var startProcessing = false
    
    @StateObject var generatorViewModel = GeneratorViewModel()
    
    @State var finalPDFFile: PDFFile?
    @State var isExporterPresented = false
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0)
            
            if let csv {
                if startProcessing {
                    if generatorViewModel.generatedDocuments.count == csv.rows.count {
                        VStack {
                            Text("Merging PDFs")
                                .onAppear {
                                    finalPDFFile = PDFFile(data: generatorViewModel.mergeDocuments().dataRepresentation()!)
                                    isExporterPresented.toggle()
                                }
                                .fileExporter(isPresented: $isExporterPresented, document: finalPDFFile, contentType: .pdf) { result in
                                    switch result {
                                    case .success(let success):
                                        print(success)
                                    case .failure(let failure):
                                        print(failure)
                                    }
                                }
                        }
                    } else {
                        VStack {
                            Text("Generating PDFs")
                                .font(.headline)
                            
                            ProgressView(value: Double(generatorViewModel.generatedDocuments.count) / Double(csv.rows.count))
                            
                            GeneratorCanvasView(document: viewModel.document,
                                                data: csv,
                                                viewModel: generatorViewModel)
                            .opacity(0)
                            .allowsHitTesting(false)
                        }
                    }
                } else {
                    VStack {
                        TableView(csv: csv)
                            
                        Button {
                            isFileSelectorOpen.toggle()
                        } label: {
                            Text("Pick another file")
                        }
                        
                        Button {
                            startProcessing = true
                        } label: {
                            Text("Generate PDFs")
                        }
                    }
                }
                
            } else {
                Button {
                    isFileSelectorOpen.toggle()
                } label: {
                    Text("Select a file")
                }
            }
        }
        .fileImporter(isPresented: $isFileSelectorOpen, allowedContentTypes: [.commaSeparatedText, .tabSeparatedText]) { result in
            switch result {
            case .success(let url):
                csv = try? url.pathExtension == "tsv" ? CSV<Named>(url: url, delimiter: .tab) : CSV(url: url)
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct DataRow: Identifiable {
    var id: Int
    
    var data: [String]
}


struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(viewModel: .init())
    }
}
