// Copyright 2022 The NAMIB Project Developers
// Copyright 2016 Bruce Mitchener, Jr. <bruce.mitchener@gmail.com>
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//
// SPDX-License-Identifier: MIT

/// A [prefix] and [reference], already parsed into separate components.
///
/// When parsing a document, the components of the compact URI will already
/// have been parsed and we can avoid storing a string of the full compact
/// URI and having to do that work again when expanding the compact URI.
class Curie {
  /// The prefix of this [Curie].
  final String? prefix;

  /// The reference of this [Curie].
  final String reference;

  /// Constructor
  Curie({this.prefix, required this.reference});

  @override
  String toString() {
    if (prefix != null) {
      return "$prefix:$reference";
    }

    return reference;
  }

  @override
  int get hashCode => Object.hash(prefix, reference);

  @override
  bool operator ==(Object other) {
    if (other is Curie) {
      return other.prefix == prefix && other.reference == reference;
    }

    return false;
  }
}
