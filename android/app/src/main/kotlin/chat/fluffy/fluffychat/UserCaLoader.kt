package chat.fluffy.fluffychat

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import java.security.cert.X509Certificate

const val USER_CA_CHANNEL = "chat.fluffy.fluffychat/user_ca"

class UserCaLoader(
    private val binaryMessenger: BinaryMessenger,
) {
    private val methodChannel = MethodChannel(binaryMessenger, USER_CA_CHANNEL)

    init {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getUserCertificates" -> loadUserCerts(result)
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }

    private fun loadUserCerts(result: MethodChannel.Result) {
        val certificates = try {
            val keyStore = KeyStore.getInstance("AndroidCAStore")
            keyStore.load(null, null)
            // The plugin name uses "user" prefix for user-installed CA certs
            val aliasList = keyStore.aliases().toList()
                .filter { it.startsWith("user") }
            val mapOfBytes = aliasList.associate {
                val cert = keyStore.getCertificate(it) as X509Certificate
                it to cert.encoded
            }
            mapOfBytes
        } catch (e: Exception) {
            emptyMap<String, ByteArray>()
        }
        result.success(certificates)
    }
}
