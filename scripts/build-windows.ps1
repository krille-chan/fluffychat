flutter doctor
flutter config --enable-windows-desktop
flutter clean
flutter pub get

Write-Output "$WINDOWN_PFX"
Move-Item -Path $WINDOWS_PFX -Destination fluffychat.pem
certutil -decode fluffychat.pem fluffychat.pfx

flutter build windows --release -v

flutter pub run msix:create -c fluffychat.pfx -p $WINDOWS_PFX_PASS --sign-msix true --install-certificate false