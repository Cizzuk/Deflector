//
//  DynamicIslandPreview.swift
//  Deflector
//
//  Created by Cizzuk on 2026/09/26.
//

import SwiftUI
import WidgetKit

struct DynamicIslandPreview: View {
    @Environment(\.colorScheme) var colorScheme
    let dynamicIslandType: DeviceInfo.DynamicIslandType = DeviceInfo.dynamicIslandType
    
    @Binding var compactLeading: Bool
    @Binding var compactTrailing: Bool
    
    func makeHorizontalIsland(
        leading: Bool,
        trailing: Bool,
        centerMargin: CGFloat,
    ) -> some View {
        let totalWidth: CGFloat = {
            var w: CGFloat = 0
            if leading { w += 30 } else if trailing { w += 20 } else { w += 8 }
            if trailing { w += 30 } else if leading { w += 20 } else { w += 8 }
            return w + centerMargin
        }()
        
        return ZStack {
            Capsule()
                .fill(Color.black)
                .stroke(Color(red: 0.16, green: 0.16, blue: 0.16), lineWidth: colorScheme == .dark ? 1.5 : 0)
                .frame(width: totalWidth, height: 37)
            
            HStack(spacing: 0) {
                if leading {
                    Image(systemName: "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .padding(.trailing, 3)
                        .frame(width: 18, height: 18)
                        .padding(.leading, 12)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else if trailing {
                    Spacer().frame(width: 20)
                } else {
                    Spacer().frame(width: 8)
                }
                
                Spacer().frame(width: centerMargin)
                
                if trailing {
                    Image(systemName: leading ? "square.2.layers.3d" : "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .id(leading ? "square.2.layers.3d" : "suit.diamond")
                        .padding(.leading, leading ? 0 : 3)
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 12)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else if leading {
                    Spacer().frame(width: 20)
                } else {
                    Spacer().frame(width: 8)
                }
            }
        }
        .padding(.leading, (leading && !trailing) ? 0 : 10)
        .padding(.trailing, (trailing && !leading) ? 0 : 10)
        .animation(.bouncy, value: compactLeading)
        .animation(.bouncy, value: compactTrailing)
    }
    
    var body: some View {
        switch dynamicIslandType {
        case .horizontal:
            makeHorizontalIsland(
                leading: compactLeading,
                trailing: compactTrailing,
                centerMargin: 127
            )
        case .horizontalSmall:
            makeHorizontalIsland(
                leading: compactLeading,
                trailing: compactTrailing,
                centerMargin: 97
            )
        case .vertical:
            EmptyView()
        default:
            makeHorizontalIsland(
                leading: compactLeading,
                trailing: compactTrailing,
                centerMargin: 97
            )
        }
    }
}
