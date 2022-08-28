//
//  CanvasNSViewDelegate.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 23/8/22.
//

import Foundation

protocol CanvasNSViewDelegate {
    func canvasViewDidUpdateAttachments(_ attachments: [Attachment])
    func canvasViewDidUpdateSelectedAttachment(_ id: UUID) -> UUID?
}
