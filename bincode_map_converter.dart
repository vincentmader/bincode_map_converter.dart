// NOTE 1: What is the use case for this `converter` module?
//      -> Facilitate the conversion of Dart objects to/from binary.
//      -> It works analogous to the `bincode` crate in Rust.
//      -> If your Dart object implements a `toMap()` method
//         and a `fromMap()` constructor, this module handles the rest.
//      -> Just use the functions `map_to_binary` & `binary_to_map`. :)
// NOTE 2: The "binaries" are actually 16-bit integers expressed in base 10.

import "dart:convert" as dart_convert;

// Define conversion: `Map` <-> `String` (JSON)
// ════════════════════════════════════════════════════════════════════════════

String map_to_json(Map input) {
  return dart_convert.jsonEncode(input);
}

Map json_to_map(String input) {
  return dart_convert.jsonDecode(input);
}

// Define conversion: `String` <-> `List<int>`
// ════════════════════════════════════════════════════════════════════════════

List<int> string_to_binary(String input) {
  return input.codeUnits;
}

String binary_to_string(List<int> input) {
  return String.fromCharCodes(input);
}

// Define conversion: `Map` <-> `List<int>`
// ════════════════════════════════════════════════════════════════════════════
// NOTE 3: This is built upon the two methods defined above.

List<int> map_to_binary(Map input) {
  return string_to_binary(map_to_json(input));
}

Map binary_to_map(List<int> input) {
  return json_to_map(binary_to_string(input));
}

// Define main entry point.
// ════════════════════════════════════════════════════════════════════════════
// NOTE 4: The `main` function below is used for testing purposes only.
//         When using this module in another project, it can safely be deleted.

void main() {
  // Define a map.
  Map map = {"content": "If this is printed, the conversion works! :)"};
  // Convert to binary.
  List<int> serialized = map_to_binary(map);
  print("\nSerialized:\n$serialized");
  // Convert back to map.
  Map deserialized = binary_to_map(serialized);
  String content = deserialized["content"];
  print("\nDeserialized:\n$content");
}
