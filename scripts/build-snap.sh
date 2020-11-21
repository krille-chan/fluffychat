#!/usr/bin/env bash
'curl -L $(curl -H "X-Ubuntu-Series: 16" "https://api.snapcraft.io/api/v1/snaps/details/flutter?channel=latest/stable" | jq ".download_url" -r) --output flutter.snap'
sudo mkdir -p /snap/flutter
sudo unsquashfs -d /snap/flutter/current flutter.snap
rm -f flutter.snap
sudo ln -sf /snap/flutter/current/flutter.sh /snap/bin/flutter
sudo ln -sf /snap/flutter/current/env.sh /snap/bin/env.sh
snapcraft