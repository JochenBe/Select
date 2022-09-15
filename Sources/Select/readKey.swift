//
//  readKey.swift
//  Select
//
//  Created by Jochen Bernard on 14/09/2022.
//

import Terminal

func readKey() -> Key? {
    var sequence = false
    while let character = read() {
        guard character != "\n" else {
            return nil
        }

        guard character != "\u{1B}" else {
            var fds = pollfd(fd: STDIN_FILENO, events: Int16(POLLIN), revents: 0)
            if poll(&fds, 1, 0) > 0 && read() == "[" {
                sequence = true
                continue
            } else {
                return .escape
            }
        }

        guard sequence else {
            continue
        }

        switch character {
        case "A":
            return .up
        case "B":
            return .down
        default:
            sequence = false
        }
    }

    return nil
}
