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

import TextMarkupKit
import UIKit

/// The contents of a file exposed as a single string.
final class IncrementalParsingTextDocument: UIDocument {
  init(
    fileURL: URL,
    grammar: PackratGrammar,
    defaultAttributes: AttributedStringAttributes,
    formattingFunctions: [NodeType: FormattingFunction],
    replacementFunctions: [NodeType: ReplacementFunction]
  ) {
    self.textStorage = IncrementalParsingTextStorage(
      grammar: grammar,
      defaultAttributes: defaultAttributes,
      formattingFunctions: formattingFunctions,
      replacementFunctions: replacementFunctions
    )
    super.init(fileURL: fileURL)
    textStorage.delegate = self
  }

  static let errorDomain = "org.brians-brain.PlainTextDocument"

  enum Error: Int {
    case invalidContentsFormat
  }

  /// The file contents.
  let textStorage: IncrementalParsingTextStorage

  override func contents(forType typeName: String) throws -> Any {
    textStorage.rawText.data(using: .utf8)!
  }

  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    guard let data = contents as? Data else {
      throw NSError(domain: Self.errorDomain, code: Error.invalidContentsFormat.rawValue, userInfo: nil)
    }
    textStorage.setAttributedString(NSAttributedString(string: String(data: data, encoding: .utf8)!))
  }
}

extension IncrementalParsingTextDocument: NSTextStorageDelegate {
  func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
    updateChangeCount(.done)
  }
}
