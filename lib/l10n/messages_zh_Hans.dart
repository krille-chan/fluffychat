// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_Hans locale. All the
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
  String get localeName => 'zh_Hans';

  static m0(username) => "${username} 已接受邀请";

  static m1(username) => "${username}已激活端到端加密";

  static m2(senderName) => "${senderName} 已开始通话";

  static m3(username) => "是否接受来自${username}的验证申请？";

  static m4(username, targetName) => "${username}禁止了${targetName}";

  static m5(homeserver) => "您将会默认连接到${homeserver}";

  static m6(username) => "${username} 更改了会话头像";

  static m7(username, description) => "${username} 更改了会话介绍为：“${description}”";

  static m8(username, chatname) => "${username} 更改了昵称为：“${chatname}”";

  static m9(username) => "${username} 更改了会话权限";

  static m10(username, displayname) => "${username} 更改了展示名称为：“${displayname}”";

  static m11(username) => "${username} 更改了游客访问规则";

  static m12(username, rules) => "${username} 更改了游客访问规则为：${rules}";

  static m13(username) => "${username} 更改了历史记录观察状态";

  static m14(username, rules) => "${username} 更改了历史记录观察状态到：${rules}";

  static m15(username) => "${username} 更改了加入的规则";

  static m16(username, joinRules) => "${username} 更改了加入的规则为：${joinRules}";

  static m17(username) => "${username} 更改了他们的头像";

  static m18(username) => "${username} 更改了房间名";

  static m19(username) => "${username} 更改了邀请链接";

  static m20(error) => "";

  static m21(count) => "";

  static m22(username) => "";

  static m23(date, timeOfDay) => "";

  static m24(year, month, day) => "";

  static m25(month, day) => "";

  static m26(senderName) => "";

  static m27(displayname) => "";

  static m28(username, targetName) => "";

  static m29(groupName) => "";

  static m30(username, link) => "";

  static m31(username, targetName) => "";

  static m32(username) => "";

  static m33(username, targetName) => "";

  static m34(username, targetName) => "";

  static m35(localizedTimeShort) => "";

  static m36(count) => "";

  static m37(homeserver) => "";

  static m38(number) => "";

  static m39(fileName) => "";

  static m40(username) => "";

  static m41(username) => "";

  static m42(username) => "";

  static m43(username) => "";

  static m44(username, count) => "";

  static m45(username, username2) => "";

  static m46(username) => "";

  static m47(username) => "";

  static m48(username) => "";

  static m49(username) => "";

  static m50(username) => "";

  static m51(senderName) => "";

  static m52(username) => "";

  static m53(senderName) => "";

  static m54(hours12, hours24, minutes, suffix) => "";

  static m55(username, targetName) => "";

  static m56(type) => "";

  static m57(unreadCount) => "";

  static m58(unreadEvents) => "";

  static m59(unreadEvents, unreadChats) => "";

  static m60(username, count) => "";

  static m61(username, username2) => "";

  static m62(username) => "";

  static m63(username) => "";

  static m64(username, type) => "";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("关于"),
        "accept": MessageLookupByLibrary.simpleMessage("接受"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("账户"),
        "accountInformation": MessageLookupByLibrary.simpleMessage("账户信息"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription": MessageLookupByLibrary.simpleMessage("添加一条群组介绍"),
        "admin": MessageLookupByLibrary.simpleMessage("管理员"),
        "alias": MessageLookupByLibrary.simpleMessage("别称"),
        "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage("已经有账户了？"),
        "answeredTheCall": m2,
        "anyoneCanJoin": MessageLookupByLibrary.simpleMessage("任何人可以加入"),
        "archive": MessageLookupByLibrary.simpleMessage("存档"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("已存档的会话"),
        "areGuestsAllowedToJoin":
            MessageLookupByLibrary.simpleMessage("是否允许游客用户加入"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("你确定吗？"),
        "askSSSSCache":
            MessageLookupByLibrary.simpleMessage("请输入您的安全存储密码或恢复密钥以存储密钥。"),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(""),
        "askSSSSVerify":
            MessageLookupByLibrary.simpleMessage("请输入安全存储密码或恢复密钥以验证您的会话。"),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("身份验证"),
        "avatarHasBeenChanged": MessageLookupByLibrary.simpleMessage("头像已更改"),
        "banFromChat": MessageLookupByLibrary.simpleMessage("已被从对话中禁止"),
        "banned": MessageLookupByLibrary.simpleMessage("已被禁止"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("屏蔽设备"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage("成功保存了密钥！"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "changeTheHomeserver": MessageLookupByLibrary.simpleMessage("更改主机地址"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("更改了群组名称"),
        "changeTheServer": MessageLookupByLibrary.simpleMessage("更改服务器"),
        "changeTheme": MessageLookupByLibrary.simpleMessage(""),
        "changeWallpaper": MessageLookupByLibrary.simpleMessage("更改会话壁纸"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("更改记录"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("加密已被破坏"),
        "chat": MessageLookupByLibrary.simpleMessage("会话"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("会话详情"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("输入一个强密码"),
        "chooseAUsername": MessageLookupByLibrary.simpleMessage("输入一个昵称"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "compareEmojiMatch":
            MessageLookupByLibrary.simpleMessage("对比并确认这些表情匹配其他那些设备"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(""),
        "confirm": MessageLookupByLibrary.simpleMessage(""),
        "connect": MessageLookupByLibrary.simpleMessage(""),
        "connectionAttemptFailed": MessageLookupByLibrary.simpleMessage(""),
        "contactHasBeenInvitedToTheGroup":
            MessageLookupByLibrary.simpleMessage(""),
        "contentViewer": MessageLookupByLibrary.simpleMessage(""),
        "copiedToClipboard": MessageLookupByLibrary.simpleMessage(""),
        "copy": MessageLookupByLibrary.simpleMessage(""),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar": MessageLookupByLibrary.simpleMessage(""),
        "couldNotSetDisplayname": MessageLookupByLibrary.simpleMessage(""),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage(""),
        "createAccountNow": MessageLookupByLibrary.simpleMessage(""),
        "createNewGroup": MessageLookupByLibrary.simpleMessage(""),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(""),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(""),
        "currentlyActive": MessageLookupByLibrary.simpleMessage(""),
        "darkTheme": MessageLookupByLibrary.simpleMessage(""),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "delete": MessageLookupByLibrary.simpleMessage(""),
        "deleteMessage": MessageLookupByLibrary.simpleMessage(""),
        "deny": MessageLookupByLibrary.simpleMessage(""),
        "device": MessageLookupByLibrary.simpleMessage(""),
        "devices": MessageLookupByLibrary.simpleMessage(""),
        "discardPicture": MessageLookupByLibrary.simpleMessage(""),
        "displaynameHasBeenChanged": MessageLookupByLibrary.simpleMessage(""),
        "donate": MessageLookupByLibrary.simpleMessage(""),
        "downloadFile": MessageLookupByLibrary.simpleMessage(""),
        "editDisplayname": MessageLookupByLibrary.simpleMessage(""),
        "editJitsiInstance": MessageLookupByLibrary.simpleMessage(""),
        "emoteExists": MessageLookupByLibrary.simpleMessage(""),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(""),
        "emoteSettings": MessageLookupByLibrary.simpleMessage(""),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage(""),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(""),
        "emptyChat": MessageLookupByLibrary.simpleMessage(""),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(""),
        "encryption": MessageLookupByLibrary.simpleMessage(""),
        "encryptionAlgorithm": MessageLookupByLibrary.simpleMessage(""),
        "encryptionNotEnabled": MessageLookupByLibrary.simpleMessage(""),
        "end2endEncryptionSettings": MessageLookupByLibrary.simpleMessage(""),
        "endedTheCall": m26,
        "enterAGroupName": MessageLookupByLibrary.simpleMessage(""),
        "enterAUsername": MessageLookupByLibrary.simpleMessage(""),
        "enterYourHomeserver": MessageLookupByLibrary.simpleMessage(""),
        "fileName": MessageLookupByLibrary.simpleMessage(""),
        "fileSize": MessageLookupByLibrary.simpleMessage(""),
        "fluffychat": MessageLookupByLibrary.simpleMessage(""),
        "forward": MessageLookupByLibrary.simpleMessage(""),
        "friday": MessageLookupByLibrary.simpleMessage(""),
        "fromJoining": MessageLookupByLibrary.simpleMessage(""),
        "fromTheInvitation": MessageLookupByLibrary.simpleMessage(""),
        "group": MessageLookupByLibrary.simpleMessage(""),
        "groupDescription": MessageLookupByLibrary.simpleMessage(""),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage(""),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage(""),
        "groupWith": m27,
        "guestsAreForbidden": MessageLookupByLibrary.simpleMessage(""),
        "guestsCanJoin": MessageLookupByLibrary.simpleMessage(""),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage(""),
        "homeserverIsNotCompatible": MessageLookupByLibrary.simpleMessage(""),
        "id": MessageLookupByLibrary.simpleMessage(""),
        "identity": MessageLookupByLibrary.simpleMessage(""),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContact": MessageLookupByLibrary.simpleMessage(""),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage(""),
        "invitedUser": m31,
        "invitedUsersOnly": MessageLookupByLibrary.simpleMessage(""),
        "isDeviceKeyCorrect": MessageLookupByLibrary.simpleMessage(""),
        "isTyping": MessageLookupByLibrary.simpleMessage(""),
        "joinRoom": MessageLookupByLibrary.simpleMessage(""),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(""),
        "keysMissing": MessageLookupByLibrary.simpleMessage(""),
        "kickFromChat": MessageLookupByLibrary.simpleMessage(""),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage(""),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage(""),
        "leave": MessageLookupByLibrary.simpleMessage(""),
        "leftTheChat": MessageLookupByLibrary.simpleMessage(""),
        "license": MessageLookupByLibrary.simpleMessage(""),
        "lightTheme": MessageLookupByLibrary.simpleMessage(""),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage(""),
        "loadingPleaseWait": MessageLookupByLibrary.simpleMessage(""),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage(""),
        "logout": MessageLookupByLibrary.simpleMessage(""),
        "makeAModerator": MessageLookupByLibrary.simpleMessage(""),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage(""),
        "makeSureTheIdentifierIsValid":
            MessageLookupByLibrary.simpleMessage(""),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(""),
        "moderator": MessageLookupByLibrary.simpleMessage(""),
        "monday": MessageLookupByLibrary.simpleMessage(""),
        "muteChat": MessageLookupByLibrary.simpleMessage(""),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(""),
        "newMessageInFluffyChat": MessageLookupByLibrary.simpleMessage(""),
        "newPrivateChat": MessageLookupByLibrary.simpleMessage(""),
        "newVerificationRequest": MessageLookupByLibrary.simpleMessage(""),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(""),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(""),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noPermission": MessageLookupByLibrary.simpleMessage(""),
        "noRoomsFound": MessageLookupByLibrary.simpleMessage(""),
        "none": MessageLookupByLibrary.simpleMessage(""),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(""),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(""),
        "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(""),
        "openAppToReadMessages": MessageLookupByLibrary.simpleMessage(""),
        "openCamera": MessageLookupByLibrary.simpleMessage(""),
        "optionalGroupName": MessageLookupByLibrary.simpleMessage(""),
        "participatingUserDevices": MessageLookupByLibrary.simpleMessage(""),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "password": MessageLookupByLibrary.simpleMessage(""),
        "pickImage": MessageLookupByLibrary.simpleMessage(""),
        "pin": MessageLookupByLibrary.simpleMessage(""),
        "play": m39,
        "pleaseChooseAUsername": MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterYourPassword": MessageLookupByLibrary.simpleMessage(""),
        "pleaseEnterYourUsername": MessageLookupByLibrary.simpleMessage(""),
        "publicRooms": MessageLookupByLibrary.simpleMessage(""),
        "recording": MessageLookupByLibrary.simpleMessage(""),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage(""),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage(""),
        "remove": MessageLookupByLibrary.simpleMessage(""),
        "removeAllOtherDevices": MessageLookupByLibrary.simpleMessage(""),
        "removeDevice": MessageLookupByLibrary.simpleMessage(""),
        "removeExile": MessageLookupByLibrary.simpleMessage(""),
        "removeMessage": MessageLookupByLibrary.simpleMessage(""),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(""),
        "reply": MessageLookupByLibrary.simpleMessage(""),
        "requestPermission": MessageLookupByLibrary.simpleMessage(""),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(""),
        "revokeAllPermissions": MessageLookupByLibrary.simpleMessage(""),
        "roomHasBeenUpgraded": MessageLookupByLibrary.simpleMessage(""),
        "saturday": MessageLookupByLibrary.simpleMessage(""),
        "searchForAChat": MessageLookupByLibrary.simpleMessage(""),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage(""),
        "sendAMessage": MessageLookupByLibrary.simpleMessage(""),
        "sendFile": MessageLookupByLibrary.simpleMessage(""),
        "sendImage": MessageLookupByLibrary.simpleMessage(""),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sessionVerified": MessageLookupByLibrary.simpleMessage(""),
        "setAProfilePicture": MessageLookupByLibrary.simpleMessage(""),
        "setGroupDescription": MessageLookupByLibrary.simpleMessage(""),
        "setInvitationLink": MessageLookupByLibrary.simpleMessage(""),
        "setStatus": MessageLookupByLibrary.simpleMessage(""),
        "settings": MessageLookupByLibrary.simpleMessage(""),
        "share": MessageLookupByLibrary.simpleMessage(""),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage(""),
        "skip": MessageLookupByLibrary.simpleMessage(""),
        "sourceCode": MessageLookupByLibrary.simpleMessage(""),
        "startYourFirstChat": MessageLookupByLibrary.simpleMessage(""),
        "startedACall": m53,
        "statusExampleMessage": MessageLookupByLibrary.simpleMessage(""),
        "submit": MessageLookupByLibrary.simpleMessage(""),
        "sunday": MessageLookupByLibrary.simpleMessage(""),
        "systemTheme": MessageLookupByLibrary.simpleMessage(""),
        "tapToShowMenu": MessageLookupByLibrary.simpleMessage(""),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage(""),
        "theyMatch": MessageLookupByLibrary.simpleMessage(""),
        "thisRoomHasBeenArchived": MessageLookupByLibrary.simpleMessage(""),
        "thursday": MessageLookupByLibrary.simpleMessage(""),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage(""),
        "tryToSendAgain": MessageLookupByLibrary.simpleMessage(""),
        "tuesday": MessageLookupByLibrary.simpleMessage(""),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage(""),
        "unknownDevice": MessageLookupByLibrary.simpleMessage(""),
        "unknownEncryptionAlgorithm": MessageLookupByLibrary.simpleMessage(""),
        "unknownEvent": m56,
        "unknownSessionVerify": MessageLookupByLibrary.simpleMessage(""),
        "unmuteChat": MessageLookupByLibrary.simpleMessage(""),
        "unpin": MessageLookupByLibrary.simpleMessage(""),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(""),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage(""),
        "verifiedSession": MessageLookupByLibrary.simpleMessage(""),
        "verify": MessageLookupByLibrary.simpleMessage(""),
        "verifyManual": MessageLookupByLibrary.simpleMessage(""),
        "verifyStart": MessageLookupByLibrary.simpleMessage(""),
        "verifySuccess": MessageLookupByLibrary.simpleMessage(""),
        "verifyTitle": MessageLookupByLibrary.simpleMessage(""),
        "verifyUser": MessageLookupByLibrary.simpleMessage(""),
        "videoCall": MessageLookupByLibrary.simpleMessage(""),
        "visibilityOfTheChatHistory": MessageLookupByLibrary.simpleMessage(""),
        "visibleForAllParticipants": MessageLookupByLibrary.simpleMessage(""),
        "visibleForEveryone": MessageLookupByLibrary.simpleMessage(""),
        "voiceMessage": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(""),
        "wallpaper": MessageLookupByLibrary.simpleMessage(""),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(""),
        "wednesday": MessageLookupByLibrary.simpleMessage(""),
        "welcomeText": MessageLookupByLibrary.simpleMessage(""),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(""),
        "writeAMessage": MessageLookupByLibrary.simpleMessage(""),
        "yes": MessageLookupByLibrary.simpleMessage(""),
        "you": MessageLookupByLibrary.simpleMessage(""),
        "youAreInvitedToThisChat": MessageLookupByLibrary.simpleMessage(""),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage(""),
        "youCannotInviteYourself": MessageLookupByLibrary.simpleMessage(""),
        "youHaveBeenBannedFromThisChat":
            MessageLookupByLibrary.simpleMessage(""),
        "yourOwnUsername": MessageLookupByLibrary.simpleMessage("")
      };
}
