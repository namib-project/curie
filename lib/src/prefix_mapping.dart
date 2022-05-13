// Copyright 2022 The NAMIB Project Developers
// Copyright 2016 Bruce Mitchener, Jr. <bruce.mitchener@gmail.com>
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//
// SPDX-License-Identifier: MIT

import 'curie.dart';
import 'curie_exception.dart';

/// Maps prefixes to base URIs and allows for the expansion of CURIEs (Compact
/// URIs).
class PrefixMapping {
  /// The default prefix value used by this [PrefixMapping] object.
  ///
  /// Will be used as a fallback if no prefix is given in a [Curie].
  String? defaultPrefixValue;

  final Map<String, String> _mappings = {};

  /// Constructor.
  PrefixMapping({this.defaultPrefixValue});

  /// Adds a mapping from a [prefix] to a [prefixValue] IRI.
  ///
  /// This allows this [prefix] to be resolved when a CURIE is expanded.
  ///
  /// Passing the prefix `"_"` is not allowed and will result in an
  /// [InvalidPrefixException] being thrown.
  void addPrefix(String prefix, String prefixValue) {
    if (prefix == "_") {
      throw InvalidPrefixException("The prefix '_' is reserved.");
    }

    _mappings[prefix] = prefixValue;
  }

  /// Return the IRI for a given [prefix], if present.
  String? getPrefixValue(String prefix) {
    return _mappings[prefix];
  }

  /// Remove a [prefix] from the mapping and return the associated IRI value.
  /// If the [prefix] was not registered, `null` is returned instead.
  ///
  /// Future calls to [expandCurieString] or [expandCurie] that use
  /// this [prefix] will result in an [ExpansionException].
  String? removePrefix(String prefix) {
    return _mappings.remove(prefix);
  }

  /// Expand a parsed [curie], returning a complete IRI.
  String expandCurie(Curie curie) {
    return _expandExplodedCurie(
      prefix: curie.prefix,
      reference: curie.reference,
    );
  }

  /// Expand a CURIE, returning a complete IRI.
  String expandCurieString(String curieString) {
    final seperatorIndex = curieString.indexOf(':');
    final String? prefix;
    final String reference;

    if (seperatorIndex != -1) {
      prefix = curieString.substring(0, seperatorIndex);
      reference = curieString.substring(seperatorIndex + 1);
    } else {
      prefix = null;
      reference = curieString;
    }

    final curie = Curie(prefix: prefix, reference: reference);
    return expandCurie(curie);
  }

  String _expandExplodedCurie({String? prefix, required String reference}) {
    if (prefix != null) {
      final value = _mappings[prefix];
      if (value != null) {
        return value + reference;
      }

      throw ExpansionException("The prefix on the CURIE has no valid mapping.");
    }

    final defaultPrefixValue = this.defaultPrefixValue;

    if (defaultPrefixValue != null) {
      return defaultPrefixValue + reference;
    }

    throw ExpansionException(
        "The CURIE uses a default prefix, but none has been set.");
  }

  /// Shrink an [iri] returning a [Curie].
  Curie shrinkIri(String iri) {
    final defaultPrefixValue = this.defaultPrefixValue;

    if (defaultPrefixValue != null && iri.startsWith(defaultPrefixValue)) {
      final reference = iri.replaceFirst(defaultPrefixValue, "");
      return Curie(reference: reference);
    }

    for (final mapping in _mappings.entries) {
      if (iri.startsWith(mapping.value)) {
        final reference = iri.replaceFirst(mapping.value, "");
        return Curie(
          prefix: mapping.key,
          reference: reference,
        );
      }
    }

    throw IriException("Unable to shorten.");
  }
}

/// [Exception] that might occur during the expansion of [Curie] objects and
/// CURIE strings.
class ExpansionException extends CurieException {
  /// Constructor.
  ExpansionException(super.message);
}

/// [Exception] that might occur when adding a prefix to a [PrefixMapping].
class InvalidPrefixException extends CurieException {
  /// Constructor.
  InvalidPrefixException(super.message);
}

/// [Exception] that might occur during IRI shrinking.
class IriException extends CurieException {
  /// Constructor.
  IriException(super.message);
}
