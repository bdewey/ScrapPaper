// Copyright © 2020 Brian's Brain. All rights reserved.

import ScrapPaper
import XCTest

private extension PieceTablePlainTextStorage {
  convenience init(_ str: String? = nil) {
    self.init(plainTextAttributes: [:])
    if let str = str {
      append(NSAttributedString(string: str))
    }
  }
}

final class PieceTablePlainTextStorageTests: XCTestCase {
  func testOriginalLength() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world")
    XCTAssertEqual(12, pieceTable.length)
    XCTAssertEqual("Hello, world", pieceTable.string)
  }

  func testAppendSingleCharacter() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world")
    pieceTable.replaceCharacters(in: NSRange(location: 12, length: 0), with: "!")
    XCTAssertEqual("Hello, world!", pieceTable.string)
  }

  func testInsertCharacterInMiddle() {
    let pieceTable = PieceTablePlainTextStorage("Hello world")
    pieceTable.replaceCharacters(in: NSRange(location: 5, length: 0), with: ",")
    XCTAssertEqual("Hello, world", pieceTable.string)
  }

  func testDeleteCharacterInMiddle() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world")
    pieceTable.replaceCharacters(in: NSRange(location: 5, length: 1), with: "")
    XCTAssertEqual("Hello world", pieceTable.string)
  }

  func testDeleteFromBeginning() {
    let pieceTable = PieceTablePlainTextStorage("_Hello, world")
    pieceTable.replaceCharacters(in: NSRange(location: 0, length: 1), with: "")
    XCTAssertEqual("Hello, world", pieceTable.string)
  }

  func testDeleteAtEnd() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world!?")
    pieceTable.replaceCharacters(in: NSRange(location: pieceTable.length - 1, length: 1), with: "")
    XCTAssertEqual("Hello, world!", pieceTable.string)
  }

  func testInsertAtBeginning() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world!")
    pieceTable.replaceCharacters(in: NSRange(location: 0, length: 0), with: "¡")
    XCTAssertEqual("¡Hello, world!", pieceTable.string)
  }

  func testLeftOverlappingEditRange() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let textStorage = PieceTablePlainTextStorage(plainTextAttributes: [:])
    textStorage.append(NSAttributedString(string: "Hello, world!"))
    textStorage.replaceCharacters(in: NSRange(location: 7, length: 0), with: "zCRuel ")
    textStorage.replaceCharacters(in: NSRange(location: 0, length: 10), with: "Goodbye, cr")
    XCTAssertEqual("Goodbye, cruel world!", textStorage.string)
  }

  func testRightOverlappingEditRange() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world!")
    pieceTable.replaceCharacters(in: NSRange(location: 4, length: 2), with: "a,")
    pieceTable.replaceCharacters(in: NSRange(location: 5, length: 2), with: "!! ")
    XCTAssertEqual("Hella!! world!", pieceTable.string)
  }

  func testDeleteAddedOverlappingRange() {
    let pieceTable = PieceTablePlainTextStorage("Hello, world!")
    pieceTable.replaceCharacters(in: NSRange(location: 7, length: 0), with: "nutty ")
    pieceTable.replaceCharacters(in: NSRange(location: 5, length: 13), with: "")
    XCTAssertEqual("Hello!", pieceTable.string)
  }

  func testAppend() {
    let pieceTable = PieceTablePlainTextStorage("")
    pieceTable.replaceCharacters(in: NSRange(location: 0, length: 0), with: "Hello, world!")
    XCTAssertEqual(pieceTable.string, "Hello, world!")
  }

  func testRepeatedAppend() {
    let pieceTable = PieceTablePlainTextStorage()
    let expected = "Hello, world!!"
    for ch in expected {
      pieceTable.replaceCharacters(in: NSRange(location: pieceTable.length, length: 0), with: String(ch))
    }
    XCTAssertEqual(expected, pieceTable.string as String)
  }

  func testAppendPerformance() {
    measure {
      let pieceTable = PieceTablePlainTextStorage("")
      for i in 0 ..< 1024 {
        pieceTable.replaceCharacters(in: NSRange(location: i, length: 0), with: ".")
      }
    }
  }

  /// This does two large "local" edits. First it puts 512 characters sequentially into the buffer.
  /// Then it puts another 512 characters sequentially into the middle.
  /// Logically this can be represented in 3 runs so manipulations should stay fast.
  func testLargeLocalEditPerformance() {
    let expected = String(repeating: "A", count: 256) + String(repeating: "B", count: 512) + String(repeating: "A", count: 256)
    measure {
      let pieceTable = PieceTablePlainTextStorage("")
      for i in 0 ..< 512 {
        pieceTable.replaceCharacters(in: NSRange(location: i, length: 0), with: "A")
      }
      for i in 0 ..< 512 {
        pieceTable.replaceCharacters(in: NSRange(location: 256 + i, length: 0), with: "B")
      }
      XCTAssertEqual(pieceTable.string as String, expected)
    }
  }

}
