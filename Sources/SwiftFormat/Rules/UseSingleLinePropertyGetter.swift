//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

/// Read-only computed properties must use implicit `get` blocks.
///
/// Lint: Read-only computed properties with explicit `get` blocks yield a lint error.
///
/// Format: Explicit `get` blocks are rendered implicit by removing the `get`.
@_spi(Rules)
public final class UseSingleLinePropertyGetter: SyntaxFormatRule {

  public override func visit(_ node: PatternBindingSyntax) -> PatternBindingSyntax {
    guard
      let accessorBlock = node.accessorBlock,
      case .accessors(let accessors) = accessorBlock.accessors,
      let acc = accessors.first,
      let body = acc.body,
      accessors.count == 1,
      acc.accessorSpecifier.tokenKind == .keyword(.get),
      acc.modifier == nil,
      acc.effectSpecifiers == nil
    else { return node }

    diagnose(.removeExtraneousGetBlock, on: acc)

    var result = node
    result.accessorBlock?.accessors = .getter(body.statements)
    return result
  }
}

extension Finding.Message {
  @_spi(Rules)
  public static let removeExtraneousGetBlock: Finding.Message =
    "remove 'get {...}' around the accessor and move its body directly into the computed property"
}
