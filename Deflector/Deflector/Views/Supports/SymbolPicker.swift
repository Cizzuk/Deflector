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
    
    private func SymbolButtonsGrid(_ names: [String]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], alignment: .center) {
            ForEach(names, id: \.self) { name in
                Button(action: { symbol = name }) {
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(symbol == name ? .accent : .secondary)
                        .padding(8)
                        .accessibilityLabel(name)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func close() {
        callback(symbol)
        dismiss()
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
                } footer: {
                    Text("You can use the symbols included in [SF Symbols](https://developer.apple.com/sf-symbols/).")
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
                        "car.fill", "bolt.car.fill", "bus.fill", "tram.fill", "bicycle", "motorcycle.fill", "airplane", "sailboat.fill", "fuelpump.fill", "airplane.ticket.fill", "figure.walk", "figure.wave", "scooter", "ferry.fill", "truck.box.fill", "ev.charger.fill"
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
                
                Section("Objects & Tools") {
                    SymbolButtonsGrid([
                        "sailboat.fill", "building.2.fill", "cart.fill", "takeoutbag.and.cup.and.straw.fill", "bag.fill", "fork.knife", "fuelpump.fill", "umbrella.fill", "signpost.right.and.left.fill", "film.fill", "camera.fill", "document.on.clipboard.fill", "calendar", "paperplane.fill", "briefcase.fill", "folder.fill", "creditcard.fill", "printer.fill", "internaldrive.fill", "externaldrive.connected.to.line.below.fill", "archivebox.fill", "cube.fill", "gamecontroller.fill", "puzzlepiece.extension.fill", "headphones", "speaker.wave.1.fill", "speaker.wave.2.fill", "speaker.wave.3.fill", "speaker.slash.fill", "speaker.fill", "books.vertical.fill", "book.fill", "book.closed.fill", "eyeglasses", "ticket.fill", "theatermasks.fill", "dice.fill", "tennisball.fill", "lifepreserver.fill", "clock.fill", "alarm.fill", "stopwatch.fill", "bell.fill", "trophy.fill", "lightbulb.fill", "flag.fill", "tag.fill", "key.fill", "hourglass", "lock.fill", "lock.open.fill", "battery.100percent", "wand.and.sparkles", "wand.and.rays", "paintbrush.fill", "pencil", "paperclip", "scissors", "magnifyingglass", "link", "hammer.fill", "gear", "trash.fill", "cup.and.saucer.fill", "carrot.fill", "birthday.cake.fill", "wineglass.fill", "hanger", "washer.fill", "stove.fill", "tshirt.fill", "bathtub.fill", "pills.fill", "cross.vial.fill", "bandage.fill", "inhaler.fill", "stethoscope", "syringe.fill", "facemask.fill", "graduationcap.fill", "gift.fill", "bed.double.fill", "map.fill", "gauge.with.dots.needle.bottom.50percent", "gauge.with.dots.needle.67percent", "barometer", "pad.header", "text.pad.header", "radio.fill", "suitcase.rolling.and.suitcase.fill", "pet.carrier.fill", "theatermask.and.paintbrush", "poweroutlet.strip", "heater.vertical.fill", "spigot.fill", "chair.fill", "robotic.vacuum.fill", "receipt.fill", "pizza.slice.fill", "bookmark.fill", "document.fill", "mappin.and.ellipse", "crop", "camera.filters", "timer", "square.and.pencil", "dial.low.fill", "dial.high.fill", "camera.viewfinder", "eraser.fill", "clipboard.fill", "list.bullet.clipboard.fill", "photo.artframe", "dumbbell.fill", "duffle.bag.fill", "flag.2.crossed.fill", "flashlight.on.fill", "paintpalette.fill", "gearshape.fill", "metronome.fill", "pianokeys", "paintbrush.pointed.fill", "lamp.ceiling.fill", "fan.fill", "fan.ceiling.fill", "balloon.fill", "fireworks", "party.popper.fill", "popcorn.fill", "sofa.fill", "watch.analog", "guitars.fill", "horn.fill", "teddybear.fill", "crown.fill", "movieclapper.fill", "compass.drawing", "battery.25percent", "battery.100percent.bolt", "medical.thermometer.fill", "calendar.and.person", "fire.extinguisher.fill", "wallet.bifold.fill", "heart.text.clipboard.fill", "ev.charger.fill", "flag.pattern.checkered", "arcade.stick.console.fill", "personalhotspot", "antenna.radiowaves.left.and.right", "oven.fill", "microwave.fill", "toilet.fill", "medal.fill", "fossil.shell.fill", "key.radiowaves.forward.fill", "bell.badge.waveform.fill", "bell.slash.fill", "bell.and.waves.left.and.right.fill", "mug.fill", "basket.fill", "cabinet.fill", "pin.fill", "waterbottle.fill", "sdcard.fill", "simcard.fill", "scalemass.fill", "shower.handheld.fill", "ivfluid.bag.fill", "globe.desk.fill", "shield.fill"
                    ])
                }
                
                Section("Gaming") {
                    SymbolButtonsGrid([
                        "house.fill", "gamecontroller.fill", "plus", "flag.2.crossed.fill", "xmark", "flag.pattern.checkered", "arcade.stick.console.fill", "gearshift.layout.sixspeed", "formfitting.gamecontroller.fill", "dpad.fill"
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
                        "storefront.fill", "safari.fill", "star.fill", "star.leadinghalf.filled", "rectangle.grid.2x2.fill", "rectangle.split.2x1.fill", "rectangle.split.3x1.fill", "square.stack.fill", "paint.bucket.classic"
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
                
                Section("Time") {
                    SymbolButtonsGrid([
                        "clock.fill", "alarm.fill", "stopwatch.fill", "hourglass", "timer"
                    ])
                }
                
                Section("Privacy & Security") {
                    SymbolButtonsGrid([
                        "key.fill", "lock.fill", "lock.open.fill", "hand.raised.fill", "hand.raised.slash.fill", "exclamationmark.triangle.fill", "checkmark", "nosign", "key.radiowaves.forward.fill", "firewall.fill", "seal.fill", "shield.fill"
                    ])
                }
                
                Section("Editing") {
                    SymbolButtonsGrid([
                        "wand.and.sparkles", "wand.and.rays", "paintbrush.fill", "pencil", "scissors", "eyedropper.halffull", "bandage.fill", "crop", "slider.horizontal.3", "camera.filters", "square.and.pencil", "dial.low.fill", "dial.high.fill", "eraser.fill", "scribble.variable", "pencil.and.scribble", "signature", "paintbrush.pointed.fill", "move.3d", "beziercurve"
                    ])
                }
                
//                Section("People") {
//                    SymbolButtonsGrid([
//                        "",
//                    ])
//                }
                
                Section("Symbols") {
                    SymbolButtonsGrid([
                        "barcode", "qrcode", "square.and.arrow.down.fill", "square.and.arrow.up", "questionmark", "info", "square.grid.2x2.fill", "square.grid.4x3.fill", "point.3.filled.connected.trianglepath.dotted", "peacesign", "airplay.video", "music.note.list", "music.note", "waveform.path", "plus.square.fill.on.square.fill", "qrcode.viewfinder", "text.page.fill", "apple.terminal.fill", "applescript.fill", "building.classical.columns.fill", "finder", "shazam.logo.fill", "apple.intelligence", "suit.spade.fill", "suit.diamond.fill", "suit.club.fill", "sparkle"
                    ])
                }
                
                Section("Arrows") {
                    SymbolButtonsGrid([
                        "arrowshape.turn.up.backward.fill", "arrowshape.turn.up.forward.fill", "chevron.backward", "chevron.forward", "chevron.up", "chevron.down", "arrow.3.trianglepath", "location.fill", "arrow.down.forward.and.arrow.up.backward", "arrow.up.and.down.and.arrow.left.and.right", "arrow.2.squarepath", "arrow.trianglehead.2.clockwise.rotate.90", "shuffle", "arrow.turn.up.right", "arrow.backward", "arrow.forward", "arrow.up", "arrow.down", "arrow.up.forward", "arrow.up.backward"
                    ])
                }
                
                Section("Shapes") {
                    SymbolButtonsGrid([
                        "square.fill", "circle.fill", "capsule.portrait.fill", "rectangle.fill", "rectangle.portrait.fill", "oval.fill", "oval.portrait.fill", "triangle.fill", "diamond.fill", "octagon.fill", "hexagon.fill", "pentagon.fill", "seal.fill", "rhombus.fill", "shield.fill"
                    ])
                }
                
                Section("Math") {
                    SymbolButtonsGrid([
                        "plus", "radicand.squareroot", "function", "percent", "sum", "compass.drawing", "angle", "graph.2d"
                    ])
                }
                
                Section("Indices") {
                    SymbolButtonsGrid([
                        "eurosign", "sterlingsign", "yensign", "p.square.fill", "t.square.fill"
                    ])
                }
                
                Section("Text Formatting") {
                    SymbolButtonsGrid([
                        "list.bullet", "checklist", "character.textbox", "signature", "numbers", "textformat.characters", "textformat", "textformat.size", "textformat.superscript", "textformat.subscript", "bold.italic.underline", "characters.lowercase", "characters.uppercase", "text.alignleft", "text.aligncenter", "text.alignright", "text.justify", "text.square.filled", "character.text.justify"
                    ])
                }
            }
            .navigationTitle("Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .accessibilityAction(.escape) { close() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { close() }) {
                        Label("Done", systemImage: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
    }
}
