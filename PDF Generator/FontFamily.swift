//
//  FontFamily.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import AppKit


struct FontFamily: Identifiable {
    
    var id: String {
        familyName
    }
    
    var familyName: String
    var fonts: [Font]
    
    static func listAvailableFontFamilies() -> [FontFamily] {
        NSFontManager.shared.availableFontFamilies.compactMap { familyName in
            if let members = NSFontManager.shared
                .availableMembers(ofFontFamily: familyName)?
                .compactMap({ font in
                Font(font)
            }) {
                
                return FontFamily(familyName: familyName, fonts: members)
            } else {
                return nil
            }
        }
    }
}

struct Font: Identifiable {
    
    var id: String {
        postScriptName
    }
    var postScriptName: String
    var humanReadableName: String
    var fontWeight: Int
    var fontTraits: Int
    
    init(postScriptName: String, humanReadableName: String, fontWeight: Int, fontTraits: Int) {
        self.postScriptName = postScriptName
        self.humanReadableName = humanReadableName
        self.fontWeight = fontWeight
        self.fontTraits = fontTraits
    }
    
    init?(_ arr: [Any]) {
        if let postScriptName = arr[0] as? String,
           let humanReadableName = arr[1] as? String,
           let fontWeight = arr[2] as? Int,
           let fontTraits = arr[3] as? Int {
            self.postScriptName = postScriptName
            self.humanReadableName = humanReadableName
            self.fontWeight = fontWeight
            self.fontTraits = fontTraits
        } else {
            return nil
        }
    }
}
