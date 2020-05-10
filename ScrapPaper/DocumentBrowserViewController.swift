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

import Logging
import SwiftUI
import TextMarkupKit
import UIKit

private let logger = Logger(label: "DocumentBrowserViewController")

final class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    allowsDocumentCreation = true
    allowsPickingMultipleItems = false

    // Update the style of the UIDocumentBrowserViewController
    // browserUserInterfaceStyle = .dark
    // view.tintColor = .white

    // Specify the allowed content types of your application via the Info.plist.

    // Do any additional setup after loading the view.
  }

  // MARK: UIDocumentBrowserViewControllerDelegate

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
  ) {
    let directoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    do {
      try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    } catch {
      logger.error("Unable to create temporary directory at \(directoryURL.path): \(error)")
      importHandler(nil, .none)
    }
    let url = directoryURL.appendingPathComponent("scrap").appendingPathExtension("txt")
    let data = "# Welcome to scrap paper.\n\n".data(using: .utf8)!
    do {
      try data.write(to: url)
      importHandler(url, .move)
    } catch {
      logger.error("Unable to create document template: \(error)")
      importHandler(nil, .none)
    }
  }

  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
    guard let sourceURL = documentURLs.first else { return }

    // Present the Document View Controller for the first document that was picked.
    // If you support picking multiple items, make sure you handle them all.
    presentDocument(at: sourceURL)
  }

  func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
    // Present the Document View Controller for the new newly created document
    presentDocument(at: destinationURL)
  }

  func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
  }

  // MARK: Document Presentation

  private let defaultAttributes: AttributedStringAttributes = {
    var defaultAttributes = AttributedStringAttributes()
    defaultAttributes.font = UIFont.preferredFont(forTextStyle: .body)
    defaultAttributes.color = .label
    defaultAttributes.headIndent = 28
    defaultAttributes.firstLineHeadIndent = 28
    return defaultAttributes
  }()

  private let formattingFunctions: [NodeType: FormattingFunction] = {
    let formattingFunctions: [NodeType: FormattingFunction] = [
      .delimiter: { $1.color = .tertiaryLabel },
      .emphasis: { $1.italic = true },
      .hashtag: { $1.backgroundColor = .secondarySystemBackground },
      .header: {
        let headingDelimiter = $0.children[0]
        assert(headingDelimiter.type == .delimiter)
        switch headingDelimiter.length {
        case 1:
          $1.textStyle = .title1
        case 2:
          $1.textStyle = .title2
        case 3:
          $1.textStyle = .title3
        default:
          $1.bold = true
        }
        $1.listLevel = 1
      },
      .list: { $1.listLevel += 1 },
      .strongEmphasis: { $1.bold = true },
    ]
    return formattingFunctions
  }()

  private let replacementFunctions: [NodeType: ReplacementFunction] = [
    .softTab: { _, _ in Array("\t".utf16) },
    .unorderedListOpening: { _, _ in Array("\u{2022}".utf16) },
  ]

  func presentDocument(at documentURL: URL) {
    let document = IncrementalParsingTextDocument(
      fileURL: documentURL,
      grammar: MiniMarkdownGrammar(),
      defaultAttributes: defaultAttributes,
      formattingFunctions: formattingFunctions,
      replacementFunctions: replacementFunctions
    )

    // Access the document
    document.open(completionHandler: { success in
      if success {
        // Display the content of the document:
        let view = DocumentView(document: document, dismiss: {
          self.closeDocument(document)
        })

        let documentViewController = UIHostingController(rootView: view)
        self.present(documentViewController, animated: true, completion: nil)
      } else {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
      }
    })
  }

  func closeDocument(_ document: IncrementalParsingTextDocument) {
    dismiss(animated: true) {
      document.close(completionHandler: nil)
    }
  }
}
