package chat.fluffy.fluffychat

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.Intent
import android.net.Uri
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterFragmentActivity() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return provideEngine(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // do nothing, because the engine was been configured in provideEngine
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        // Copy camera/gallery shared file to local cache before permission is lost
        if (intent.action == Intent.ACTION_SEND && intent.type?.startsWith("image/") == true) {
            val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM) ?: return
            try {
                val input = contentResolver.openInputStream(uri) ?: return
                val file = File(cacheDir, "shared_${System.currentTimeMillis()}.jpg")
                FileOutputStream(file).use { fos -> input.copyTo(fos) }
                input.close()
                val channel = MethodChannel(
                    provideEngine(this).dartExecutor.binaryMessenger, "fluffychat/share"
                )
                channel.invokeMethod("share_image", file.absolutePath)
            } catch (_: Exception) {}
        }
    }

    companion object {
        var engine: FlutterEngine? = null
        fun provideEngine(context: Context): FlutterEngine {
            val eng = engine ?: FlutterEngine(context, emptyArray(), true, false)
            engine = eng
            return eng
        }
    }
}