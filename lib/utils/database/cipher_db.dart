// file from https://gist.github.com/simolus3/5097bbd80ce59f9b957961fe851fd95a#file-cipher_db-dart

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:moor/backends.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:sqlite3/open.dart';

/// Tells `moor_ffi` to use `sqlcipher` instead of the regular `sqlite3`.
///
/// This needs to be called before using `moor`, for instance in the `main`
/// method.
void init() {
  const sharedLibraryName = 'libsqlcipher.so';

  open.overrideFor(OperatingSystem.android, () {
    try {
      return DynamicLibrary.open(sharedLibraryName);
    } catch (_) {
      // On some (especially old) Android devices, we somehow can't dlopen
      // libraries shipped with the apk. We need to find the full path of the
      // library (/data/data/<id>/lib/libsqlite3.so) and open that one.
      // For details, see https://github.com/simolus3/moor/issues/420
      final appIdAsBytes = File('/proc/self/cmdline').readAsBytesSync();

      // app id ends with the first \0 character in here.
      final endOfAppId = max(appIdAsBytes.indexOf(0), 0);
      final appId = String.fromCharCodes(appIdAsBytes.sublist(0, endOfAppId));

      return DynamicLibrary.open('/data/data/$appId/lib/$sharedLibraryName');
    }
  });

  open.overrideFor(OperatingSystem.iOS, () => DynamicLibrary.executable());
}

class VmDatabaseEncrypted extends DelegatedDatabase {
  /// Creates a database that will store its result in the [file], creating it
  /// if it doesn't exist.
  factory VmDatabaseEncrypted(
    File file, {
    String password = '',
    bool logStatements = false,
  }) {
    final vmDatabase = VmDatabase(file, logStatements: logStatements);
    return VmDatabaseEncrypted._(vmDatabase, password);
  }

  factory VmDatabaseEncrypted.memory({
    String password = '',
    bool logStatements = false,
  }) {
    final vmDatabase = VmDatabase.memory(logStatements: logStatements);
    return VmDatabaseEncrypted._(vmDatabase, password);
  }

  VmDatabaseEncrypted._(
    VmDatabase vmDatabase,
    String password,
  ) : super(
          _VmEncryptedDelegate(vmDatabase.delegate, password),
          logStatements: vmDatabase.logStatements,
          isSequential: vmDatabase.isSequential,
        );
}

class _VmEncryptedDelegate extends DatabaseDelegate {
  final String password;
  final DatabaseDelegate delegate;

  _VmEncryptedDelegate(
    this.delegate,
    this.password,
  );

  @override
  Future<void> open(QueryExecutorUser db) async {
    await delegate.open(db);
    final keyLiteral = const StringType().mapToSqlConstant(password);
    await delegate.runCustom('PRAGMA KEY = $keyLiteral', const []);
    return Future.value();
  }

  @override
  FutureOr<bool> get isOpen => delegate.isOpen;

  @override
  Future<void> runBatched(BatchedStatements statements) {
    return delegate.runBatched(statements);
  }

  @override
  Future<void> runCustom(String statement, List args) {
    return delegate.runCustom(statement, args);
  }

  @override
  Future<int> runInsert(String statement, List args) {
    return delegate.runInsert(statement, args);
  }

  @override
  Future<QueryResult> runSelect(String statement, List args) {
    return delegate.runSelect(statement, args);
  }

  @override
  Future<int> runUpdate(String statement, List args) {
    return delegate.runUpdate(statement, args);
  }

  @override
  TransactionDelegate get transactionDelegate => delegate.transactionDelegate;

  @override
  DbVersionDelegate get versionDelegate => delegate.versionDelegate;
}
