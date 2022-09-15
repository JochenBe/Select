//
//  Select.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

public func select<T>(
    options: [T],
    selectedPrefix: String = "> ",
    unselectedPrefix: String? = nil,
    selectedRendition: GraphicRendition? = .fgCyan,
    unselectedRendition: GraphicRendition? = nil,
    cleanup: Bool = true,
    allowEscape: Bool = true
) -> T? {
    guard options.count > 1 else {
        if options.count == 0 {
            return nil
        } else {
            return options.first!
        }
    }

    let termios = Mode.get()

    Mode.unset(localModes: [.icanon, .echo])

    Signal.trap([.INT]) { _ in
        write("\n")
        Cursor.unhide()
        exit(0)
    }

    Cursor.hide()

    var index = 0
    print(
        options: options,
        selectedPrefix: selectedPrefix,
        unselectedPrefix: unselectedPrefix,
        selectedRendition: selectedRendition,
        unselectedRendition: unselectedRendition,
        index: index
    )
    
wh: while let key = readKey() {
        switch key {
        case .up:
            guard index > 0 else {
                continue
            }

            index -= 1
        case .down:
            guard index < options.count - 1 else {
                continue
            }

            index += 1
        case .escape:
            if allowEscape {
                index = -1
                break wh
            } else {
                continue
            }
        }

        Cursor.moveTo(column: 1)
        Cursor.moveUp(cells: UInt(options.count - 1))
        Window.clear(.fromCursor)

        print(
            options: options,
            selectedPrefix: selectedPrefix,
            unselectedPrefix: unselectedPrefix,
            selectedRendition: selectedRendition,
            unselectedRendition: unselectedRendition,
            index: index
        )
    }

    if cleanup {
        Cursor.moveTo(column: 1)
        Cursor.moveUp(cells: UInt(options.count - 1))
        Window.clear(.fromCursor)
    }

    Cursor.unhide()
    Signal.untrap([.INT])

    if let termios = termios {
        Mode.set(termios: termios)
    }

    return index >= 0 ? options[index] : nil
}
