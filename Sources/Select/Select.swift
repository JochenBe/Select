//
//  Select.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

public func select<T>(options: [T]) -> T? {
    let termios = Mode.get()

    LocalMode.icanon.unset()
    LocalMode.echo.unset()

    var index = 0
    while let arrowKey = readArrowKey() {
        switch arrowKey {
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
        }
        
        print(index)
    }

    if let termios = termios {
        Mode.set(termios: termios)
    }

    return nil
}
