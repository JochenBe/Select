//
//  SelectOutput.swift
//  Select
//
//  Created by Jochen Bernard on 16/09/2022.
//

import Terminal

final class SelectOutput: WindowDelegate {
    private let options: [String]
    private let selectedPrefix: String
    private let unselectedPrefix: String
    private let selectedRendition: GraphicRendition?
    private let unselectedRendition: GraphicRendition?

    private var selectedIndex: Int
    private var output = ""
    private var start = 0

    init(
        options: [String],
        selectedIndex: Int,
        selectedPrefix: String,
        unselectedPrefix: String?,
        selectedRendition: GraphicRendition?,
        unselectedRendition: GraphicRendition?
    ) {
        self.options = options
        self.selectedIndex = selectedIndex

        self.selectedPrefix = selectedPrefix
        self.unselectedPrefix = unselectedPrefix == nil
            ? String(repeating: " ", count: selectedPrefix.count)
            : unselectedPrefix!

        self.selectedRendition = selectedRendition
        self.unselectedRendition = unselectedRendition

        write(update: false)
    }

    func resize() {
        write(update: true)
    }

    func rows(
        options: [String],
        selectedIndex: Int,
        columns: UInt16?
    ) -> [[Substring]] {
        options
            .enumerated()
            .map({
                let selected = $0 == selectedIndex
                let prefix = selected ? selectedPrefix : unselectedPrefix
                let graphicRendition = selected ? selectedRendition : unselectedRendition
                let string = prefix + $1
                let lines = (
                        graphicRendition != nil
                            ? graphicRendition!.string(string)
                            : string
                    )
                    .split(separator: "\n")
                return columns != nil
                    ? lines
                        .flatMap({
                            var string = $0
                            var rows: [Substring] = []

                            while string.count > 0 {
                                rows.append(string.prefix(maxVisibleCharacters: Int(columns!)))
                                string.removeFirst(rows.last!.count)
                            }

                            return rows
                        })
                    : lines
            })
    }

    static func getEnd(options: [[Substring]], start: Int, rows: UInt16) -> Int {
        guard options.count > 0 else {
            return 0
        }

        var end = options.count - 1

        var lines = 0
        for (index, option) in options.enumerated().dropFirst(start) {
            lines += option.count
            guard lines <= rows else {
                end = index - 1
                break
            }
        }

        return max(start, end)
    }

    static func getStart(options: [[Substring]], end: Int, rows: UInt16) -> Int {
        guard options.count > 0 else {
            return 0
        }

        var start = 0

        var lines = 0
        for (index, option) in options.enumerated().dropLast(options.count - 1 - end).reversed() {
            lines += option.count
            guard lines <= rows else {
                start = index + 1
                break
            }
        }

        return min(start, end)
    }

    private func write(update: Bool) {
        let windowSize = Window.getSize()
        let options = rows(
            options: options,
            selectedIndex: selectedIndex,
            columns: windowSize?.columns
        )

        let string: String

        defer {
            if update {
                clear()
            }

            Terminal.write(string)
            self.output += string
        }

        guard let windowSize = windowSize else {
            string = options
                .flatMap({ $0 })
                .joined(separator: "\n")
            return
        }

        var reverse = false
        start = min(self.start, selectedIndex)
        var end = SelectOutput.getEnd(
            options: options,
            start: start,
            rows: windowSize.rows
        )

        if selectedIndex > end {
            reverse = true
            end = selectedIndex
            start = SelectOutput.getStart(
                options: options,
                end: end,
                rows: windowSize.rows
            )
        }

        if !reverse {
            string = options
                .dropFirst(start)
                .flatMap({ $0 })
                .prefix(Int(windowSize.rows))
                .joined(separator: "\n")
        } else {
            string = options
                .prefix(end + 1)
                .flatMap({ $0 })
                .suffix(Int(windowSize.rows))
                .joined(separator: "\n")
        }
    }

    func clear() {
        let lines = output
            .removingGraphicRendition
            .split(separator: "\n")

        let windowSize = Window.getSize()
        let rows = windowSize != nil
            ? lines.map({
                Int(ceil(Float($0.count) / Float(windowSize!.columns)))
            })
            .reduce(0, { $0 + $1 })
            : lines.count

        Cursor.moveToPreviousLine(lines: UInt(rows - 1))
        Window.clear(.fromCursor)
        self.output = ""
    }

    func update(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        write(update: true)
    }
}
