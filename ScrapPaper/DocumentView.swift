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

import SwiftUI

/// Displays and allows editing the contents of a TextStorageDocument.
struct DocumentView: View {
  /// The document to edit.
  var document: TextStorageDocument

  /// A block to invoke to dismiss this view.
  var dismiss: () -> Void

  @EnvironmentObject var performanceCounters: PerformanceCounters

  var body: some View {
    NavigationView {
      TextView(textStorage: document.textStorage)
        .overlay(VStack {
          Spacer()
          Text("Key timing: \(performanceCounters.counters["typing"]?.mean ?? 0.0) ms")
        })
        .navigationBarItems(trailing: Button("Done", action: dismiss))
        .navigationBarTitle(Text(document.fileURL.lastPathComponent), displayMode: .inline)
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}
