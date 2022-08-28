//
//  CanvasView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 19/8/22.
//

import Foundation
import SwiftUI

struct CanvasView: NSViewRepresentable {
    
    @ObservedObject var viewModel: ViewModel
    
    func makeNSView(context: Context) -> CanvasNSView {
        let canvasNSView = CanvasNSView(backgroundImage: viewModel.document.uinsImage)
        
        canvasNSView.delegate = context.coordinator
        
        return canvasNSView
    }
    
    func updateNSView(_ nsView: CanvasNSView, context: Context) {
        
        guard viewModel.shouldUpdateView else {
            viewModel.shouldUpdateView = true
            return
        }
        
        if nsView.attachments != viewModel.document.attachments {
            nsView.attachments = viewModel.document.attachments
        }
        
        if nsView.selectedAttachment != viewModel.selectedAttachment {
            nsView.selectedAttachment = viewModel.selectedAttachment
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: CanvasNSViewDelegate {
        
        var parent: CanvasView
        
        init(parent: CanvasView) {
            self.parent = parent
        }
        
        func canvasViewDidUpdateAttachments(_ attachments: [Attachment]) {
            parent.viewModel.shouldUpdateView = false
            
            parent.viewModel.document.attachments = attachments
        }
        
        func canvasViewDidUpdateSelectedAttachment(_ id: UUID) -> UUID? {
            parent.viewModel.shouldUpdateView = false
            
            if parent.viewModel.selectedAttachment == id {
                parent.viewModel.selectedAttachment = nil
                
                return nil
            } else {
                parent.viewModel.selectedAttachment = id
                
                return id
            }
        }
    }
}
