//
//  UInt32ColorPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/16.
//

import SwiftUI

struct UInt32ColorPicker: View {
    let titleResource: LocalizedStringResource
    @Binding var selection: UInt32
    let supportsOpacity: Bool
    
    @State private var tmpColor: Color
    
    init(
        _ titleResource: LocalizedStringResource,
        selection: Binding<UInt32>,
        supportsOpacity: Bool = true
    ) {
        self.titleResource = titleResource
        self._selection = selection
        self.supportsOpacity = supportsOpacity
        self.tmpColor = ColorHelper.uInt32ToColor(selection.wrappedValue)
    }
    
    var body: some View {
        ColorPicker(
            titleResource,
            selection: $tmpColor,
            supportsOpacity: supportsOpacity
        )
        .onChange(of: tmpColor) {
            selection = ColorHelper.uiColorToUInt32(UIColor(tmpColor))
        }
    }
}
