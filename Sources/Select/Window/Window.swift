//
//  Window.swift
//  Select
//
//  Created by Jochen Bernard on 17/09/2022.
//

import Terminal

extension Window {
    static var delegate: WindowDelegate? = nil {
        didSet {
            guard delegate != nil else {
                Signal.WINCH.untrap()
                return
            }

            Signal.WINCH.trap { _ in
                Window.delegate?.resize()
            }
        }
    }
}
