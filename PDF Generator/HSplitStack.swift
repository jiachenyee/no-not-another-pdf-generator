//
//  HSplitStack.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 18/8/22.
//

import Foundation
import SwiftUI

struct HSplitStack<Content>: View where Content: View {
    
    @ViewBuilder var content: (() -> Content)
    
    var body: some View {
#if os(macOS)
        HSplitView { content() }
#elseif os(iOS)
        HStack { content() }
#endif
    }
}

struct HSplitStack_Previews: PreviewProvider {
    static var previews: some View {
        HSplitStack {
            Image(systemName: "circle")
        }
    }
}

