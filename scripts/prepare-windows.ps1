choco install flutter cmake --installargs 'ADD_CMAKE_TO_PATH=System' -y
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

flutter config --no-analytics
