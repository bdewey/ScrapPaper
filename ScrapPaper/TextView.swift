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

import os
import SwiftUI
import UIKit

private let log = OSLog(subsystem: "org.brians-brain.ScrapPaper", category: "TextView")

/// Exposes a UITextView in SwiftUI.
/// The underlying data for the UITextView comes directly from an NSTextStorage instance.
struct TextView: UIViewRepresentable {
  let textStorage: NSTextStorage

  /// Creates a UITextView bound to `textStorage`
  func makeUIView(context: Context) -> UITextView {
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    let textView = ReadableTextView(frame: .zero, textContainer: textContainer)
    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {}
}

struct IncrementalParsingTextView_Previews: PreviewProvider {
  static var previews: some View {
    TextView(textStorage: NSTextStorage())
  }
}

/// This is a simple subclass that constrains the text container to the readableContentGuide.
private final class ReadableTextView: UITextView {
  override func layoutSubviews() {
    super.layoutSubviews()
    textContainerInset = UIEdgeInsets(
      top: 8,
      left: readableContentGuide.layoutFrame.minX,
      bottom: 8,
      right: bounds.maxX - readableContentGuide.layoutFrame.maxX
    )
  }

  override func insertText(_ text: String) {
    os_signpost(.begin, log: log, name: "keystroke")
    super.insertText(text)
    os_signpost(.end, log: log, name: "keystroke")
  }
}
