//
//  DurationWheelPicker.swift
//  Deflector
//
//  Created by Cizzuk on 2026/11/04.
//

import SwiftUI
import UIKit

struct DurationWheelPicker: UIViewRepresentable {
    @Binding var duration: DateComponents

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.backgroundColor = .clear
        select(duration, in: picker)
        return picker
    }

    func updateUIView(_ picker: UIPickerView, context: Context) {
        context.coordinator.parent = self
        if context.coordinator.isSelecting {
            context.coordinator.isSelecting = false
            return
        }
        guard !Self.isScrolling(picker) else { return }
        select(duration, in: picker)
    }

    private func select(_ duration: DateComponents, in picker: UIPickerView) {
        let selection = Self.selection(from: duration)
        if picker.selectedRow(inComponent: 0) != selection.hour {
            picker.selectRow(selection.hour, inComponent: 0, animated: false)
        }
        if picker.selectedRow(inComponent: 1) != selection.minute {
            picker.selectRow(selection.minute, inComponent: 1, animated: false)
        }
        if picker.selectedRow(inComponent: 2) != selection.second {
            picker.selectRow(selection.second, inComponent: 2, animated: false)
        }
    }

    private static func selection(from duration: DateComponents) -> (hour: Int, minute: Int, second: Int) {
        (
            min(max(duration.hour ?? 0, 0), 23),
            min(max(duration.minute ?? 0, 0), 59),
            min(max(duration.second ?? 0, 0), 59)
        )
    }

    private static func isScrolling(_ view: UIView) -> Bool {
        if let scrollView = view as? UIScrollView,
            scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating
        {
            return true
        }
        return view.subviews.contains { isScrolling($0) }
    }

    final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: DurationWheelPicker
        var isSelecting = false
        var isWaitingToCommit = false

        init(_ parent: DurationWheelPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            3
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? 24 : 60
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            let width = pickerView.bounds.width
            guard width > 0 else { return 120 }
            return width / 3
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = view as? UILabel ?? {
                let label = UILabel()
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 23)
                label.textColor = .label
                label.backgroundColor = .clear
                return label
            }()
            label.text = Self.title(for: row, component: component)
            label.accessibilityLabel = Self.accessibilityLabel(for: row, component: component)
            return label
        }

        private static func title(for row: Int, component: Int) -> String {
            switch component {
            case 0:
                String(localized: "\(row) h")
            case 1:
                String(localized: "\(row) min")
            default:
                String(localized: "\(row) s")
            }
        }

        private static func accessibilityLabel(for row: Int, component: Int) -> String {
            switch component {
            case 0:
                String(localized: "\(row) hours")
            case 1:
                String(localized: "\(row) minutes")
            default:
                String(localized: "\(row) seconds")
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent selectedComponent: Int) {
            commit(pickerView)
        }

        private func commit(_ pickerView: UIPickerView) {
            if DurationWheelPicker.isScrolling(pickerView) {
                guard !isWaitingToCommit else { return }
                isWaitingToCommit = true
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.isWaitingToCommit = false
                    self.commit(pickerView)
                }
                return
            }

            let next = DateComponents(
                hour: rowValue(0, in: pickerView, limit: 23),
                minute: rowValue(1, in: pickerView, limit: 59),
                second: rowValue(2, in: pickerView, limit: 59)
            )
            guard next != parent.duration else { return }
            isSelecting = true
            parent.duration = next
        }

        private func rowValue(_ component: Int, in pickerView: UIPickerView, limit: Int) -> Int {
            min(max(pickerView.selectedRow(inComponent: component), 0), limit)
        }
    }
}
