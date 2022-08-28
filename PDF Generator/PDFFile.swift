//
//  PDFFile.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 28/8/22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct PDFFile: FileDocument {
    static var readableContentTypes: [UTType] = [.pdf]
    
    var data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    init(configuration: ReadConfiguration) throws {
        data = configuration.file.regularFileContents!
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
    
}
