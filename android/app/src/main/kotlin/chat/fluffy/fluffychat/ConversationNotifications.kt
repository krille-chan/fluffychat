// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

package chat.fluffy.fluffychat

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import androidx.core.content.LocusIdCompat
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Handles Android Conversation Notifications (API 30+).
 *
 * Publishes dynamic shortcuts with SHORTCUT_CATEGORY_CONVERSATION so that
 * MessagingStyle notifications appear in the Android Conversations section.
 * Also creates per-room notification channels linked to their shortcut via
 * setConversationId().
 *
 * The shortcut intent format is kept compatible with flutter_shortcuts_new so
 * that FlutterShortcuts().listenAction() in chat_list.dart continues to work.
 */
class ConversationNotifications(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "chat.fluffy.fluffychat/conversations"

        // Must match MethodCallImplementation.EXTRA_ACTION in flutter_shortcuts_new
        private const val SHORTCUT_EXTRA_ACTION = "flutter_shortcuts_new"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "publishShortcut" -> publishShortcut(call, result)
            "removeShortcuts" -> removeShortcuts(call, result)
            "createConversationChannel" -> createConversationChannel(call, result)
            "removeConversationChannels" -> removeConversationChannels(call, result)
            else -> result.notImplemented()
        }
    }

    /**
     * Publishes (or updates) a long-lived dynamic shortcut for a Matrix room.
     *
     * Sets SHORTCUT_CATEGORY_CONVERSATION and setLongLived(true) so Android
     * classifies MessagingStyle notifications linked to this shortcut as
     * Conversations.  The intent format matches flutter_shortcuts_new so that
     * tapping the shortcut from the launcher still invokes FluffyChat's
     * existing UrlLauncher → room navigation flow.
     */
    private fun publishShortcut(call: MethodCall, result: MethodChannel.Result) {
        try {
            val id = call.argument<String>("id")
                ?: return result.error("MISSING_ARG", "id required", null)
            val name = call.argument<String>("name")
                ?: return result.error("MISSING_ARG", "name required", null)
            val roomUrl = call.argument<String>("roomUrl")
                ?: return result.error("MISSING_ARG", "roomUrl required", null)
            val avatarBytes = call.argument<ByteArray?>("avatar")
            val isImportant = call.argument<Boolean>("isImportant") ?: false

            // Build the icon from avatar bytes when available.
            val icon: IconCompat? = avatarBytes
                ?.takeIf { it.isNotEmpty() }
                ?.let { BitmapFactory.decodeByteArray(it, 0, it.size) }
                ?.let { IconCompat.createWithAdaptiveBitmap(it) }

            val person = Person.Builder()
                .setKey(id)
                .setName(name)
                .setImportant(isImportant)
                .apply { icon?.let { setIcon(it) } }
                .build()

            // Use ACTION_RUN + SHORTCUT_EXTRA_ACTION so that
            // FlutterShortcuts().listenAction() in chat_list.dart receives the
            // room URL and UrlLauncher can open the room.
            val intent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
                ?.setAction(Intent.ACTION_RUN)
                ?.putExtra(SHORTCUT_EXTRA_ACTION, roomUrl)
                ?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                ?: return result.error("NO_INTENT", "Could not get launch intent", null)

            val shortcut = ShortcutInfoCompat.Builder(context, id)
                .setShortLabel(name)
                .setIntent(intent)
                .setPerson(person)
                .setLongLived(true)
                .setCategories(setOf("android.shortcut.conversation"))
                .setLocusId(LocusIdCompat(id))
                .apply { icon?.let { setIcon(it) } }
                .build()

            ShortcutManagerCompat.pushDynamicShortcut(context, shortcut)
            result.success(null)
        } catch (e: Exception) {
            result.error("SHORTCUT_ERROR", e.message, null)
        }
    }

    private fun removeShortcuts(call: MethodCall, result: MethodChannel.Result) {
        try {
            val ids = call.argument<List<String>>("ids")
                ?: return result.error("MISSING_ARG", "ids required", null)
            ShortcutManagerCompat.removeDynamicShortcuts(context, ids)
            result.success(null)
        } catch (e: Exception) {
            result.error("SHORTCUT_ERROR", e.message, null)
        }
    }

    /**
     * Creates a per-room notification channel with setConversationId() so that
     * Android Settings shows conversation-specific channel controls.
     *
     * On API < 30 setConversationId() is a no-op via the AndroidX compat layer;
     * the channel still works correctly for grouping purposes.
     *
     * If the channel with the given id already exists (e.g. created by an older
     * app version without setConversationId), this call is a no-op and the
     * existing channel is preserved.
     */
    private fun createConversationChannel(call: MethodCall, result: MethodChannel.Result) {
        try {
            val id = call.argument<String>("id")
                ?: return result.error("MISSING_ARG", "id required", null)
            val name = call.argument<String>("name")
                ?: return result.error("MISSING_ARG", "name required", null)
            val groupId = call.argument<String?>("groupId")
            val parentChannelId = call.argument<String>("parentChannelId")
                ?: return result.error("MISSING_ARG", "parentChannelId required", null)
            val shortcutId = call.argument<String>("shortcutId")
                ?: return result.error("MISSING_ARG", "shortcutId required", null)

            val notificationManager = NotificationManagerCompat.from(context)

            // Skip if channel already exists to preserve any user customisations.
            if (notificationManager.getNotificationChannel(id) != null) {
                return result.success(null)
            }

            val channel = NotificationChannelCompat.Builder(
                id,
                NotificationManagerCompat.IMPORTANCE_HIGH,
            )
                .setName(name)
                .apply { groupId?.let { setGroup(it) } }
                .setConversationId(parentChannelId, shortcutId)
                .build()

            notificationManager.createNotificationChannel(channel)
            result.success(null)
        } catch (e: Exception) {
            result.error("CHANNEL_ERROR", e.message, null)
        }
    }

    private fun removeConversationChannels(call: MethodCall, result: MethodChannel.Result) {
        try {
            val ids = call.argument<List<String>>("ids")
                ?: return result.error("MISSING_ARG", "ids required", null)
            val notificationManager = NotificationManagerCompat.from(context)
            for (channelId in ids) {
                notificationManager.deleteNotificationChannel(channelId)
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("CHANNEL_ERROR", e.message, null)
        }
    }
}
