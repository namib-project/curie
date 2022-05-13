// Copyright 2022 The NAMIB Project Developers
// Copyright 2016 Bruce Mitchener, Jr. <bruce.mitchener@gmail.com>
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//
// SPDX-License-Identifier: MIT

/// Base class for this library's [Exception]s.
abstract class CurieException implements Exception {
  final String _message;

  /// Constructor.
  CurieException(this._message);

  @override
  String toString() {
    return "$runtimeType: $_message";
  }
}
