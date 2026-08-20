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
                
//                Section("Transportation") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Automotive") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Health") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Objects & Tools") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Gaming") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
                
                Section("Home") {
                    SymbolButtonsGrid([
                        "house.fill", "lightbulb.fill", "washer.fill", "stove.fill", "bathtub.fill", "bed.double.fill", "stairs", "poweroutlet.strip", "heater.vertical.fill", "spigot.fill", "chair.fill", "robotic.vacuum.fill", "apple.homekit", "lamp.ceiling.fill", "fan.fill", "fan.ceiling.fill", "popcorn.fill", "sofa.fill", "oven.fill", "microwave.fill", "toilet.fill", "cabinet", "shower.handheld.fill"
                    ])
                }
                
//                Section("Commerce") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Objects") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Variable") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Weather") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Nature") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Human") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Keyboard") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Camera & Photos") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Communication") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Media") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Fitness") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Accessibility") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Time") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Privacy & Security") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Editing") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("People") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Symbols") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Arrows") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Shapes") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Math") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Indices") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
//                
//                Section("Text Formatting") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
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
