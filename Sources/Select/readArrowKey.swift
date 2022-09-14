//
//  readArrowKey.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

func readArrowKey() -> ArrowKey? {
    var index = 0
    let sequence: [Character] = ["\u{1B}", "["]
    while let character = read() {
        guard index >= sequence.count else {
            if character == sequence[index] {
                index += 1
            } else {
                index = 0
            }

            continue
        }

        switch character {
        case "A":
            return .up
        case "B":
            return .down
        default:
            index = 0
        }
    }

    return nil
}
