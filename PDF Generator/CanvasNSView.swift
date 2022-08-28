//
//  CanvasNSView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 19/8/22.
//

import AppKit

class CanvasNSView: NSScrollView {

    var backgroundImage: NSImage
    
    var canvasContentView: CanvasContentView!
    
    var delegate: CanvasNSViewDelegate?
    
    var selectedAttachment: UUID? {
        didSet {
            let attachmentViews = canvasContentView.subviews.compactMap {
                $0 as? AttachmentView
            }
            
            if let targetView = attachmentViews.first(where: { $0.attachment.id == oldValue }),
                let attachment = attachments.first(where: { $0.id == oldValue }) {
                updateAttachment(view: targetView, attachment: attachment, selected: false)
            }
            
            if let targetView = attachmentViews.first(where: { $0.attachment.id == selectedAttachment }),
               let attachment = attachments.first(where: { $0.id == selectedAttachment }) {
                updateAttachment(view: targetView, attachment: attachment, selected: true)
            }
        }
    }
    
    var attachments: [Attachment] = [] {
        didSet {
            for (n, attachment) in attachments.enumerated() {
                
                let attachmentViews = canvasContentView.subviews.compactMap {
                    $0 as? AttachmentView
                }
                
                if let targetView = attachmentViews.first(where: { $0.attachment.id == attachment.id }) {
                    updateAttachment(view: targetView, attachment: attachment, selected: attachment.id == selectedAttachment)
                } else {
                    createAttachmentView(for: attachment, at: n)
                }
            }
        }
    }
    
    func updateAttachment(view: AttachmentView, attachment: Attachment, selected: Bool) {
//        guard view.attachment != attachment else { return }
        
        view.attachment = attachment
        view.setupAttachment()
        
        if selected {
            view.setAsSelected()
        } else {
            view.setAsDeselected()
        }
    }
    
    func createAttachmentView(for attachment: Attachment, at level: Int) {
        let attachmentView = AttachmentView(attachment: attachment, size: backgroundImage.size)
        canvasContentView.addSubview(attachmentView)
        attachmentView.translatesAutoresizingMaskIntoConstraints = false
        
        attachmentView.leadingConstraint = attachmentView.leadingAnchor.constraint(equalTo: canvasContentView.leadingAnchor, constant: attachment.rect.origin.x)
        
        attachmentView.bottomConstraint = attachmentView.bottomAnchor.constraint(equalTo: canvasContentView.bottomAnchor, constant: -attachment.rect.origin.y)
        
        attachmentView.delegate = self
        
        canvasContentView.addConstraints([
            attachmentView.leadingConstraint!,
            attachmentView.bottomConstraint!
        ])
        
        attachmentView.wantsLayer = true
        attachmentView.layer!.zPosition = CGFloat(level)
        attachmentView.updateLayer()
    }
    
    init(backgroundImage: NSImage) {
        self.backgroundImage = backgroundImage
        
        super.init(frame: .zero)
        
        hasVerticalScroller = true
        hasHorizontalScroller = true
        hasVerticalRuler = true
        hasHorizontalRuler = true
        
        allowsMagnification = true
        maxMagnification = 100
        minMagnification = 0.5
        
        let clipView = CanvasClipView()
        contentView = clipView
        
        canvasContentView = CanvasContentView(backgroundImage: backgroundImage)
        canvasContentView.frame = .init(origin: .zero, size: backgroundImage.size)
        
        addSubview(canvasContentView)
        documentView = canvasContentView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSnapshot() -> Data {
        canvasContentView.dataWithPDF(inside: canvasContentView.frame)
    }
}

extension CanvasNSView: AttachmentViewDelegate {
    func attachmentDidToggleSelection(_ attachment: Attachment, view: AttachmentView) {
        selectedAttachment = delegate?.canvasViewDidUpdateSelectedAttachment(attachment.id)
    }
    
    func attachmentDidDrag(_ attachment: Attachment, view: AttachmentView) {
    }
    
    func attachmentDidFinishDragging(_ attachment: Attachment, view: AttachmentView) {
        guard let attachmentIndex = attachments.firstIndex(where: { $0.id == attachment.id }) else { return }
        attachments[attachmentIndex].rect = attachment.rect
        
        delegate?.canvasViewDidUpdateAttachments(attachments)
        
        if selectedAttachment != attachment.id {
            selectedAttachment = delegate?.canvasViewDidUpdateSelectedAttachment(attachment.id)
        }
    }
}
