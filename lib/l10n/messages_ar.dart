// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static m0(username) => "${username} قبل الدعوة";

  static m1(username) => "${username} فعَّل تشفير طرف لطرف";

  static m2(senderName) => "${senderName} أجاب على المكالمة";

  static m3(username) => "أتقبل طلب تحقق ${username}؟";

  static m4(username, targetName) => "${username} حظر ${targetName}";

  static m5(homeserver) => "";

  static m6(username) => "غيَّر ${username} صورة المحادثة";

  static m7(username, description) =>
      "غيَّر ${username} وصف المحادثة الى: \'${description}\'";

  static m8(username, chatname) =>
      "غيَّر ${username} اسم المحادثة الى: \'${chatname}\'";

  static m9(username) => "غيَّر ${username} أذون المحادثة";

  static m10(username, displayname) =>
      "${username} غيّر اسمه الى ${displayname}";

  static m11(username) => "غيّر ${username} قواعد وصول الزوار";

  static m12(username, rules) =>
      "غيّر ${username} قواعد وصول الزوار الى: ${rules}";

  static m13(username) => "غيَّر ${username} مرئية التأريخ";

  static m14(username, rules) =>
      "غيَّر ${username} مرئية التأريخ الى: ${rules}";

  static m15(username) => "غيَّر ${username} قواعد الانضمام";

  static m16(username, joinRules) =>
      "غيَّر ${username} قواعد الانضمام الى: ${joinRules}";

  static m17(username) => "غيّر ${username} صورته الشخصية";

  static m18(username) => "غيّر ${username} ألقاب الغرف";

  static m19(username) => "غيّر ${username} رابط الدعوة";

  static m20(error) => "تعذر فك تشفير الرسالة: ${error}";

  static m21(count) => "${count} منتسبا";

  static m22(username) => "أنشأ ${username} المحادثة";

  static m23(date, timeOfDay) => "";

  static m24(year, month, day) => "";

  static m25(month, day) => "";

  static m26(senderName) => "أنهى ${senderName} المكالمة";

  static m27(displayname) => "";

  static m28(username, targetName) => "";

  static m29(groupName) => "أدعو مراسلا الى ${groupName}";

  static m30(username, link) =>
      "دعاك ${username} لاستخدام فلافي-شات. \n1. ثبت فلافي-شات: https://fluffychat.im \n2. لج أو سجل\n3. افتح رابط الدعوة: ${link}";

  static m31(username, targetName) => "${username} دعا ${targetName}";

  static m32(username) => "انضم ${username} للمحادثة";

  static m33(username, targetName) => "${username} طرد ${targetName}";

  static m34(username, targetName) => "${username} طرد وحظر ${targetName}";

  static m35(localizedTimeShort) => "آخر نشاط: ${localizedTimeShort}";

  static m36(count) => "حمِّل ${count} منتسبًا إضافيًا";

  static m37(homeserver) => "لِج ل ${homeserver}";

  static m38(number) => "حُدد ${number}";

  static m39(fileName) => "شغّل ${fileName}";

  static m40(username) => "";

  static m41(username) => "رفض ${username} الدعوة";

  static m42(username) => "أزاله ${username}";

  static m43(username) => "رآه ${username}";

  static m44(username, count) => "رآه ${username} و ${count} أخرون";

  static m45(username, username2) => "رآه ${username} و ${username2}";

  static m46(username) => "أرسلَ ${username} ملفًا";

  static m47(username) => "أرسلَ ${username} صورة";

  static m48(username) => "أرسلَ ${username} ملصقا";

  static m49(username) => "أرسلَ ${username} فيديو";

  static m50(username) => "أرسلَ ${username} ملفًا صوتيًا";

  static m51(senderName) => "";

  static m52(username) => "شارك ${username} الموقع";

  static m53(senderName) => "بدأ ${senderName} مكالمة";

  static m54(hours12, hours24, minutes, suffix) => "";

  static m55(username, targetName) => "ألغى ${username} حظر ${targetName}";

  static m56(type) => "";

  static m57(unreadCount) => "${unreadCount} رسالة غير مقروءة";

  static m58(unreadEvents) => "";

  static m59(unreadEvents, unreadChats) => "";

  static m60(username, count) => "${username} و ${count} أخرون يكتبون...";

  static m61(username, username2) => "${username} و ${username2} يكتبان...";

  static m62(username) => "${username} يكتب...";

  static m63(username) => "غادر ${username} المحادثة";

  static m64(username, type) => "";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("حول"),
        "accept": MessageLookupByLibrary.simpleMessage("أقبل"),
        "acceptedTheInvitation": m0,
        "account": MessageLookupByLibrary.simpleMessage("حساب"),
        "accountInformation":
            MessageLookupByLibrary.simpleMessage("معلومات الحساب"),
        "activatedEndToEndEncryption": m1,
        "addGroupDescription":
            MessageLookupByLibrary.simpleMessage("أضف وصف للمجموعة"),
        "admin": MessageLookupByLibrary.simpleMessage("المدير"),
        "alias": MessageLookupByLibrary.simpleMessage("اللقب"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("عندك حساب؟"),
        "answeredTheCall": m2,
        "anyoneCanJoin":
            MessageLookupByLibrary.simpleMessage("يمكن لأي أحد الدخول"),
        "archive": MessageLookupByLibrary.simpleMessage("الأرشيف"),
        "archivedRoom": MessageLookupByLibrary.simpleMessage("غرفة مؤرشفة"),
        "areGuestsAllowedToJoin":
            MessageLookupByLibrary.simpleMessage("هل يُسمح للزوار الدخول"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("متأكد؟"),
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(""),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(""),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(""),
        "askVerificationRequest": m3,
        "authentication": MessageLookupByLibrary.simpleMessage("الاستيثاق"),
        "avatarHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("غُيّرت الصورة الشخصية"),
        "banFromChat":
            MessageLookupByLibrary.simpleMessage("إحظره من المحادثة"),
        "banned": MessageLookupByLibrary.simpleMessage("محظور"),
        "bannedUser": m4,
        "blockDevice": MessageLookupByLibrary.simpleMessage("أُحظر الجهاز"),
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage(""),
        "cancel": MessageLookupByLibrary.simpleMessage("ألغِ"),
        "changeTheHomeserver":
            MessageLookupByLibrary.simpleMessage("غيّر الخادم"),
        "changeTheNameOfTheGroup":
            MessageLookupByLibrary.simpleMessage("غيِّر اسم المجموعة"),
        "changeTheServer": MessageLookupByLibrary.simpleMessage("غيِّر الخادم"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("غيّر أسلوبك"),
        "changeWallpaper":
            MessageLookupByLibrary.simpleMessage("غيِّر الخلفية"),
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
        "changelog": MessageLookupByLibrary.simpleMessage("سجل التغييرات"),
        "changesHaveBeenSaved":
            MessageLookupByLibrary.simpleMessage("حُفظت التغييرات"),
        "channelCorruptedDecryptError":
            MessageLookupByLibrary.simpleMessage("فسُد التشفير"),
        "chat": MessageLookupByLibrary.simpleMessage("محادثة"),
        "chatDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المحادثة"),
        "chooseAStrongPassword":
            MessageLookupByLibrary.simpleMessage("اختر كلمة سر قوية"),
        "chooseAUsername":
            MessageLookupByLibrary.simpleMessage("اختر اسم المستخدم"),
        "close": MessageLookupByLibrary.simpleMessage("أغلق"),
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "تأكد من أن هذه الإيموجي تطابق الموجودة على الأجهزة الأخرى:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "تأكد من أن هذه الأرقام تطابق الموجودة على الأجهزة الأخرى:"),
        "confirm": MessageLookupByLibrary.simpleMessage("أكّد"),
        "connect": MessageLookupByLibrary.simpleMessage("اتصل"),
        "connectionAttemptFailed":
            MessageLookupByLibrary.simpleMessage("فشلت محاولة الاتصال"),
        "contactHasBeenInvitedToTheGroup":
            MessageLookupByLibrary.simpleMessage("دعيَ المراسل للمجموعة"),
        "contentViewer": MessageLookupByLibrary.simpleMessage("عارض المحتوى"),
        "copiedToClipboard":
            MessageLookupByLibrary.simpleMessage("نُسخ في الحافظة"),
        "copy": MessageLookupByLibrary.simpleMessage("انسخ"),
        "couldNotDecryptMessage": m20,
        "couldNotSetAvatar":
            MessageLookupByLibrary.simpleMessage("تعذر تعيين الصورة الشخصية"),
        "couldNotSetDisplayname":
            MessageLookupByLibrary.simpleMessage("تعذر تعيين الاسم"),
        "countParticipants": m21,
        "create": MessageLookupByLibrary.simpleMessage("أنشئ"),
        "createAccountNow":
            MessageLookupByLibrary.simpleMessage("أنشئ حسابًا الآن"),
        "createNewGroup":
            MessageLookupByLibrary.simpleMessage("أنشئ مجموعة جديدة"),
        "createdTheChat": m22,
        "crossSigningDisabled": MessageLookupByLibrary.simpleMessage(""),
        "crossSigningEnabled": MessageLookupByLibrary.simpleMessage(""),
        "currentlyActive": MessageLookupByLibrary.simpleMessage("نشطٌ حاليا"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("داكن"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "deactivateAccountWarning": MessageLookupByLibrary.simpleMessage(
            "لا مجال للعودة، أتأكد تعطيل حسابك؟"),
        "delete": MessageLookupByLibrary.simpleMessage("احذف"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("احذف الحساب"),
        "deleteMessage": MessageLookupByLibrary.simpleMessage("احذف الرسالة"),
        "deny": MessageLookupByLibrary.simpleMessage("رفض"),
        "device": MessageLookupByLibrary.simpleMessage("جهاز"),
        "devices": MessageLookupByLibrary.simpleMessage("الأجهزة"),
        "discardPicture": MessageLookupByLibrary.simpleMessage("أهمل الصورة"),
        "displaynameHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("غُيِّر الاسم"),
        "donate": MessageLookupByLibrary.simpleMessage("تبرع"),
        "downloadFile": MessageLookupByLibrary.simpleMessage("نزِّل الملف"),
        "editDisplayname": MessageLookupByLibrary.simpleMessage("حرر الاسم"),
        "editJitsiInstance":
            MessageLookupByLibrary.simpleMessage("غيِّر خادم جيتسي"),
        "emoteExists": MessageLookupByLibrary.simpleMessage(""),
        "emoteInvalid": MessageLookupByLibrary.simpleMessage(""),
        "emoteSettings": MessageLookupByLibrary.simpleMessage(""),
        "emoteShortcode": MessageLookupByLibrary.simpleMessage(""),
        "emoteWarnNeedToPick": MessageLookupByLibrary.simpleMessage(""),
        "emptyChat": MessageLookupByLibrary.simpleMessage("محادثة فارغة"),
        "enableEncryptionWarning": MessageLookupByLibrary.simpleMessage(
            "لن يمكنك تعطيل التشفير أبدا، أمتأكد؟"),
        "encryption": MessageLookupByLibrary.simpleMessage("التشفير"),
        "encryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("خوارزمية التشفير"),
        "encryptionNotEnabled":
            MessageLookupByLibrary.simpleMessage("التشفير معطل"),
        "end2endEncryptionSettings":
            MessageLookupByLibrary.simpleMessage("إعدادات تشفير الطرف لطرف"),
        "endedTheCall": m26,
        "enterAGroupName":
            MessageLookupByLibrary.simpleMessage("أدخل اسم المجموعة"),
        "enterAUsername":
            MessageLookupByLibrary.simpleMessage("أدخل اسم المستخدم"),
        "enterYourHomeserver":
            MessageLookupByLibrary.simpleMessage("أدخل الخادم"),
        "fileName": MessageLookupByLibrary.simpleMessage("اسم الملف"),
        "fileSize": MessageLookupByLibrary.simpleMessage("حجم الملف"),
        "fluffychat": MessageLookupByLibrary.simpleMessage(""),
        "forward": MessageLookupByLibrary.simpleMessage("تقدم"),
        "friday": MessageLookupByLibrary.simpleMessage("الجمعة"),
        "fromJoining": MessageLookupByLibrary.simpleMessage("من بعد الانضمام"),
        "fromTheInvitation":
            MessageLookupByLibrary.simpleMessage("من بعد الدعوة"),
        "group": MessageLookupByLibrary.simpleMessage("المجموعة"),
        "groupDescription":
            MessageLookupByLibrary.simpleMessage("وصف المجموعة"),
        "groupDescriptionHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("غُيِّر وصف المجموعة"),
        "groupIsPublic": MessageLookupByLibrary.simpleMessage("المجموعة عامة"),
        "groupWith": m27,
        "guestsAreForbidden":
            MessageLookupByLibrary.simpleMessage("يمنع الزوار"),
        "guestsCanJoin":
            MessageLookupByLibrary.simpleMessage("يمكن للزوار الانضمام"),
        "hasWithdrawnTheInvitationFor": m28,
        "help": MessageLookupByLibrary.simpleMessage("المساعدة"),
        "homeserverIsNotCompatible":
            MessageLookupByLibrary.simpleMessage("الخادم ليس متوافقًا"),
        "id": MessageLookupByLibrary.simpleMessage("المعرّف"),
        "identity": MessageLookupByLibrary.simpleMessage("المُعرّف"),
        "ignoreListDescription": MessageLookupByLibrary.simpleMessage(
            "يمكنك تجاهل المستخدمين المزعجين، لن يتمكنوا من مراسلتك أو دعوتك لغرفة ما داموا في قائمة التجاهل."),
        "ignoreUsername":
            MessageLookupByLibrary.simpleMessage("تجاهل اسم المستخدم"),
        "ignoredUsers":
            MessageLookupByLibrary.simpleMessage("المستخدمون المتجاهلون"),
        "incorrectPassphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "inviteContact": MessageLookupByLibrary.simpleMessage("أدعو مراسلًا"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invited": MessageLookupByLibrary.simpleMessage("دُعيَ"),
        "invitedUser": m31,
        "invitedUsersOnly":
            MessageLookupByLibrary.simpleMessage("المستخدمون المدعوون فقط"),
        "isDeviceKeyCorrect":
            MessageLookupByLibrary.simpleMessage("هل مفتاح الجهاز صحيح؟"),
        "isTyping": MessageLookupByLibrary.simpleMessage("يكتب..."),
        "joinRoom": MessageLookupByLibrary.simpleMessage("انضم للمحادثة"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage(""),
        "keysMissing": MessageLookupByLibrary.simpleMessage("المفاتيح مفقودة"),
        "kickFromChat":
            MessageLookupByLibrary.simpleMessage("أطرد من المحادثة"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "lastSeenIp": MessageLookupByLibrary.simpleMessage("آخر عنوان IP مسجل"),
        "lastSeenLongTimeAgo": MessageLookupByLibrary.simpleMessage(""),
        "leave": MessageLookupByLibrary.simpleMessage("غادر"),
        "leftTheChat": MessageLookupByLibrary.simpleMessage("غادر المحادثة"),
        "license": MessageLookupByLibrary.simpleMessage("الرخصة"),
        "lightTheme": MessageLookupByLibrary.simpleMessage("فاتح"),
        "loadCountMoreParticipants": m36,
        "loadMore": MessageLookupByLibrary.simpleMessage("حمِّل المزيد..."),
        "loadingPleaseWait":
            MessageLookupByLibrary.simpleMessage("يحمّل... يرجى الانتظار"),
        "logInTo": m37,
        "login": MessageLookupByLibrary.simpleMessage("لِج"),
        "logout": MessageLookupByLibrary.simpleMessage("خروج"),
        "makeAModerator": MessageLookupByLibrary.simpleMessage("اجعله مشرفًا"),
        "makeAnAdmin": MessageLookupByLibrary.simpleMessage("اجعله مديرًا"),
        "makeSureTheIdentifierIsValid":
            MessageLookupByLibrary.simpleMessage(""),
        "messageWillBeRemovedWarning": MessageLookupByLibrary.simpleMessage(
            "ستحذف الرسالة عند كل المنتسبين"),
        "moderator": MessageLookupByLibrary.simpleMessage("مشرف"),
        "monday": MessageLookupByLibrary.simpleMessage("الإثنين"),
        "muteChat": MessageLookupByLibrary.simpleMessage("أكتم الماحدثة"),
        "needPantalaimonWarning": MessageLookupByLibrary.simpleMessage(""),
        "newMessageInFluffyChat":
            MessageLookupByLibrary.simpleMessage("رسالة جديدة في فلافي-شات"),
        "newPrivateChat":
            MessageLookupByLibrary.simpleMessage("محادثة خاصة جديدة"),
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("طلب تحقق جديد!"),
        "no": MessageLookupByLibrary.simpleMessage("لا"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noEmotesFound": MessageLookupByLibrary.simpleMessage(""),
        "noGoogleServicesWarning": MessageLookupByLibrary.simpleMessage(
            "من الرائع أن نرى انك لا تستخدم خدمات غوغل للحفاظ على خصوصيتك!من أجل استلام الإشعارات نقترح استخدام ميكرو-جي: https://microg.org"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(""),
        "noPermission": MessageLookupByLibrary.simpleMessage(""),
        "noRoomsFound":
            MessageLookupByLibrary.simpleMessage("لم يُعثر على غرف..."),
        "none": MessageLookupByLibrary.simpleMessage("بدون"),
        "notSupportedInWeb": MessageLookupByLibrary.simpleMessage(""),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("موافق"),
        "onlineKeyBackupDisabled": MessageLookupByLibrary.simpleMessage(""),
        "onlineKeyBackupEnabled": MessageLookupByLibrary.simpleMessage(""),
        "oopsSomethingWentWrong":
            MessageLookupByLibrary.simpleMessage("هناك خطأ ما..."),
        "openAppToReadMessages":
            MessageLookupByLibrary.simpleMessage("افتح التطبيق لقراءة الرسائل"),
        "openCamera": MessageLookupByLibrary.simpleMessage("افتح الكاميرا"),
        "optionalGroupName":
            MessageLookupByLibrary.simpleMessage("اسم المجموعة (اختياري)"),
        "participatingUserDevices":
            MessageLookupByLibrary.simpleMessage("أجهزة المنتسبين"),
        "passphraseOrKey": MessageLookupByLibrary.simpleMessage(""),
        "password": MessageLookupByLibrary.simpleMessage("كلمة السر"),
        "passwordHasBeenChanged":
            MessageLookupByLibrary.simpleMessage("غُيّرت كلمة السر"),
        "pickImage": MessageLookupByLibrary.simpleMessage("اختر صورة"),
        "pin": MessageLookupByLibrary.simpleMessage("ثبِّت"),
        "play": m39,
        "pleaseChooseAUsername":
            MessageLookupByLibrary.simpleMessage("اختر اسم المستخدم"),
        "pleaseEnterAMatrixIdentifier":
            MessageLookupByLibrary.simpleMessage("أدخل معرف مايتركس"),
        "pleaseEnterYourPassword":
            MessageLookupByLibrary.simpleMessage("أدخل كلمة السر"),
        "pleaseEnterYourUsername":
            MessageLookupByLibrary.simpleMessage("أدخل اسم المستخدم"),
        "publicRooms": MessageLookupByLibrary.simpleMessage("الغرف العامة"),
        "recording": MessageLookupByLibrary.simpleMessage("يسجل"),
        "redactedAnEvent": m40,
        "reject": MessageLookupByLibrary.simpleMessage("رفض"),
        "rejectedTheInvitation": m41,
        "rejoin": MessageLookupByLibrary.simpleMessage("أعد الانضمام"),
        "remove": MessageLookupByLibrary.simpleMessage("أزِل"),
        "removeAllOtherDevices":
            MessageLookupByLibrary.simpleMessage("أزِل كل الأجهزة الأخرى"),
        "removeDevice": MessageLookupByLibrary.simpleMessage("أزل جهازا"),
        "removeExile": MessageLookupByLibrary.simpleMessage(""),
        "removeMessage": MessageLookupByLibrary.simpleMessage("أزل رسالة"),
        "removedBy": m42,
        "renderRichContent": MessageLookupByLibrary.simpleMessage(""),
        "reply": MessageLookupByLibrary.simpleMessage("ردّ"),
        "requestPermission": MessageLookupByLibrary.simpleMessage("أطلب إذنا"),
        "requestToReadOlderMessages": MessageLookupByLibrary.simpleMessage(
            "أطلب السماح بقراءة الرسائل القديمة"),
        "revokeAllPermissions":
            MessageLookupByLibrary.simpleMessage("أبطل كل الأذون"),
        "roomHasBeenUpgraded":
            MessageLookupByLibrary.simpleMessage("رُقيّت الغرفة"),
        "saturday": MessageLookupByLibrary.simpleMessage("السبت"),
        "searchForAChat":
            MessageLookupByLibrary.simpleMessage("ابحث عن محادثة"),
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "send": MessageLookupByLibrary.simpleMessage("أرسل"),
        "sendAMessage": MessageLookupByLibrary.simpleMessage("أرسل رسالة"),
        "sendAudio": MessageLookupByLibrary.simpleMessage("أرسل ملفًا صوتيًا"),
        "sendBugReports": MessageLookupByLibrary.simpleMessage(
            "اسمح بإرسال تقريرات عن العلل باستخدام sentry.io"),
        "sendFile": MessageLookupByLibrary.simpleMessage("أرسل ملف"),
        "sendImage": MessageLookupByLibrary.simpleMessage("أرسل صورة"),
        "sendOriginal":
            MessageLookupByLibrary.simpleMessage("أرسل الملف الأصلي"),
        "sendVideo": MessageLookupByLibrary.simpleMessage("أرسل فيديو"),
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sentryInfo": MessageLookupByLibrary.simpleMessage(
            "معلومات عن خصوصيتك: https://sentry.io/security/"),
        "sessionVerified":
            MessageLookupByLibrary.simpleMessage("تُحقق من الجلسة"),
        "setAProfilePicture": MessageLookupByLibrary.simpleMessage(""),
        "setGroupDescription":
            MessageLookupByLibrary.simpleMessage("عيّن وصفا للمجموعة"),
        "setInvitationLink":
            MessageLookupByLibrary.simpleMessage("عيّن رابط الدعوة"),
        "setStatus": MessageLookupByLibrary.simpleMessage("عيّن الحالة"),
        "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "share": MessageLookupByLibrary.simpleMessage("شارك"),
        "sharedTheLocation": m52,
        "signUp": MessageLookupByLibrary.simpleMessage("سجّل"),
        "skip": MessageLookupByLibrary.simpleMessage("تخط"),
        "sourceCode": MessageLookupByLibrary.simpleMessage("الشفرة المصدرية"),
        "startYourFirstChat":
            MessageLookupByLibrary.simpleMessage("ابدأ محادثتك الأولى :-)"),
        "startedACall": m53,
        "statusExampleMessage":
            MessageLookupByLibrary.simpleMessage("ماهو وضعك؟"),
        "submit": MessageLookupByLibrary.simpleMessage("أرسل"),
        "sunday": MessageLookupByLibrary.simpleMessage("الأحد"),
        "systemTheme": MessageLookupByLibrary.simpleMessage("النظام"),
        "tapToShowMenu":
            MessageLookupByLibrary.simpleMessage("اضغط لعرض القائمة"),
        "theyDontMatch": MessageLookupByLibrary.simpleMessage("لا يتطبقان"),
        "theyMatch": MessageLookupByLibrary.simpleMessage("متطبقان"),
        "thisRoomHasBeenArchived":
            MessageLookupByLibrary.simpleMessage("أُرشِفت هته الغرفة."),
        "thursday": MessageLookupByLibrary.simpleMessage("الخميس"),
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage(""),
        "tryToSendAgain": MessageLookupByLibrary.simpleMessage(""),
        "tuesday": MessageLookupByLibrary.simpleMessage("الثلاثاء"),
        "unbannedUser": m55,
        "unblockDevice": MessageLookupByLibrary.simpleMessage("ألغ حظر الجهاز"),
        "unknownDevice": MessageLookupByLibrary.simpleMessage("جهز مجهول"),
        "unknownEncryptionAlgorithm":
            MessageLookupByLibrary.simpleMessage("خوارزمية تشفير مجهولة"),
        "unknownEvent": m56,
        "unknownSessionVerify":
            MessageLookupByLibrary.simpleMessage("الجلسة مجهولة، تحقق منها"),
        "unmuteChat": MessageLookupByLibrary.simpleMessage("ألغِ كتم المحادثة"),
        "unpin": MessageLookupByLibrary.simpleMessage("ألغِ التثبيت"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "useAmoledTheme": MessageLookupByLibrary.simpleMessage(""),
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "username": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("تُحقق من الجلسة بنجاح!"),
        "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("تحقق يدويا"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("ابدأ التحقق"),
        "verifySuccess":
            MessageLookupByLibrary.simpleMessage("تُحقق منك بنجاح!"),
        "verifyTitle":
            MessageLookupByLibrary.simpleMessage("يتحقق من الحساب الآخر"),
        "verifyUser": MessageLookupByLibrary.simpleMessage("تحقق من مستخدم"),
        "videoCall": MessageLookupByLibrary.simpleMessage("مكالمة فيديو"),
        "visibilityOfTheChatHistory":
            MessageLookupByLibrary.simpleMessage("غيّر مرئية تأريخ المحادثة"),
        "visibleForAllParticipants":
            MessageLookupByLibrary.simpleMessage("مرئي لكل المنتسبين"),
        "visibleForEveryone":
            MessageLookupByLibrary.simpleMessage("مرئي للجميع"),
        "voiceMessage": MessageLookupByLibrary.simpleMessage("رسالة صوتية"),
        "waitingPartnerAcceptRequest": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerEmoji": MessageLookupByLibrary.simpleMessage(""),
        "waitingPartnerNumbers": MessageLookupByLibrary.simpleMessage(""),
        "wallpaper": MessageLookupByLibrary.simpleMessage("الخلفية"),
        "warning": MessageLookupByLibrary.simpleMessage("تحذير!"),
        "warningEncryptionInBeta": MessageLookupByLibrary.simpleMessage(
            "التشفير طرفا لطرف لا يزال في مرحلة البيتا! استخدمه تحت مسؤوليتك!"),
        "wednesday": MessageLookupByLibrary.simpleMessage("الأربعاء"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "مرحبا بك في أظرف مراسل فروري لمايتركس."),
        "whoIsAllowedToJoinThisGroup": MessageLookupByLibrary.simpleMessage(
            "من يسمح له الانضمام للمجموعة"),
        "writeAMessage": MessageLookupByLibrary.simpleMessage("اكتب رسالة..."),
        "yes": MessageLookupByLibrary.simpleMessage("نعم"),
        "you": MessageLookupByLibrary.simpleMessage("انت"),
        "youAreInvitedToThisChat":
            MessageLookupByLibrary.simpleMessage("دُعيتَ لهذه المحادثة"),
        "youAreNoLongerParticipatingInThisChat":
            MessageLookupByLibrary.simpleMessage("لم تعد منتسبا لهذه المحادثة"),
        "youCannotInviteYourself":
            MessageLookupByLibrary.simpleMessage("لا يمكنك دعوة نفسك"),
        "youHaveBeenBannedFromThisChat":
            MessageLookupByLibrary.simpleMessage("حُظرت من هذه المحادثة"),
        "yourOwnUsername":
            MessageLookupByLibrary.simpleMessage("اسم المستخدم الخاص بك")
      };
}
