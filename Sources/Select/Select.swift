//
//  Select.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

public func select<T>(options: [T], allowEscape: Bool = true) -> T? {
    let termios = Mode.get()

    Mode.unset(localModes: [.icanon, .echo])

    var index = 0
    print(index)

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
        
        print(index)
    }

    if let termios = termios {
        Mode.set(termios: termios)
    }

    return index >= 0 ? options[index] : nil
}
