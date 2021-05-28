import 'dart:convert';
import 'dart:io';

main(List<String> args) async {
  print(jsonDecode(await File('lib/resources/faq.json').readAsString())[0]);
}
