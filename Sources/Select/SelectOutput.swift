//
//  SelectOutput.swift
//  Select
//
//  Created by Jochen Bernard on 16/09/2022.
//

import Terminal

final class SelectOutput {
    private let options: [String]
    private let selectedPrefix: String
    private let unselectedPrefix: String
    private let selectedRendition: GraphicRendition?
    private let unselectedRendition: GraphicRendition?

    private var output: String = ""

    init(
        options: [String],
        selectedIndex: Int,
        selectedPrefix: String,
        unselectedPrefix: String?,
        selectedRendition: GraphicRendition?,
        unselectedRendition: GraphicRendition?
    ) {
        self.options = options

        self.selectedPrefix = selectedPrefix
        self.unselectedPrefix = unselectedPrefix == nil
            ? String(repeating: " ", count: selectedPrefix.count)
            : unselectedPrefix!

        self.selectedRendition = selectedRendition
        self.unselectedRendition = unselectedRendition

        write(selectedIndex: selectedIndex)
    }

    private func write(selectedIndex: Int) {
        for (index, option) in options.enumerated() {
            let selected = index == selectedIndex
            let prefix = selected ? selectedPrefix : unselectedPrefix
            let rendition = selected ? selectedRendition : unselectedRendition
            let string = prefix + option

            self.output += rendition != nil ? rendition!.string(string) : string

            if index != options.count - 1 {
                self.output += "\n"
            }
        }

        Terminal.write(self.output)
    }

    func clear() {
        let lines = output
            .withoutGraphicRendition
            .split(separator: "\n")

        let windowSize = Window.getSize()
        let lineCount = windowSize != nil
            ? lines.map {
                    Int(ceil(Float($0.count) / Float(windowSize!.columns)))
                }
                .reduce(0, { $0 + $1 })
            : lines.count

        Cursor.moveToPreviousLine(lines: UInt(lineCount - 1))
        Window.clear(.fromCursor)
        self.output = ""
    }

    func update(selectedIndex: Int) {
        clear()
        write(selectedIndex: selectedIndex)
    }
}
