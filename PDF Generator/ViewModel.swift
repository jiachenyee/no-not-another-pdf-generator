//
//  ViewModel.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var fonts: [FontFamily] = []
    @Published var documents: [Document] = []
    
    init() {
        Task {
            let fonts = FontFamily.listAvailableFontFamilies()
            DispatchQueue.main.async {
                self.fonts = fonts
            }
        }
    }
}
