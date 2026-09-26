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
    
    @Binding var compactLeading: Bool
    @Binding var compactTrailing: Bool
    @Binding var dynamicIslandType: DeviceInfo.DynamicIslandType
    
    init(
        compactLeading: Binding<Bool>,
        compactTrailing: Binding<Bool>,
        dynamicIslandType: Binding<DeviceInfo.DynamicIslandType> = .constant(DeviceInfo.dynamicIslandType)
    ) {
        self._compactLeading = compactLeading
        self._compactTrailing = compactTrailing
        self._dynamicIslandType = dynamicIslandType
    }
    
    private func makeHorizontalIsland(
        leading: Bool,
        trailing: Bool,
        centerMargin: CGFloat,
    ) -> some View {
        let totalWidth: CGFloat = {
            var w: CGFloat = 0
            if leading { w += 29 } else if trailing { w += 21 } else { w += 5 }
            if trailing { w += 29 } else if leading { w += 21 } else { w += 5 }
            return w + centerMargin
        }()
        
        return ZStack {
            Capsule()
                .fill(Color.black)
                .stroke(Color(red: 0.16, green: 0.16, blue: 0.16), lineWidth: colorScheme == .dark ? 1.5 : 0)
                .frame(width: totalWidth, height: 38)
            
            HStack(alignment: .center, spacing: 0) {
                if leading {
                    Image(systemName: "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .padding(.trailing, 2)
                        .frame(width: 18, height: 18)
                        .padding(.leading, 11)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else if trailing {
                    Spacer().frame(width: 21)
                } else {
                    Spacer().frame(width: 5)
                }
                
                Spacer().frame(width: centerMargin)
                
                if trailing {
                    Image(systemName: leading ? "square.2.layers.3d" : "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .id(leading ? "square.2.layers.3d" : "suit.diamond")
                        .padding(.leading, 2)
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 11)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else if leading {
                    Spacer().frame(width: 21)
                } else {
                    Spacer().frame(width: 5)
                }
            }
        }
        .padding(.leading, (leading && !trailing) ? 0 : 8)
        .padding(.trailing, (trailing && !leading) ? 0 : 8)
        .animation(.bouncy, value: compactLeading)
        .animation(.bouncy, value: compactTrailing)
    }
    
    private func makeVerticalIsland(
        leading: Bool,
        trailing: Bool,
        topMargin: CGFloat,
    ) -> some View {
        let totalHeight: CGFloat = topMargin + 80
        return ZStack {
            Capsule()
                .fill(Color.black)
                .stroke(Color(red: 0.16, green: 0.16, blue: 0.16), lineWidth: colorScheme == .dark ? 1.5 : 0)
                .frame(width: 38, height: totalHeight)
            
            VStack(alignment: .center, spacing: 0) {
                Spacer().frame(height: topMargin)
                
                if leading {
                    Image(systemName: "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 13)
                        .padding(.bottom, 11)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else {
                    Spacer().frame(width: 40, height: 40)
                }
                
                if trailing {
                    Image(systemName: leading ? "square.2.layers.3d" : "suit.diamond")
                        .resizable()
                        .scaledToFit()
                        .id(leading ? "square.2.layers.3d" : "suit.diamond")
                        .padding(.top, 11)
                        .padding(.bottom, 13)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.dropblue)
                        .transition(.blurReplace)
                } else {
                    Spacer().frame(width: 40, height: 40)
                }
            }
        }
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
            HStack(alignment: .center, spacing: 0) {
                makeVerticalIsland(
                    leading: compactLeading,
                    trailing: compactTrailing,
                    topMargin: 40
                )
                Spacer().frame(maxWidth: 50)
                makeVerticalIsland(
                    leading: compactLeading,
                    trailing: compactTrailing,
                    topMargin: 0
                )
            }
        default:
            makeHorizontalIsland(
                leading: compactLeading,
                trailing: compactTrailing,
                centerMargin: 97
            )
        }
    }
}
