//
//  CenteredLabelStyle.swift
//  Deflector
//
//  Created by Cizzuk on 2026/10/04.
//

import SwiftUI

struct CenteredIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 5) {
            configuration.icon
                .imageScale(.large)
                .frame(width: 25, height: .infinity, alignment: .center)
            configuration.title
                .multilineTextAlignment(.leading)
        }
    }
}
