Write-Output "$WINDOWN_PFX"
Move-Item -Path $WINDOWS_PFX -Destination hermes.pem
certutil -decode hermes.pem hermes.pfx

flutter pub run msix:create -c hermes.pfx -p $WINDOWS_PFX_PASS --sign-msix true --install-certificate false
