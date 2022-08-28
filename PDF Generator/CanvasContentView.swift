//
//  CanvasContentView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 19/8/22.
//

import AppKit

class CanvasContentView: NSView {
    var backgroundImageView: NSImageView!
    
    init(backgroundImage: NSImage) {
        super.init(frame: .zero)
        
        appearance = NSAppearance(named: .aqua)
        
        backgroundImageView = NSImageView(image: backgroundImage)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        
        addConstraints([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
