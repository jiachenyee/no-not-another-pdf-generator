//
//  Attachment.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation

struct Attachment: Codable, Identifiable {
    
    var id = UUID()
    
    var type: AttachmentType
    
    var text: String?
    var font: String = "Arial"
    var style: String = ""
    
    var url: URL?
    var data: Data?
    
    var rect: CGRect
    var fontSize: Double
    
    enum AttachmentType: Codable {
        case text
        case image
    }
}

