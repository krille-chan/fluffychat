import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';

int sortHomeservers(PublicHomeserverData a, PublicHomeserverData b) {
  return _calcHomeserverScore(b).compareTo(_calcHomeserverScore(a));
}

int _calcHomeserverScore(PublicHomeserverData homeserver) {
  var score = 0;
  if (homeserver.description?.isNotEmpty == true) score++;
  if (homeserver.homepage?.isNotEmpty == true) score++;
  score += (homeserver.languages?.length ?? 0);
  score += (homeserver.features?.length ?? 0);
  score += (homeserver.onlineStatus ?? 0);
  if (homeserver.ipv6 == true) score++;
  if (homeserver.isp?.isNotEmpty == true) score++;
  if (homeserver.privacy?.isNotEmpty == true) score++;
  if (homeserver.rules?.isNotEmpty == true) score++;
  if (homeserver.version?.isNotEmpty == true) score++;
  if (homeserver.usingVanillaReg == true) score--;
  if (homeserver.regLink != null) score--;
  if (homeserver.regMethod != 'SSO') score--;
  if (homeserver.regMethod == 'In-house Element') score--;
  return score;
}
