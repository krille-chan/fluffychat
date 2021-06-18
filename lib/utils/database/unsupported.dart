import 'package:matrix/matrix.dart';

Future<Database> constructDb(
    {bool logStatements = false,
    String filename = 'database.sqlite',
    String password = ''}) async {
  throw 'Platform not supported';
}

Future<String> getLocalstorage(String key) async {
  return null;
}
