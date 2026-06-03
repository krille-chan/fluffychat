package chat.fluffy.fluffychat

import android.content.Context
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var appSwitcherPrivacyEnabled = false
    private var appSwitcherPrivacyForeground = true

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return provideEngine(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            APP_SWITCHER_PRIVACY_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setState" -> {
                    appSwitcherPrivacyEnabled = call.argument<Boolean>("enabled") ?: false
                    appSwitcherPrivacyForeground = call.argument<Boolean>("foreground") ?: true
                    applyAppSwitcherPrivacy()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun applyAppSwitcherPrivacy() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setRecentsScreenshotEnabled(!appSwitcherPrivacyEnabled)
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            return
        }

        if (appSwitcherPrivacyEnabled && !appSwitcherPrivacyForeground) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    companion object {
        private const val APP_SWITCHER_PRIVACY_CHANNEL =
            "chat.fluffy/app_switcher_privacy"

        var engine: FlutterEngine? = null

        fun provideEngine(context: Context): FlutterEngine {
            val eng = engine ?: FlutterEngine(context, emptyArray(), true, false)
            engine = eng
            return eng
        }
    }
}
