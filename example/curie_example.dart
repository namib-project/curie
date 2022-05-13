import 'package:curie/curie.dart';

void main() {
  // Initialize a prefix mapper.
  final mapper = PrefixMapping()
    ..addPrefix("foaf", "http://xmlns.com/foaf/0.1/")
    // Set a default prefix value
    ..defaultPrefixValue = "http://example.com/";

  print("--- Expanded CURIEs ---");

  // Prints "http://example.com/Entity"
  print(mapper.expandCurieString("Entity"));

  // Prints "http://xmlns.com/foaf/0.1/Agent"
  print(mapper.expandCurieString("foaf:Agent"));

  final curie = Curie(prefix: "foaf", reference: "Agent");

  // Prints "http://xmlns.com/foaf/0.1/Agent"
  print(mapper.expandCurie(curie));

  print("\n--- Shrunken IRI ---");

  // Creates a Curie object that prints "foaf:Agent"
  print(mapper.shrinkIri("http://xmlns.com/foaf/0.1/Agent"));
}
