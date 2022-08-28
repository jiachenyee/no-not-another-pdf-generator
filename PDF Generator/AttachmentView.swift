//
//  AttachmentView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 19/8/22.
//

import AppKit

class AttachmentView: NSView {
    var attachment: Attachment!
    
    var textView: NSTextField?
    
    var delegate: AttachmentViewDelegate?
    
    var leadingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    var docSize: CGSize!
    
    init(attachment: Attachment, size: CGSize) {
        super.init(frame: .zero)
        
        self.docSize = size
        
        textView = NSTextField(labelWithString: "")
        textView!.textColor = .red
        textView!.sizeToFit()
        
        textView!.wantsLayer = true
        textView!.updateLayer()
        
        textView!.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints([
            textView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView!.topAnchor.constraint(equalTo: topAnchor),
            textView!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(textView!)
        
        self.attachment = attachment
        
        setupAttachment()
        createPanGestureRecognizer()
        createClickGestureRecognizer()
    }
    
    
    func setupAttachment() {
        switch attachment.type {
        case .text:
            guard let textView else { return }
            
            textView.stringValue = attachment.text.isEmpty ? "Text" : attachment.text
            textView.font = NSFont(name: attachment.style, size: attachment.fontSize)
            textView.textColor = attachment.textNSColor
            
            leadingConstraint?.constant = attachment.rect.origin.x
            bottomConstraint?.constant = -attachment.rect.origin.y
            
        case .image:
            break
        }
    }
    
    func setAsSelected() {
        layer?.borderColor = NSColor.controlAccentColor.withAlphaComponent(0.5).cgColor
        layer?.borderWidth = 3
    }
    
    func setAsDeselected() {
        layer?.borderWidth = 0
    }
    
    func createPanGestureRecognizer() {
        let gestureRecognizer = NSPanGestureRecognizer()
        gestureRecognizer.action = #selector(handleGesture(gestureRecognizer:))
        gestureRecognizer.target = self
        addGestureRecognizer(gestureRecognizer)
    }
    
    func createClickGestureRecognizer() {
        let gestureRecognizer = NSClickGestureRecognizer()
        gestureRecognizer.action = #selector(handleTap)
        gestureRecognizer.target = self
        addGestureRecognizer(gestureRecognizer)
    }
    
    var startLocation: CGPoint?
    
    @objc func handleTap() {
        delegate?.attachmentDidToggleSelection(attachment, view: self)
    }
    
    @objc func handleGesture(gestureRecognizer: NSPanGestureRecognizer) {
        
        if gestureRecognizer.state == .ended {
            delegate?.attachmentDidFinishDragging(attachment, view: self)
        } else {
            var location = gestureRecognizer.location(in: self.superview!)
            
            if gestureRecognizer.state == .began {
                startLocation = gestureRecognizer.location(in: self)
            }
            
            location.x -= startLocation?.x ?? 0
            location.y -= startLocation?.y ?? 0
            
            if location.x < 0 {
                location.x = 0
            }
            
            if location.x > docSize.width - startLocation!.x {
                location.x = docSize.width - startLocation!.x
            }
            
            if location.y < 0 {
                location.y = 0
            }
            
            if location.y > docSize.height - startLocation!.y {
                location.y = docSize.height - startLocation!.y
            }
            
            leadingConstraint?.constant = location.x
            bottomConstraint?.constant = -location.y
            
            attachment.rect.origin = location
        }
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
