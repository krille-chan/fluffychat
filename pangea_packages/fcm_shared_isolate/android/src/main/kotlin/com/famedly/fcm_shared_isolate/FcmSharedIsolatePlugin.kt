package com.famedly.fcm_shared_isolate

import androidx.annotation.NonNull
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FcmSharedIsolatePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    private val fcm = try { FirebaseMessaging.getInstance() } catch (e: Exception) { null }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "fcm_shared_isolate")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (fcm == null) {
            result.error("fcm_unavailable", null, null)
            return
        }

        if (call.method == "getToken") {
            val getToken = fcm.getToken()
            getToken.addOnSuccessListener { result.success(it) }
            getToken.addOnFailureListener { result.error("unknown", null, null) }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun message(@NonNull data: Map<String, String>) {
        channel.invokeMethod("message", data)
    }

    fun token(@NonNull str: String) {
        channel.invokeMethod("token", str)
    }
}
