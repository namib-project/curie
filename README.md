[![pub package](https://img.shields.io/pub/v/curie.svg)](https://pub.dev/packages/curie)
[![Build](https://github.com/namib-project/curie/actions/workflows/ci.yml/badge.svg)](https://github.com/namib-project/curie/actions/workflows/ci.yml)

# curie

Implementation of the [W3C CURIE Syntax 1.0](https://www.w3.org/TR/curie/),
based on Bruce Mitchener, Jr.'s [Rust crate](https://crates.io/crates/curie).

CURIEs are a compact way of representing a URI, consisting of an optional prefix
and a reference, separated by a colon.
They are commonly used in JSON-LD, RDF, SPARQL, XML namespaces and other
applications.

This library provides classes and methods for creating and manipulating CURIEs,
making them easier to handle in your libraries and applications.

## Usage

A simple example for how to use the package can be found below and in the
`/example` folder.

```dart
import 'package:curie/curie.dart';

void main() {
  // Initialize a prefix mapper.
  final mapper = PrefixMapping()
    ..addPrefix("foaf", "http://xmlns.com/foaf/0.1/")
    // Set a default prefix value
    ..defaultPrefixValue = "http://example.com/";

  // Prints "http://example.com/Entity"
  print(mapper.expandCurieString("Entity"));

  // Prints "http://xmlns.com/foaf/0.1/Agent"
  print(mapper.expandCurieString("foaf:Agent"));

  final curie = Curie(prefix: "foaf", reference: "Agent");

  // Prints "http://xmlns.com/foaf/0.1/Agent"
  print(mapper.expandCurie(curie));

  // Creates a Curie object that prints "foaf:Agent"
  print(mapper.shrinkIri("http://xmlns.com/foaf/0.1/Agent"));
}
```
