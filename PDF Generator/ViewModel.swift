//
//  ViewModel.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    var shouldUpdateView = true
    
    @Published var fonts: [FontFamily] = []
    @Published var documents: [Document] = []
    @Published var selectedAttachment: UUID?
    
    @Published var selectedDocumentIndex: Int?
    
    var document: Document {
        get {
            documents[selectedDocumentIndex ?? 0]
        }
        set {
            documents[selectedDocumentIndex ?? 0] = newValue
        }
    }
    
    init() {
        Task {
            let fonts = FontFamily.listAvailableFontFamilies()
            DispatchQueue.main.async {
                self.fonts = fonts
            }
        }
    }
}
