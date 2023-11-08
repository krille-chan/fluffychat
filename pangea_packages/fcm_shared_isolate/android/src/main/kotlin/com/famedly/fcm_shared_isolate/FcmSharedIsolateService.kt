package com.famedly.fcm_shared_isolate

import android.os.Handler
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.flutter.embedding.engine.FlutterEngine

abstract class FcmSharedIsolateService : FirebaseMessagingService() {
    abstract fun getEngine(): FlutterEngine

    private val handler = Handler()

    private fun getPlugin(): FcmSharedIsolatePlugin {
        val registry = getEngine().getPlugins()
        var plugin = registry.get(FcmSharedIsolatePlugin::class.java) as? FcmSharedIsolatePlugin
        if (plugin == null) {
            plugin = FcmSharedIsolatePlugin()
            registry.add(plugin)
        }
        return plugin
    }

    override fun onMessageReceived(message: RemoteMessage) {
        handler.post {
            getPlugin().message(message.getData())
        }
    }

    override fun onNewToken(token: String) {
        handler.post {
            getPlugin().token(token)
        }
    }
}
