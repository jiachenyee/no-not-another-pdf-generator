//
//  AttachmentViewDelegate.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 22/8/22.
//

import Foundation

protocol AttachmentViewDelegate {
    func attachmentDidToggleSelection(_ attachment: Attachment, view: AttachmentView)
    func attachmentDidDrag(_ attachment: Attachment, view: AttachmentView)
    func attachmentDidFinishDragging(_ attachment: Attachment, view: AttachmentView)
}
