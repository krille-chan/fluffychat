choco install flutter -y
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

flutter config --no-analytics
