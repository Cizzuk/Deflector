//
//  CenteredLabelStyle.swift
//  Deflector Watch
//
//  Created by Cizzuk on 2026/10/04.
//

import SwiftUI

struct CenteredIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 5) {
            configuration.icon
                .imageScale(.large)
                .frame(width: 25, alignment: .center)
            configuration.title
                .multilineTextAlignment(.leading)
        }
    }
}
