package chat.fluffy.fluffychat

import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FlutterFragmentActivity() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
    }

    /**
     * The shared engine must be present in the [FlutterEngineCache] before the
     * framework creates the FlutterFragment (which happens in super.onCreate()).
     * In cached-engine mode the fragment resolves the engine by
     * [getCachedEngineId] and throws an IllegalStateException if it is not in
     * the cache yet.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        provideEngine(applicationContext)
        super.onCreate(savedInstanceState)
    }

    /**
     * Registering the engine under a fixed id makes FlutterFragmentActivity run
     * in "cached engine" mode: the engine is looked up in the
     * FlutterEngineCache and is NOT destroyed when this activity is destroyed.
     *
     * Background: previously the engine was handed over through
     * provideFlutterEngine() while the activity ran in "new engine" mode. The
     * FlutterFragment built in that mode hardcodes destroyEngineWithFragment =
     * true, so the framework destroyed our shared engine in onDestroy(), while
     * the static [engine] reference kept pointing at the dead engine. The next
     * MainActivity instance (e.g. after a notification relaunch, task clear or
     * process restore) then attached that destroyed engine and crashed on its
     * first layout pass with:
     *
     *   java.lang.RuntimeException: Cannot execute operation because
     *   FlutterJNI is not attached to native.
     *       at io.flutter.embedding.engine.FlutterJNI.ensureAttachedToNative
     *       at io.flutter.embedding.engine.FlutterJNI.setViewportMetrics
     *       at io.flutter.embedding.engine.renderer.FlutterRenderer...
     *       at FlutterView.onSizeChanged
     *
     * Note: do not reintroduce a provideFlutterEngine() override here. In
     * cached-engine mode it is never consulted, and if getCachedEngineId() is
     * ever removed it would bring the bug back.
     */
    override fun getCachedEngineId(): String? {
        return ENGINE_ID
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // do nothing, because the engine was been configured in provideEngine
    }

    companion object {
        private const val ENGINE_ID = "fluffychat_main_engine"

        var engine: FlutterEngine? = null


        fun provideEngine(context: Context): FlutterEngine {
            val cache = FlutterEngineCache.getInstance()
            val eng = cache.get(ENGINE_ID)
                ?: FlutterEngine(context.applicationContext, emptyArray(), true, false)
                    .also {
                        // In cached-engine mode the framework does NOT run the Dart
                        // entrypoint for us (doInitialFlutterViewRun() returns early
                        // when getCachedEngineId() != null). We must start main()
                        // ourselves or the view stays blank (0x0, black screen).
                        it.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
                    }
                    .also { cache.put(ENGINE_ID, it) }
            engine = eng
            return eng
        }
    }
}
