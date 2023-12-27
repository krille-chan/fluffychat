Write-Output "$WINDOWN_PFX"
Move-Item -Path $WINDOWS_PFX -Destination tawkie.pem
certutil -decode tawkie.pem tawkie.pfx

flutter pub run msix:create -c tawkie.pfx -p $WINDOWS_PFX_PASS --sign-msix true --install-certificate false
