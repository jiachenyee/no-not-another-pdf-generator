//
//  Attachment.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

struct Attachment: Codable, Identifiable, Equatable {
    static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type && lhs.text == rhs.text && lhs.font == rhs.font && lhs.style == rhs.style && lhs.url == rhs.url && lhs.data == rhs.data && lhs.rect == rhs.rect && lhs.fontSize == rhs.fontSize && lhs.textNSColor == rhs.textNSColor
    }
    
    
    var id = UUID()
    
    var type: AttachmentType
    
    var text: String = ""
    var font: String = "Arial"
    var style: String = ""
    
    var url: URL?
    var data: Data?
    
    var rect: CGRect
    var fontSize: Double
    
    @CodableColor var textNSColor: NSColor
    
    var textColor: CGColor {
        get {
            return textNSColor.cgColor
        }
        set {
            textNSColor = NSColor(cgColor: newValue) ?? .systemGray
        }
    }

    
    init(id: UUID = UUID(), type: AttachmentType, text: String = "", font: String = "Arial", style: String = "", url: URL? = nil, data: Data? = nil, rect: CGRect, fontSize: Double) {
        self.id = id
        self.type = type
        self.text = text
        self.font = font
        self.style = style
        self.url = url
        self.data = data
        self.rect = rect
        self.fontSize = fontSize
        self.textNSColor = .systemGray
    }
    
    enum AttachmentType: Codable {
        case text
        case image
    }
    
    enum TextAlignment: Codable {
        case left
        case center
        case right
        case justified
        
        func toAlignment() -> NSTextAlignment {
            switch self {
            case .left:
                return .left
            case .right:
                return .right
            case .center:
                return .center
            case .justified:
                return .justified
            }
        }
    }
}

@propertyWrapper
struct CodableColor {
    var wrappedValue: NSColor
}

extension CodableColor: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid color"
            )
        }
        wrappedValue = color
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
}
