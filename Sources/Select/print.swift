//
//  print.swift
//  Select
//
//  Created by Jochen Bernard on 15/09/2022.
//

import Terminal

func print<T>(
    options: [T],
    selectedPrefix: String,
    unselectedPrefix: String?,
    selectedRendition: GraphicRendition?,
    unselectedRendition: GraphicRendition?,
    index: Int
) {
    for (i, option) in options.enumerated() {
        let selected = i == index
        let rendition = selected ? selectedRendition : unselectedRendition
        let prefix = selected
            ? selectedPrefix
            : unselectedPrefix != nil
                ? unselectedPrefix!
                : String(repeating: " ", count: selectedPrefix.count)

        let string = prefix + String(describing: option)
        write(
            rendition != nil
                ? rendition!.string(string)
                : string,
            terminator: i != options.count - 1 ? "\n" : ""
        )
    }
}
