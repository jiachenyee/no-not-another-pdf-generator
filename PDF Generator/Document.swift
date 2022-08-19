//
//  Document.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

struct Document: Codable, Identifiable {
    
    var id = UUID()
    
    var name: String
    
    var image: Data
    
    var imageURL: URL
    
    var attachments: [Attachment]
    
    var documentSize: CGSize = .zero
    
#if os(macOS)
    var uinsImage: NSImage {
        .init(data: image)!
    }
#endif
    
#if os(iOS)
    var uinsImage: UIImage {
        Self.convertPDFPageToImage(data: data)!
    }
    
    static func convertPDFPageToImage(data: Data) -> UIImage? {
        let pdfData = data as CFData
        
        let provider:CGDataProvider = CGDataProvider(data: pdfData)!
        let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
        
        let pdfPage:CGPDFPage = pdfDoc.page(at: 1)!
        var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
        pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
        
        print("\(pageRect.width) by \(pageRect.height)")
        
        UIGraphicsBeginImageContext(pageRect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(pdfPage)
        context.restoreGState()
        
        let pdfImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return pdfImage
    }
#endif

}
