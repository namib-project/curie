// Copyright 2022 The NAMIB Project Developers
// Copyright 2016 Bruce Mitchener, Jr. <bruce.mitchener@gmail.com>
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//
// SPDX-License-Identifier: MIT

/// Implementation of the [W3C CURIE Syntax 1.0](https://www.w3.org/TR/curie/),
/// based on Bruce Mitchener, Jr.'s [Rust crate](https://crates.io/crates/curie).
///
/// CURIEs are a compact way of representing a URI, consisting of an optional
/// prefix and a reference, separated by a colon.
///
/// They are commonly used in JSON-LD, RDF, SPARQL, XML namespaces and other
/// applications.
/// This library provides classes and methods for creating and manipulating
/// CURIEs, making them easier to handle in your libraries and applications.
library curie;

export 'src/curie.dart';
export 'src/prefix_mapping.dart';
