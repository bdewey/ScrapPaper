// Copyright © 2020 Brian's Brain. All rights reserved.

import ScrapPaper
import XCTest

final class PieceTableStringTests: XCTestCase {
  func testGetCharacters() {
    let pieceTableString = PieceTableString()
    pieceTableString.append("Hello world")
    XCTAssertEqual("Hello world", pieceTableString as String)
    pieceTableString.replaceCharacters(in: NSRange(location: 5, length: 0), with: ",")
    XCTAssertEqual("Hello, world", pieceTableString as String)
    let rangeToExtract = NSRange(location: 5, length: pieceTableString.length - 6)
    var characters = Array<unichar>(repeating: 0, count: rangeToExtract.length)
    pieceTableString.getCharacters(&characters, range: rangeToExtract)
    let resultString = String(utf16CodeUnits: characters, count: characters.count)
    XCTAssertEqual(resultString, ", worl")
  }
}
