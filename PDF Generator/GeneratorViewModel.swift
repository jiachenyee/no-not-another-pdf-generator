//
//  GeneratorViewModel.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 28/8/22.
//

import Foundation
import PDFKit

class GeneratorViewModel: ObservableObject {
    
    var shouldUpdateView = true
    
    @Published var generatedDocuments: [Data] = []
    
    init() {
        
    }
    
    func mergeDocuments() -> PDFDocument {
        let newDoc = PDFDocument()
        
        for generatedDocument in generatedDocuments {
            let data = PDFDocument(data: generatedDocument)
            
            newDoc.insert(data!.page(at: 0)!, at: newDoc.pageCount)
        }
        
        return newDoc
    }
}
