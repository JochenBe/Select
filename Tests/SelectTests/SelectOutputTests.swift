//
//  SelectOutputTests.swift
//  SelectTests
//
//  Created by Jochen Bernard on 18/09/2022.
//

import XCTest
@testable import Select

final class SelectOutputTests: XCTestCase {
    func testRows() {
        let output = SelectOutput(
            options: [],
            selectedIndex: 0,
            selectedPrefix: "> ",
            unselectedPrefix: nil,
            selectedRendition: nil,
            unselectedRendition: nil
        )

        XCTAssertEqual(
            output.rows(
                options: [],
                selectedIndex: 0,
                columns: 4
            ),
            []
        )

        XCTAssertEqual(
            output.rows(
                options: [
                    "123456789",
                ],
                selectedIndex: 0,
                columns: 4
            ),
            [
                ["> 12", "3456", "789"],
            ]
        )

        XCTAssertEqual(
            output.rows(
                options: [
                    "123456789",
                    "abcdefghi"
                ],
                selectedIndex: 0,
                columns: 4
            ),
            [
                ["> 12", "3456", "789"],
                ["  ab", "cdef", "ghi"]
            ]
        )

        XCTAssertEqual(
            output.rows(
                options: [
                    "1234567",
                    "abcdefg"
                ],
                selectedIndex: 0,
                columns: 3
            ),
            [
                ["> 1", "234", "567"],
                ["  a", "bcd", "efg"]
            ]
        )
    }

    func testGetEnd() {
        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 0,
                rows: 1
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 0,
                rows: 3
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 0,
                rows: 4
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 0,
                rows: 6
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 1,
                rows: 1
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 1,
                rows: 3
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 1,
                rows: 4
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getEnd(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                start: 1,
                rows: 6
            ),
            1
        )
    }

    func testGetStart() {
        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 1,
                rows: 1
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 1,
                rows: 3
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 1,
                rows: 4
            ),
            1
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 1,
                rows: 6
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 0,
                rows: 1
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 0,
                rows: 3
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 0,
                rows: 4
            ),
            0
        )

        XCTAssertEqual(
            SelectOutput.getStart(
                options: [
                    ["> 12", "3456", "789"],
                    ["  ab", "cdef", "ghi"]
                ],
                end: 0,
                rows: 6
            ),
            0
        )
    }
}
