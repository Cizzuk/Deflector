//
//  TimerSettingsView.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/03.
//

import SwiftUI

struct TimerSettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var timerModel = TimerModel.shared
    @StateObject private var vm = TimerSettingsViewModel()

    @State private var isShowingEditor = false
    @State private var isShowingFireDate = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(timerModel.timers) { timer in
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(timer.shortcutName)
                                    .lineLimit(1)
                                Group {
                                    if isShowingFireDate {
                                        Text("\(timer.fireDate, format: .dateTime.year().month().day().hour().minute().second())")
                                    } else {
                                        Text("\(timer.fireDate, style: .relative)")
                                    }
                                }
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .onTapGesture {
                                    isShowingFireDate.toggle()
                                }
                            }
                        } icon: {
                            Image(systemName: defaultShortcutSymbol)
                                .accessibilityHidden(true)
                                .foregroundStyle(Color(uiColor: .label))
                        }
                        .accessibilityElement(children: .combine)
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = timer.id
                            }) {
                                Label("Copy Timer ID", systemImage: "document.on.document")
                            }
                            .tint(Color(uiColor: .label))

                            Button(
                                role: .destructive,
                                action: { Task { await timerModel.remove(ids: [timer.id]) } }
                            ) {
                                Label("Remove Timer", systemImage: "trash")
                            }
                            .tint(Color(uiColor: .systemRed))
                        }
                    }
                    .onDelete { offsets in
                        let ids = offsets.map { timerModel.timers[$0].id }
                        Task { await timerModel.remove(ids: ids) }
                    }

                    if timerModel.timers.count < TimerModel.maxCount {
                        Button(action: {
                            vm.prepareEditor()
                            isShowingEditor = true
                        }) {
                            Label("Add Timer", systemImage: "plus")
                        }
                        .keyboardShortcut("n", modifiers: [.command])
                    }
                } header: {
                    Text("Schedules")
                } footer: {
                    Text("\(timerModel.timers.count) / \(TimerModel.maxCount)")
                        .padding(.bottom, 10)
                }

                Section {
                } footer: {
                    Text("If the shortcut is not executed, please make sure that Deflector Automation is allowed to run when locked, and that the device has been unlocked after a restart. Executing multiple shortcuts at the same time may cause failures.")
                        .padding(.bottom, 10)
                }
            }
            .animation(.default, value: timerModel.timers)
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingEditor) {
                TimerEditorView(vm: vm)
            }
        }
        .onAppear {
            Task { await timerModel.refresh() }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                Task { await timerModel.refresh() }
            }
        }
    }
}

struct TimerEditorView: View {
    @ObservedObject var vm: TimerSettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingShortcutPicker = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: { isShowingShortcutPicker = true }) {
                        if vm.shortcutName.isEmpty {
                            Label {
                                Text("Not Set")
                                    .foregroundStyle(Color(uiColor: .placeholderText))
                            } icon: {
                                Image(systemName: defaultShortcutSymbol)
                            }
                        } else {
                            Label(vm.shortcutName, systemImage: defaultShortcutSymbol)
                                .lineLimit(1)
                        }
                    }
                    .foregroundStyle(Color(uiColor: .label))
                } header: {
                    Text("Shortcut")
                }

                Section {
                    Picker("Schedule", selection: $vm.mode) {
                        Text("Duration").tag(TimerSettingsViewModel.Mode.duration)
                        Text("Date & Time").tag(TimerSettingsViewModel.Mode.date)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()

                    switch vm.mode {
                    case .duration:
                        VStack(alignment: .center) {
                            DurationWheelPicker(duration: $vm.duration)
                        }
                    case .date:
                        DatePicker(
                            "Date & Time",
                            selection: $vm.date,
                            in: vm.dateRange,
                            displayedComponents: [.date, .hourAndMinute]
                        )

                        HStack {
                            Button(action: {
                                vm.date = Calendar.current.date(byAdding: .month, value: 1, to: vm.date) ?? vm.date
                                if vm.date > vm.dateRange.upperBound {
                                    vm.date = vm.dateRange.upperBound
                                }
                            }) {
                                Text("+ 1Month")
                                    .accessibilityLabel("Add 1 month")
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()

                            Button(action: {
                                vm.date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: vm.date) ?? vm.date
                                if vm.date > vm.dateRange.upperBound {
                                    vm.date = vm.dateRange.upperBound
                                }
                            }) {
                                Text("+ 1Week")
                                    .accessibilityLabel("Add 1 week")
                            }
                            .buttonStyle(.borderedProminent)

                            Spacer()

                            Button(action: {
                                vm.date = Calendar.current.date(byAdding: .day, value: 1, to: vm.date) ?? vm.date
                                if vm.date > vm.dateRange.upperBound {
                                    vm.date = vm.dateRange.upperBound
                                }
                            }) {
                                Text("+ 1Day")
                                    .accessibilityLabel("Add 1 day")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                } footer: {
                    switch vm.mode {
                    case .duration:
                        EmptyView()
                    case .date:
                        if let fireDate = vm.resolvedFireDate() {
                            Text(fireDate, style: .relative)
                                .padding(.bottom, 10)
                        } else {
                            Text("Set a time within one year from now.")
                                .padding(.bottom, 10)
                        }
                    }
                }
            }
            .animation(.default, value: vm.mode)
            .navigationTitle("Add Timer")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: { dismiss() })
                        .tint(Color(uiColor: .label))
                        .keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(
                        role: .confirm,
                        action: { Task { if await vm.schedule() { dismiss() } } }
                    )
                    .disabled(!vm.canSchedule)
                    .keyboardShortcut(.defaultAction)
                }
            }
            .sheet(isPresented: $isShowingShortcutPicker) {
                ShortcutPicker(
                    vm.shortcutName,
                    prompt: "Please set the shortcut name to run at the scheduled time.",
                ) { shortcutName in
                    vm.shortcutName = shortcutName
                }
            }
            .alert(
                "Error",
                isPresented: Binding(
                    get: { vm.errorMessage != nil },
                    set: { if !$0 { vm.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .close) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}
