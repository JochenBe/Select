//
//  Select.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

let signals: [Signal] = [
    .INT,
    .TERM
]

public func select<T>(
    options: [T],
    selectedPrefix: String = "> ",
    unselectedPrefix: String? = nil,
    selectedRendition: GraphicRendition? = .fgCyan,
    unselectedRendition: GraphicRendition? = nil,
    cleanup: Bool = true,
    allowEscape: Bool = true
) -> T? {
    if Cursor.getPosition()?.column != 1 {
        Terminal.write("\n")
    }

    guard options.count > 1 else {
        if options.count == 1 {
            return options.first!
        } else {
            return nil
        }
    }

    let termios = Mode.get()
    Mode.unset(localModes: [.icanon, .echo])
    Signal.trap(signals) { _ in
        write("\n")
        Cursor.unhide()
        exit(0)
    }

    Cursor.hide()

    var selectedIndex = 0
    let output = SelectOutput(
        options: options.map({ String(describing: $0) }),
        selectedIndex: selectedIndex,
        selectedPrefix: selectedPrefix,
        unselectedPrefix: unselectedPrefix,
        selectedRendition: selectedRendition,
        unselectedRendition: unselectedRendition
    )

    Window.delegate = output

wh: while let key = readKey() {
        switch key {
        case .up:
            guard selectedIndex > 0 else {
                continue
            }

            selectedIndex -= 1
        case .down:
            guard selectedIndex < options.count - 1 else {
                continue
            }

            selectedIndex += 1
        case .escape:
            if allowEscape {
                selectedIndex = -1
                break wh
            } else {
                continue
            }
        }

        output.update(selectedIndex: selectedIndex)
    }

    Window.delegate = nil

    if cleanup {
        output.clear()
    }

    Cursor.unhide()
    Signal.untrap(signals)

    if let termios = termios {
        Mode.set(termios: termios)
    }

    return selectedIndex >= 0 ? options[selectedIndex] : nil
}
