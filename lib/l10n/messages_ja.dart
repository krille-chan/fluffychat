// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja';

  static m0(username) => "${username}が招待を承諾しました";

  static m1(username) => "${username}がエンドツーエンド暗号化を有効にしました";

  static m2(senderName) => "${senderName}は通話に出ました";

  static m3(username) => "${username}の検証リクエストを承認しますか？";

  static m4(username, targetName) => "${username}が${targetName}をBANしました";

  static m5(homeserver) => "デフォルトで${homeserver}に接続されます";

  static m6(username) => "${username}がチャットアバターを変更しました";

  static m7(username, description) =>
      "${username}がチャットの説明を「${description}」に変更しました";

  static m8(username, chatname) => "${username}がチャットの名前を「${chatname}」に変更しました";

  static m9(username) => "${username}がチャットの権限を変更しました";

  static m10(username, displayname) =>
      "${username}が表示名を「${displayname}」に変更しました";

  static m11(username) => "${username}がゲストのアクセスルールを変更しました";

  static m12(username, rules) => "${username}がゲストのアクセスルールを${rules}に変更しました";

  static m13(username) => "${username}が履歴の表示設定を変更しました";

  static m14(username, rules) => "${username}が履歴の表示設定を${rules}に変更しました";

  static m15(username) => "${username}が参加ルールを変更しました";

  static m16(username, joinRules) => "${username}が参加ルールを${joinRules}に変更しました";

  static m17(username) => "${username}がアバターを変更しました";

  static m18(username) => "${username}が部屋のエイリアスを変更しました";

  static m19(username) => "${username}が招待リンクを変更しました";

  static m20(error) => "メッセージを解読できませんでした: ${error}";

  static m21(count) => "${count}名の参加者";

  static m22(username) => "${username}がチャットを作成しました";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${year}/${month}/${day}";

  static m25(month, day) => "${month}-${day}";

  static m26(senderName) => "${senderName}は通話を切断しました";

  static m27(displayname) => "${displayname}とグループを作成する";

  static m28(username, targetName) => "${targetName}の招待を${username}が取り下げました";

  static m29(groupName) => "連絡先から${groupName}に招待する";

  static m30(username, link) =>
      "${username}がFluffyChatにあなたを招待しました. \n1. FluffyChatをインストールしてください: https://fluffychat.im \n2. 新しくアカウントを作成するかサインインしてください\n3. 招待リンクを開いてください: ${link}";

  static m31(username, targetName) => "${username}が${targetName}を招待しました";

  static m32(username) => "${username}がチャットに参加しました";

  static m33(username, targetName) => "${username}は${targetName}をキックしました";

  static m34(username, targetName) => "${username}は${targetName}をキックしBANしました";

  static m35(localizedTimeShort) => "最終アクティブ: ${localizedTimeShort}";

  static m36(count) => "あと${count}名参加者を読み込む";

  static m37(homeserver) => "${homeserver}にログインする";

  static m38(number) => "${number}選択されています";

  static m39(fileName) => "${fileName}を再生する";

  static m40(username) => "${username}がイベントを編集しました";

  static m41(username) => "${username}は招待を拒否しました";

  static m42(username) => "${username}によって削除されました";

  static m43(username) => "${username}が既読";

  static m44(username, count) => "${username}と他${count}名が既読";

  static m45(username, username2) => "${username}と${username2}が既読";

  static m46(username) => "${username}はファイルを送信しました";

  static m47(username) => "${username}は画像を送信しました";

  static m48(username) => "${username}はステッカーを送信しました";

  static m49(username) => "${username}は動画を送信しました";

  static m50(username) => "${username}は音声を送信しました";

  static m51(senderName) => "${senderName}は通話情報を送信しました";

  static m52(username) => "${username}は現在地を共有しました";

  static m53(senderName) => "${senderName}は通話を開始しました";

  static m54(hours12, hours24, minutes, suffix) =>
      "${hours24}:${minutes} ${suffix}";

  static m55(username, targetName) => "${username}が${targetName}のBANを解除しました";

  static m56(type) => "未知のイベント\'${type}\'";

  static m57(unreadCount) => "${unreadCount}の未読メッセージ";

  static m58(unreadEvents) => "${unreadEvents}件の未読メッセージ";

  static m59(unreadEvents, unreadChats) =>
      "${unreadChats}で${unreadEvents}件の未読メッセージ";

  static m60(username, count) => "${username}と他${count}名が入力しています...";

  static m61(username, username2) => "${username}と${username2}が入力しています...";

  static m62(username) => "${username}が入力しています...";

  static m63(username) => "${username}は退室しました";

  static m64(username, type) => "${username}は${type}イベントを送信しました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("このアプリについて"),
        "accept": MessageLookupByLibrary.simpleMessage("承諾する"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("アカウント"),
        "accountInformation": MessageLookupByLibrary.simpleMessage("アカウント情報"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("グループの説明を追加する"),
        "admin": MessageLookupByLibrary.simpleMessage("管理者"),
        "alias": MessageLookupByLibrary.simpleMessage("エイリアス"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("アカウントをすでにお持ちですか？"),
        "answeredTheCall": m2,
        "anyoneCanJoin": MessageLookupByLibrary.simpleMessage("誰でも参加できる"),
        "archive": MessageLookupByLibrary.simpleMessage("アーカイブ"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("アーカイブされた部屋"),
        "areGuestsAllowedToJoin":
            MessageLookupByLibrary.simpleMessage("ゲストユーザーの参加を許可する"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("これでよろしいですか？"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "鍵をキャッシュするためにはパスフレーズやリカバリーキーを入力してください。"),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "他の人を署名するためにはパスフレーズやリカバリーキーを入力してください。"),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "セッションを検証するためにはパスフレーズやリカバリーキーを入力してください。"),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("認証"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("アバターが変更されました"),
        "banFromChat": MessageLookupByLibrary.simpleMessage("チャットからBANする"),
        "banned": MessageLookupByLibrary.simpleMessage("BANされています"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("デバイスをブロックする"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage("鍵のキャッシュに成功しました！"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("ホームサーバーの変更"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("グループの名前を変更する"),
        "changeTheServer": MessageLookupByLibrary.simpleMessage("サーバーを変更する"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("スタイルを変更する"),
        "changeWallpaper": MessageLookupByLibrary.simpleMessage("壁紙を変更する"),
        "changedTheChatAvatar": m6,
        "changedTheChatDescriptionTo": m7,
        "changedTheChatNameTo": m8,
        "changedTheChatPermissions": m9,
        "changedTheDisplaynameTo": m10,
        "changedTheGuestAccessRules": m11,
        "changedTheGuestAccessRulesTo": m12,
        "changedTheHistoryVisibility": m13,
        "changedTheHistoryVisibilityTo": m14,
        "changedTheJoinRules": m15,
        "changedTheJoinRulesTo": m16,
        "changedTheProfileAvatar": m17,
        "changedTheRoomAliases": m18,
        "changedTheRoomInvitationLink": m19,
        "changelog": MessageLookupByLibrary.simpleMessage("変更履歴"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("暗号が破損しています"),
        "chat": MessageLookupByLibrary.simpleMessage("チャット"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("チャットの詳細"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("強いパスワードを選択してください"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("ユーザー名を選択してください"),
        "close": MessageLookupByLibrary.simpleMessage("閉じる"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "表示されている絵文字が他のデバイスで表示されているものと一致するか確認してください:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "表示されている数字が他のデバイスで表示されているものと一致するか確認してください:"),
        "confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "connect": MessageLookupByLibrary.simpleMessage("接続"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("接続が失敗しました"),
        "contactHasBeenInvitedToTheGroup":
            MessageLookupByLibrary.simpleMessage("連絡先に登録された人が招待されました"),
        "contentViewer": MessageLookupByLibrary.simpleMessage("コンテンツビューアー"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("クリップボードにコピーされました"),
        "copy": MessageLookupByLibrary.simpleMessage("コピー"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar":
            MessageLookupByLibrary.simpleMessage("アバターをセットできませんでした"),
        "couldNotSetDisplayname":
            MessageLookupByLibrary.simpleMessage("表示名をセットできませんでした"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("作成"),
        "createAccountNow": MessageLookupByLibrary.simpleMessage("アカウントを作成する"),
        "createNewGroup": MessageLookupByLibrary.simpleMessage("新しいグループを作成する"),
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("相互署名は使えません"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("相互署名が使えます"),
        "currentlyActive": MessageLookupByLibrary.simpleMessage("現在アクティブです"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("ダーク"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("メッセージの削除"),
        "deny": MessageLookupByLibrary.simpleMessage("拒否"),
        "device": MessageLookupByLibrary.simpleMessage("デバイス"),
        "devices": MessageLookupByLibrary.simpleMessage("デバイス"),
        "discardPicture": MessageLookupByLibrary.simpleMessage("画像を無視する"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("表示名が変更されました"),
        "donate": MessageLookupByLibrary.simpleMessage("寄付する"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("ファイルのダウンロード"),
        "editDisplayname": MessageLookupByLibrary.simpleMessage("表示名を編集"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("Jitsiインスタンスを編集する"),
        "emoteExists": MessageLookupByLibrary.simpleMessage("Emoteはすでに存在します！"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("不正なEmoteショートコード！"),
        "emoteSettings": MessageLookupByLibrary.simpleMessage("Emote設定"),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage("Emoteショートコード"),
        "emoteWarnNeedToPick":
            MessageLookupByLibrary.simpleMessage("Emoteショートコードと画像を選択してください！"),
        "emptyChat": MessageLookupByLibrary.simpleMessage("空のチャット"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "一度暗号化を有効にするともとに戻せません。よろしいですか？"),
        "encryption": MessageLookupByLibrary.simpleMessage("暗号化"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("暗号化アルゴリズム"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("暗号化されていません"),
        "end2endEncryptionSettings":
            MessageLookupByLibrary.simpleMessage("エンドツーエンド暗号化設定"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("グループ名を入力してください"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("ホームサーバーを入力してください"),
        "fileName": MessageLookupByLibrary.simpleMessage("ファイル名"),
        "fileSize": MessageLookupByLibrary.simpleMessage("ファイルサイズ"),
        "fluffychat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "forward": MessageLookupByLibrary.simpleMessage("進む"),
        "friday": MessageLookupByLibrary.simpleMessage("金曜日"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("参加時点から閲覧可能"),
        "fromTheInvitation": MessageLookupByLibrary.simpleMessage("招待時点から閲覧可能"),
        "group": MessageLookupByLibrary.simpleMessage("グループ"),
        "groupDescription": MessageLookupByLibrary.simpleMessage("グループの説明"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("グループの説明が変更されました"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage("グループは公開されています"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("ゲストは許可されていません"),
        "guestsCanJoin": MessageLookupByLibrary.simpleMessage("ゲストが許可されています"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("ヘルプ"),
        "homeserverIsNotCompatible":
            MessageLookupByLibrary.simpleMessage("このホームサーバーは互換性がありません"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "identity": MessageLookupByLibrary.simpleMessage("アイデンティティ"),
        "incorrectPassphraseOrKey":
            MessageLookupByLibrary.simpleMessage("パスフレーズかリカバリーキーが間違っています"),
        "inviteContact": MessageLookupByLibrary.simpleMessage("連絡先から招待する"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("招待されました"),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage("招待されたユーザーのみ"),
        "isDeviceKeyCorrect":
            MessageLookupByLibrary.simpleMessage("このデバイスキーは正しいですか？"),
        "isTyping": MessageLookupByLibrary.simpleMessage("入力しています..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("部屋に参加"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage("鍵はキャッシュされたいます"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("鍵がありません"),
        "kickFromChat": MessageLookupByLibrary.simpleMessage("チャットからキックする"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage("最終IP"),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage("ずいぶん前"),
        "leave": MessageLookupByLibrary.simpleMessage("退室する"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("退室しました"),
        "license": MessageLookupByLibrary.simpleMessage("ライセンス"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("ライト"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("更に読み込む..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("読み込み中...お待ちください"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("ログイン"),
        "logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
        "makeAModerator": MessageLookupByLibrary.simpleMessage("モデレータにする"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage("管理者にする"),
        "makeSureTheIdentifierIsValid":
            MessageLookupByLibrary.simpleMessage("識別子が正しいか確認してください"),
        "messageWillBeRemovedWarning":
            MessageLookupByLibrary.simpleMessage("メッセージはすべての参加者から消去されます"),
        "moderator": MessageLookupByLibrary.simpleMessage("モデレータ"),
        "monday": MessageLookupByLibrary.simpleMessage("月曜日"),
        "muteChat": MessageLookupByLibrary.simpleMessage("チャットのミュート"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(
            "現時点では、エンドツーエンドの暗号化を使用するにはPantalaimonが必要であることに注意してください。"),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("FluffyChatに新しいメッセージがあります"),
        "newPrivateChat": MessageLookupByLibrary.simpleMessage("新しいプライベートチャット"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("新しい認証リクエスト！"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChatは現在相互署名機能をサポートしていません。Riotから有効化してください。"),
        "noEmotesFound":
            MessageLookupByLibrary.simpleMessage("Emoteは見つかりませんでした😕"),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "あなたのスマホにはグーグルサービスがないようですね。プライバシーを保護するための良い選択です！Push通知を受け取るにはmicroGを使うことを推奨しています: https://microg.org/"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChatは現在鍵のオンラインバックアップの有効化をサポートしていません。Riotから有効化してください。"),
        "noPermission": MessageLookupByLibrary.simpleMessage("権限がありません"),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("部屋は見つかりませんでした..."),
        "none": MessageLookupByLibrary.simpleMessage("なし"),
        "notSupportedInWeb":
            MessageLookupByLibrary.simpleMessage("ウェブではサポートされていません"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onlineKeyBackupDisabled":
            MessageLookupByLibrary.simpleMessage("オンライン鍵バックアップは使用されていません"),
        "onlineKeyBackupEnabled":
            MessageLookupByLibrary.simpleMessage("オンライン鍵バックアップは使用されています"),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("おっと、何かがうまくいきませんでした..."),
        "openAppToReadMessages":
            MessageLookupByLibrary.simpleMessage("アプリを開いてメッセージを確認してください"),
        "openCamera": MessageLookupByLibrary.simpleMessage("カメラを開く"),
        "optionalGroupName": MessageLookupByLibrary.simpleMessage("(任意)グループ名"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("ユーザーの使用しているデバイス"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("パスフレーズかリカバリーキー"),
        "password": MessageLookupByLibrary.simpleMessage("パスワード"),
        "pickImage": MessageLookupByLibrary.simpleMessage("画像を選択してください"),
        "pin": MessageLookupByLibrary.simpleMessage("ピン"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("ユーザー名を選択してください"),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage("Matrix識別子を入力してください"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("パスワードを入力してください"),
        "pleaseEnterYourUsername":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("公開された部屋"),
        "recording": MessageLookupByLibrary.simpleMessage("録音中"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("拒否"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("再参加"),
        "remove": MessageLookupByLibrary.simpleMessage("消去"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("他のデバイスをすべて削除"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("デバイスの削除"),
        "removeExile": MessageLookupByLibrary.simpleMessage("追放を取り消し"),
        "removeMessage": MessageLookupByLibrary.simpleMessage("メッセージを削除"),
        "removedBy": m42,
        "renderRichContent":
            MessageLookupByLibrary.simpleMessage("リッチメッセージをレンダリングする"),
        "reply": MessageLookupByLibrary.simpleMessage("返信"),
        "requestPermission": MessageLookupByLibrary.simpleMessage("権限を要求する"),
        "requestToReadOlderMessages":
            MessageLookupByLibrary.simpleMessage("過去のメッセージを読む権限を要求する"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("すべての権限を取り消す"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("部屋はアップグレードされました"),
        "saturday": MessageLookupByLibrary.simpleMessage("土曜日"),
        "searchForAChat": MessageLookupByLibrary.simpleMessage("チャットを検索する"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("送信"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("メッセージを送信"),
        "sendFile": MessageLookupByLibrary.simpleMessage("ファイルを送信"),
        "sendImage": MessageLookupByLibrary.simpleMessage("画像の送信"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sessionVerified": MessageLookupByLibrary.simpleMessage("セッションは確認済みです"),
        "setAProfilePicture":
            MessageLookupByLibrary.simpleMessage("プロフィール画像を設定する"),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("グループの説明を設定する"),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage("招待リンクを設定する"),
        "setStatus": MessageLookupByLibrary.simpleMessage("ステータスの設定"),
        "settings": MessageLookupByLibrary.simpleMessage("設定"),
        "share": MessageLookupByLibrary.simpleMessage("共有"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("サインアップ"),
        "skip": MessageLookupByLibrary.simpleMessage("スキップ"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("ソースコード"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("初めてのチャットを開始してください(^_^)"),
        "startedACall": m53,
        "statusExampleMessage": MessageLookupByLibrary.simpleMessage("お元気ですか？"),
        "submit": MessageLookupByLibrary.simpleMessage("送信"),
        "sunday": MessageLookupByLibrary.simpleMessage("日曜日"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("システム"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("メニューを表示するにはタップしてください"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("違います"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("一致しています"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("この部屋はアーカイブされています。"),
        "thursday": MessageLookupByLibrary.simpleMessage("木曜日"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "tryToSendAgain": MessageLookupByLibrary.simpleMessage("送信し直してみる"),
        "tuesday": MessageLookupByLibrary.simpleMessage("火曜日"),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage("デバイスをブロック解除する"),
        "unknownDevice": MessageLookupByLibrary.simpleMessage("未知デバイス"),
        "unknownEncryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("未知の暗号化アルゴリズム"),
        "unknownEvent": m56,
        "unknownSessionVerify":
            MessageLookupByLibrary.simpleMessage("未知のセッションです。確認してください。"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("チャットをミュート解除する"),
        "unpin": MessageLookupByLibrary.simpleMessage("ピンを外す"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme":
            MessageLookupByLibrary.simpleMessage("有機EL(Amoled)対応の色にしますか？"),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("セッションの確認ができました！"),
        "verify": MessageLookupByLibrary.simpleMessage("確認"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("手動で確認"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("確認を始める"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage("確認が完了しました！"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage("他のアカウントを確認中"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("ユーザーの認証"),
        "videoCall": MessageLookupByLibrary.simpleMessage("音声通話"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("チャット履歴の表示"),
        "visibleForAllParticipants":
            MessageLookupByLibrary.simpleMessage("すべての参加者が閲覧可能"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("すべての人が閲覧可能"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("ボイスメッセージ"),
        "waitingPartnerAcceptRequest":
            MessageLookupByLibrary.simpleMessage("パートナーのリクエスト承諾待ちです..."),
        "waitingPartnerEmoji":
            MessageLookupByLibrary.simpleMessage("パートナーの絵文字承諾待ちです..."),
        "waitingPartnerNumbers":
            MessageLookupByLibrary.simpleMessage("パートナーの数字承諾待ちです..."),
        "wallpaper": MessageLookupByLibrary.simpleMessage("壁紙"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "エンドツーエンド暗号化は現在ベータ版です！これは自分自身の責任で行ってください！"),
        "wednesday": MessageLookupByLibrary.simpleMessage("水曜日"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "matrixネットワークで一番かわいいチャットアプリへようこそ。"),
        "whoIsAllowedToJoinThisGroup":
            MessageLookupByLibrary.simpleMessage("誰がこのチャットに入れますか"),
        "writeAMessage":
            MessageLookupByLibrary.simpleMessage("メッセージを入力してください..."),
        "yes": MessageLookupByLibrary.simpleMessage("はい"),
        "you": MessageLookupByLibrary.simpleMessage("あなた"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("チャットに招待されています"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage("あなたはもうこのチャットの参加者ではありません"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("自分自身を招待することはできません"),
        "youHaveBeenBannedFromThisChat":
            MessageLookupByLibrary.simpleMessage("チャットからBANされてしまいました"),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage("あなたのユーザー名")
      };
}
