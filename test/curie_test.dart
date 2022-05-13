// Copyright 2022 The NAMIB Project Developers
// Copyright 2016 Bruce Mitchener, Jr. <bruce.mitchener@gmail.com>
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
//
// SPDX-License-Identifier: MIT

import 'package:curie/curie.dart';
import 'package:test/test.dart';

const testIri = "http://xmlns.com/foaf/0.1/";
const testPrefix = "foaf";
const unusedTestPrefix = "rdfs";

void main() {
  group('PrefixMapping', () {
    test(' allows for adding, retrieving, and deleting prefixes', () {
      final prefixMapping = PrefixMapping();

      // No keys should be found.
      expect(prefixMapping.getPrefixValue(testPrefix), null);

      // // Add and look up a key.
      expect(
          () => prefixMapping.addPrefix(testPrefix, testIri), returnsNormally);
      expect(prefixMapping.getPrefixValue(testPrefix), testIri);

      // // Unrelated keys still can not be found.
      expect(prefixMapping.getPrefixValue(unusedTestPrefix), null);

      // Can't add _ as that's reserved.
      expect(() => prefixMapping.addPrefix("_", "value"),
          throwsA(TypeMatcher<InvalidPrefixException>()));

      // // Keys can be removed.
      expect(prefixMapping.removePrefix(testPrefix), testIri);

      // The "foaf" key should not be found.
      expect(prefixMapping.getPrefixValue(testPrefix), null);
    });

    test('.expandCurieString() works as expected', () {
      final mapping = PrefixMapping();
      final curie = "foaf:Person";

      // A CURIE with an unmapped prefix isn't expanded.
      expect(
          () => mapping.expandCurieString(curie),
          throwsA(predicate((e) =>
              e is ExpansionException &&
              e.toString() ==
                  'ExpansionException: The prefix on the CURIE has no valid '
                      'mapping.')));

      // A CURIE without a separator doesn't cause problems. It still
      // requires a default though.
      expect(
          () => mapping.expandCurieString("Person"),
          throwsA(predicate((e) =>
              e is ExpansionException &&
              e.toString() ==
                  'ExpansionException: The CURIE uses a default prefix, but '
                      'none has been set.')));

      const testPrefixValue = "http://example.com/";
      mapping.defaultPrefixValue = testPrefixValue;

      expect(mapping.expandCurieString("Person"), "${testPrefixValue}Person");

      // Using a colon without a prefix results in using a prefix
      // for an empty string.
      expect(
          () => mapping.expandCurieString(":Person"),
          throwsA(predicate((e) =>
              e is ExpansionException &&
              e.toString() ==
                  'ExpansionException: The prefix on the CURIE has no valid '
                      'mapping.')));
      mapping.addPrefix("", "${testPrefixValue}ExampleDocument#");
      expect(mapping.expandCurieString(":Person"),
          "${testPrefixValue}ExampleDocument#Person");

      // And having a default won't allow a prefixed CURIE to
      // be expanded with the default.
      expect(
          () => mapping.expandCurieString(curie),
          throwsA(predicate((e) =>
              e is ExpansionException &&
              e.toString() ==
                  'ExpansionException: The prefix on the CURIE has no valid '
                      'mapping.')));

      mapping.addPrefix(testPrefix, testIri);

      // A CURIE with a mapped prefix is expanded correctly.
      expect(mapping.expandCurieString(curie), "${testIri}Person");
    });

    test('.expandCurie() handles defined prefixes', () {
      final mapping = PrefixMapping()..addPrefix(testPrefix, testIri);

      final curie = Curie(prefix: testPrefix, reference: "Agent");
      expect(mapping.expandCurie(curie), "${testIri}Agent");
    });

    test('.expandCurie() uses the default prefix as fallback', () {
      final mapping = PrefixMapping()..defaultPrefixValue = testIri;

      final curie = Curie(reference: "Agent");
      expect(mapping.expandCurie(curie), "${testIri}Agent");
    });

    test('.shrinkIri() handles defined prefixes', () {
      final mapping = PrefixMapping()..addPrefix(testPrefix, testIri);

      final curie = Curie(prefix: testPrefix, reference: "Agent");
      expect(mapping.shrinkIri("${testIri}Agent"), curie);
    });

    test('.shrinkIri() uses the default prefix as fallback', () {
      final mapping = PrefixMapping()..defaultPrefixValue = testIri;

      final curie = Curie(reference: "Agent");
      expect(mapping.shrinkIri("${testIri}Agent"), curie);
    });

    test('.shrinkIri() should throw an exception if no prefix value found', () {
      final mapping = PrefixMapping();

      expect(
          () => mapping.shrinkIri(testIri),
          throwsA(predicate((e) =>
              e is IriException &&
              e.toString() == 'IriException: Unable to shorten.')));
    });
  });

  group('Curie', () {
    test('.toString() returns the correct string representation', () {
      final curie = Curie(prefix: "foaf", reference: "Agent");
      expect(curie.toString(), "foaf:Agent");

      final curie2 = Curie(reference: "Agent");
      expect(curie2.toString(), "Agent");
    });

    test('.hashCode should be identical for equivalent Curie objects', () {
      final curie1 = Curie(prefix: "test", reference: "testtest2");
      final curie2 = Curie(prefix: "test", reference: "testtest2");

      expect(curie1.hashCode, curie2.hashCode);
    });
  });
}
