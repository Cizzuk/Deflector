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
                            .frame(width: 50, height: 50)
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
                
                Section("Transportation") {
                    SymbolButtonsGrid([
                        "car.fill", "bolt.car.fill", "bus.fill", "tram.fill", "bicycle", "motorcycle.fill", "airplane", "sailboat.fill", "fuelpump.fill", "airplane.ticket.fill", "figure.walk", "figure.wave", "scooter", "ferry", "truck.box.fill", "ev.charger.fill"
                    ])
                }
                
//                Section("Automotive") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
                
                Section("Health") {
                    SymbolButtonsGrid([
                        "cross.fill", "ear.fill", "heart.fill", "pills.fill", "bandage.fill", "stethoscope", "syringe.fill", "facemask.fill", "bed.double.fill", "brain.fill", "staroflife.fill", "list.bullet.clipboard", "medical.thermometer.fill", "heart.text.clipboard.fill", "ivfluid.bag.fill", "apple.meditate"
                    ])
                }
                
//                Section("Objects & Tools") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
                
                Section("Gaming") {
                    SymbolButtonsGrid([
                        "house.fill", "gamecontroller.fill", "plus", "flag.2.crossed.fill", "xmark", "flag.pattern.checkered", "arcade.stick.console.fill", "gearshift.layout.sixspeed", "formfitting.gamecontroller", "dpad.fill"
                    ])
                }
                
                Section("Home") {
                    SymbolButtonsGrid([
                        "house.fill", "lightbulb.fill", "washer.fill", "stove.fill", "bathtub.fill", "bed.double.fill", "stairs", "poweroutlet.strip", "heater.vertical.fill", "spigot.fill", "chair.fill", "robotic.vacuum.fill", "apple.homekit", "lamp.ceiling.fill", "fan.fill", "fan.ceiling.fill", "popcorn.fill", "sofa.fill", "oven.fill", "microwave.fill", "toilet.fill", "cabinet.fill", "shower.handheld.fill"
                    ])
                }
                
                Section("Commerce") {
                    SymbolButtonsGrid([
                        "cart.fill", "bag.fill", "creditcard.fill", "dollarsign", "eurosign", "sterlingsign", "yensign", "bitcoinsign", "signature", "basket.fill", "banknote.fill"
                    ])
                }
                
                Section("Objects") {
                    SymbolButtonsGrid([
                        "storefront.fill", "safari.fill",
                    ])
                }
                
                Section("Variable") {
                    SymbolButtonsGrid([
                        "thermometer.medium", "speaker.wave.1.fill", "speaker.wave.2.fill", "speaker.wave.3.fill", "wand.and.rays", "square.stack.3d.down.forward.fill", "ellipsis", "rays", "wifi", "airplay.audio", "waveform", "livephoto", "apple.homekit", "antenna.radiowaves.left.and.right", "key.radiowaves.forward.fill", "bell.badge.waveform.fill", "chart.bar.xaxis"
                    ])
                }
                
                Section("Weather") {
                    SymbolButtonsGrid([
                        "thermometer.medium", "degreesign.celsius", "degreesign.fahrenheit", "humidity.fill", "sparkles", "sun.max.fill", "moon.fill", "snowflake", "cloud.fill", "cloud.rain.fill", "wind", "tornado"
                    ])
                }
                
                Section("Nature") {
                    SymbolButtonsGrid([
                        "flame.fill", "mountain.2.fill", "bolt.fill", "drop.fill", "carrot.fill", "fish.fill", "atom", "pawprint.fill", "tortoise.fill", "hare.fill", "lizard.fill", "bird.fill", "ladybug.fill", "leaf.fill", "humidity.fill", "sparkles", "sun.max.fill", "moon.fill", "snowflake", "cloud.fill", "cloud.rain.fill", "wind", "tornado", "fossil.shell.fill", "apple.meditate"
                    ])
                }
                
                Section("Human") {
                    SymbolButtonsGrid([
                        "shoeprints.fill", "ear.fill", "figure.stand", "figure.roll", "person.fill", "person.2.fill", "figure", "figure.dance", "brain.fill", "hand.raised.fill", "hand.raised.slash.fill", "hand.thumbsup.fill", "person.number.sign.rectangle", "person.badge.creditcard", "hand.point.up.braille.fill", "face.smiling", "figure.wave", "calendar.and.person", "person.crop.circle.badge.magnifyingglass.fill", "wheelchair", "hand.point.up.left.fill", "hand.tap.fill", "accessibility.fill"
                    ])
                }
                
                Section("Keyboard") {
                    SymbolButtonsGrid([
                        "globe", "keyboard.fill", "power", "command", "sun.max.fill"
                    ])
                }
                
                Section("Camera & Photos") {
                    SymbolButtonsGrid([
                        "photo.fill", "camera.fill", "bolt.fill", "camera.aperture", "arrow.trianglehead.2.clockwise.rotate.90", "camera.filters", "livephoto", "livephoto.play", "camera.viewfinder"
                    ])
                }
                
                Section("Communication") {
                    SymbolButtonsGrid([
                        "video.fill", "microphone.fill", "message.fill", "text.bubble.fill", "envelope.fill", "phone.fill", "recordingtape", "quote.bubble.fill", "waveform"
                    ])
                }
                
                Section("Media") {
                    SymbolButtonsGrid([
                        "play.rectangle.fill", "play.fill", "backward.fill", "stop.fill", "forward.fill", "infinity", "shuffle"
                    ])
                }
                
                Section("Connectivity") {
                    SymbolButtonsGrid([
                        "externaldrive.connected.to.line.below.fill", "network", "icloud.fill", "wifi", "personalhotspot", "bolt.horizontal.fill", "bonjour", "antenna.radiowaves.left.and.right"
                    ])
                }
                
                Section("Fitness") {
                    SymbolButtonsGrid([
                        "gamecontroller.fill", "tennisball.fill", "trophy.fill", "figure.roll", "figure.dance", "figure.walk", "figure.run", "dumbbell.fill", "sportscourt.fill", "duffle.bag.fill", "flag.pattern.checkered", "figure.cooldown", "medal.fill"
                    ])
                }
                
                Section("Accessibility") {
                    SymbolButtonsGrid([
                        "ear.fill", "figure.roll", "figure", "hand.point.up.braille.fill", "arrow.up.and.down.and.arrow.left.and.right", "quote.bubble.fill", "tortoise.fill", "hare.fill", "textformat.size", "wheelchair", "hand.tap.fill", "accessibility.fill", "siri"
                    ])
                }
                
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
