import 'package:matrix/matrix.dart';

class AccountBundles {
  String? prefix;
  List<AccountBundle>? bundles;

  AccountBundles({this.prefix, this.bundles});

  AccountBundles.fromJson(Map<String, dynamic> json)
      : prefix = json.tryGet<String>('prefix'),
        bundles = json['bundles'] is List
            ? json['bundles']
                .map((b) {
                  try {
                    return AccountBundle.fromJson(b);
                  } catch (_) {
                    return null;
                  }
                })
                .whereType<AccountBundle>()
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        if (prefix != null) 'prefix': prefix,
        if (bundles != null)
          'bundles': bundles!.map((v) => v.toJson()).toList(),
      };
}

class AccountBundle {
  String? name;
  int? priority;

  AccountBundle({this.name, this.priority});

  AccountBundle.fromJson(Map<String, dynamic> json)
      : name = json.tryGet<String>('name'),
        priority = json.tryGet<int>('priority');

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (name != null) 'name': name,
        if (priority != null) 'priority': priority,
      };
}

const accountBundlesType = 'im.fluffychat.account_bundles';

extension AccountBundlesExtension on Client {
  List<AccountBundle> get accountBundles {
    List<AccountBundle>? ret;
    if (accountData.containsKey(accountBundlesType)) {
      ret = AccountBundles.fromJson(accountData[accountBundlesType]!.content)
          .bundles;
    }
    ret ??= [];
    if (ret.isEmpty) {
      ret.add(
        AccountBundle(
          name: userID,
          priority: 0,
        ),
      );
    }
    return ret;
  }

  Future<void> setAccountBundle(String name, [int? priority]) async {
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType]?.content ?? {});
    var foundBundle = false;
    final bundles = data.bundles ??= [];
    for (final bundle in bundles) {
      if (bundle.name == name) {
        bundle.priority = priority;
        foundBundle = true;
        break;
      }
    }
    if (!foundBundle) {
      bundles.add(AccountBundle(name: name, priority: priority));
    }
    await setAccountData(userID!, accountBundlesType, data.toJson());
  }

  Future<void> removeFromAccountBundle(String name) async {
    if (!accountData.containsKey(accountBundlesType)) {
      return; // nothing to do
    }
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType]!.content);
    if (data.bundles == null) return;
    data.bundles!.removeWhere((b) => b.name == name);
    await setAccountData(userID!, accountBundlesType, data.toJson());
  }

  String get sendPrefix {
    final data =
        AccountBundles.fromJson(accountData[accountBundlesType]?.content ?? {});
    return data.prefix!;
  }
}
