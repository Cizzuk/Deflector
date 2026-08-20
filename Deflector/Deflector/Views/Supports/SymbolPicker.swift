//
//  SymbolPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/08/18.
//

import SwiftUI

struct SymbolPicker: View {
    @Environment(\.dismiss) var dismiss
    
    @State var symbol: String
    var callback: (String) -> Void
    
    init(_ symbol: String, callback: @escaping (String) -> Void) {
        self.symbol = symbol
        self.callback = callback
    }
    
    func SymbolButtonsGrid(_ names: [String]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], alignment: .center) {
            ForEach(names, id: \.self) { name in
                Button(action: { symbol = name }) {
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(symbol == name ? .accent : .secondary)
                        .padding(10)
                        .accessibilityLabel(name)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        Image(systemName: symbol)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding()
                            .accessibilityHidden(true)
                        Spacer()
                    }
                    TextField("Symbol Name", text: $symbol)
                        .submitLabel(.done)
                }
                
                Section("Maps") {
                    SymbolButtonsGrid([
                        "car.fill", "bus.fill", "tram.fill", "bicycle", "map.fill", "figure.walk", "location.fill", "mappin.and.ellipse", "arrow.up.and.down.and.arrow.left.and.right", "point.topleft.down.to.point.bottomright.curvepath"
                    ])
                }
                
                Section("Devices") {
                    SymbolButtonsGrid([
                        "applewatch", "macbook", "keyboard.fill", "printer.fill", "server.rack", "gamecontroller.fill", "headphones", "ear.fill", "hifispeaker.fill", "earpods", "airpods", "airpods.pro", "appletv.fill", "homepod.fill", "iphone", "apps.iphone", "ipad", "ipad.landscape", "ipod", "mediastick", "tv", "vision.pro", "arcade.stick.console.fill", "pc", "homepod.mini.fill"
                    ])
                }
            }
            .navigationTitle("Choose Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        callback(symbol)
                        dismiss()
                    }) {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}
