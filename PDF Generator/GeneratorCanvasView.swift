//
//  GeneratorCanvasView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 28/8/22.
//

import SwiftCSV
import SwiftUI

struct GeneratorCanvasView: NSViewRepresentable {
    
    var document: Document
    var data: CSV<Named>
    
    @ObservedObject var viewModel: GeneratorViewModel
    
    func makeNSView(context: Context) -> CanvasNSView {
        
        let canvasNSView = CanvasNSView(backgroundImage: document.uinsImage)
        
        var currentRow = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            let row = data.rows[currentRow]
            
            canvasNSView.attachments = document.attachments.map { attachment in
                var mutableAttachment = attachment
                
                switch attachment.type {
                case .text:
                    mutableAttachment.text = row[attachment.text!]
                case .image:
                    break
                }
                
                return mutableAttachment
            }
            
            viewModel.generatedDocuments.append(canvasNSView.getSnapshot())
            
            currentRow += 1
            
            if currentRow == data.rows.count {
                timer.invalidate()
            }
        }
        
        return canvasNSView
    }
    
    func updateNSView(_ nsView: CanvasNSView, context: Context) {
        
    }
}
