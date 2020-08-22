// Copyright © 2020 Brian's Brain. All rights reserved.

import Foundation
import UIKit

/// An implementation of NSTextStorage that uses a PieceTable for storing text and always returns a set of default attributes.
public final class PieceTablePlainTextStorage: NSTextStorage {
  init(plainTextAttributes: [NSAttributedString.Key: Any]) {
    self.plainTextAttributes = plainTextAttributes
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// The attributes returned for any character in the text storage -- this is plain text storage, not rich text storage!
  private var plainTextAttributes: [NSAttributedString.Key: Any]

  /// The piece table that holds the plain text.
  private var pieceTable = PieceTable()

  // MARK: - NSAttributedString primitives

  private var memoizedString: String?

  /// Return the text contents as a string.
  public override var string: String {
    if let memoizedString = memoizedString {
      return memoizedString
    }
    let string = String(utf16CodeUnits: pieceTable[pieceTable.startIndex ..< pieceTable.endIndex], count: pieceTable.count)
    memoizedString = string
    return string
  }

  /// As this is plain text storage, it will always return the same set of attributes.
  public override func attributes(
    at location: Int,
    effectiveRange range: NSRangePointer?
  ) -> [NSAttributedString.Key : Any] {
    if let range = range {
      range.pointee = NSRange(location: 0, length: pieceTable.count)
    }
    return plainTextAttributes
  }

  // MARK: - NSMutableAttributedString primitives

  public override func replaceCharacters(in range: NSRange, with str: String) {
    let replacementStartIndex = pieceTable.index(pieceTable.startIndex, offsetBy: range.location)
    let replacementEndIndex = pieceTable.index(replacementStartIndex, offsetBy: range.length)
    pieceTable.replaceSubrange(replacementStartIndex ..< replacementEndIndex, with: str.utf16)
    memoizedString = nil
    edited([.editedCharacters], range: range, changeInLength: str.utf16.count - range.length)
  }

  /// This is _supposed_ to set attributes just for the given range. However, this is "plain text" storage and we always apply
  /// attributes to the entire contents of the storage.
  public override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
    // NOTHING
  }
}
