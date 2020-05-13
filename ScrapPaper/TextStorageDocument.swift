//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.

import UIKit

/// Exposes a plain text file as an NSTextStorage instance.
final class TextStorageDocument: UIDocument {
  /// The encoding we use for all text files.
  static let encoding = String.Encoding.utf8

  /// Designated initializer. Creates the `textStorage` and sets itself up as the delegate.
  override init(
    fileURL: URL
  ) {
    self.textStorage = NSTextStorage()
    super.init(fileURL: fileURL)
    textStorage.delegate = self
  }

  /// The file contents.
  let textStorage: NSTextStorage

  /// Private flag letting us know if we are in the middle of loading contents from disk.
  private var loadingContents = false

  override func contents(forType typeName: String) throws -> Any {
    // This is a plain-text document; we just save the textStorage and ignore its attributes.
    textStorage.string.data(using: Self.encoding)!
  }

  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    guard let data = contents as? Data else {
      throw NSError(domain: Self.errorDomain, code: Error.invalidContentsFormat.rawValue, userInfo: nil)
    }

    // Create an NSAttributedString based on the text contents with default attributes that work
    // with dynamic type and dark mode.

    let attributedString = NSAttributedString(
      string: String(data: data, encoding: Self.encoding)!,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .body),
        .foregroundColor: UIColor.label,
      ]
    )

    // Setting the contents of `textStorage` will cause a delegate message; we don't want to
    // *save* the contents we just *loaded*.
    loadingContents = true
    textStorage.setAttributedString(attributedString)
    loadingContents = false
  }
}

// MARK: - NSTextStorageDelegate

extension TextStorageDocument: NSTextStorageDelegate {
  func textStorage(
    _ textStorage: NSTextStorage,
    didProcessEditing editedMask: NSTextStorage.EditActions,
    range editedRange: NSRange, changeInLength delta: Int
  ) {
    guard editedMask.contains(.editedCharacters), !loadingContents else { return }

    // If characters change, let the UIDocument infrastructure know so auto-save will work.
    updateChangeCount(.done)
  }
}

// MARK: - Errors

extension TextStorageDocument {
  /// Error domain for our NSErrors
  static let errorDomain = "org.brians-brain.PlainTextDocument"

  /// Individual error codes.
  enum Error: Int {
    /// We expected to get UTF-8 encode data but got something else.
    case invalidContentsFormat
  }
}
