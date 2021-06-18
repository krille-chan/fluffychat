import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor/isolate.dart';
import '../platform_infos.dart';
import 'cipher_db.dart' as cipher;
import 'package:moor/ffi.dart' as moor;
import 'package:sqlite3/open.dart';

bool _inited = false;

// see https://moor.simonbinder.eu/docs/advanced-features/isolates/
void _startBackground(_IsolateStartRequest request) {
  // this is the entry point from the background isolate! Let's create
  // the database from the path we received

  if (!_inited) {
    cipher.init();
    _inited = true;
  }
  final executor = cipher.VmDatabaseEncrypted(File(request.targetPath),
      password: request.password, logStatements: request.logStatements);
  // we're using MoorIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used MoorIsolate.spawn, a third isolate would be
  // started which is not what we want!
  final moorIsolate = MoorIsolate.inCurrent(
    () => DatabaseConnection.fromExecutor(executor),
  );
  // inform the starting isolate about this, so that it can call .connect()
  request.sendMoorIsolate.send(moorIsolate);
}

// used to bundle the SendPort and the target path, since isolate entry point
// functions can only take one parameter.
class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;
  final String password;
  final bool logStatements;

  _IsolateStartRequest(
      this.sendMoorIsolate, this.targetPath, this.password, this.logStatements);
}

Future<Database> constructDb(
    {bool logStatements = false,
    String filename = 'database.sqlite',
    String password = ''}) async {
  if (PlatformInfos.isMobile || Platform.isMacOS) {
    Logs().v('[Moor] using encrypted moor');
    final dbFolder = await getDatabasesPath();
    final targetPath = p.join(dbFolder, filename);
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _startBackground,
      _IsolateStartRequest(
          receivePort.sendPort, targetPath, password, logStatements),
    );
    final isolate = (await receivePort.first as MoorIsolate);
    return Database.connect(await isolate.connect());
  } else if (Platform.isLinux) {
    Logs().v('[Moor] using Linux desktop moor');
    final appDocDir = await getApplicationSupportDirectory();
    return Database(moor.VmDatabase(File('${appDocDir.path}/$filename')));
  } else if (Platform.isWindows) {
    Logs().v('[Moor] using Windows desktop moor');
    open.overrideFor(OperatingSystem.windows, _openOnWindows);
    return Database(moor.VmDatabase.memory());
  }
  throw Exception('Platform not supported');
}

DynamicLibrary _openOnWindows() {
  final exePath =
      File(Platform.resolvedExecutable.replaceAll('fluffychat.exe', ''));
  final libraryNextToScript = File('${exePath.path}/sqlite3.dll');
  return DynamicLibrary.open(libraryNextToScript.path);
}

Future<String> getLocalstorage(String key) async {
  return null;
}
