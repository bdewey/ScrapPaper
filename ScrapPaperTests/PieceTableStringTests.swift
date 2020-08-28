// Copyright © 2020 Brian's Brain. All rights reserved.

import ScrapPaper
import XCTest

final class PieceTableStringTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let textStorage = PieceTablePlainTextStorage(plainTextAttributes: [:])
    textStorage.append(NSAttributedString(string: "Hello, world!"))
    textStorage.replaceCharacters(in: NSRange(location: 7, length: 0), with: "zCRuel ")
    textStorage.replaceCharacters(in: NSRange(location: 0, length: 10), with: "Goodbye, cr")
    XCTAssertEqual("Goodbye, cruel world!", textStorage.string)
  }
}
