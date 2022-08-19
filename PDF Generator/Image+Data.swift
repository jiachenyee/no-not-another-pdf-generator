//
//  Image+Data.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

extension Image {
    init(data: Data) {
#if os(macOS)
        self.init(nsImage: .init(data: data)!)
#elseif os(iOS)
        self.init(uiImage: Document.convertPDFPageToImage(data: data)!)
#endif
    }
}
