package chat.fluffy.fluffychat

import android.content.Context
import org.unifiedpush.android.foss_embedded_fcm_distributor.EmbeddedDistributorReceiver

class EmbeddedDistributor: EmbeddedDistributorReceiver() {

    override val googleProjectNumber = "865731724731" // This value comes from the google-services.json

    override fun getEndpoint(context: Context, token: String, instance: String): String {
        // This returns the endpoint of your FCM Rewrite-Proxy
        return "https://push.fluffychat.im/_matrix/push/v1/notify?token=$token"
    }
}
