# SPDX-FileCopyrightText: 2019-Present Christian Kußowski
# SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Packages an existing `flutter build windows` output into an installer
# (build/windows/installer/fluffychat-windows-x64-setup.exe) and a portable
# zip archive (build/windows/installer/fluffychat-windows-x64.zip).
param(
    [ValidateSet("Release", "Debug")]
    [string]$BuildMode = "Release"
)

$ErrorActionPreference = "Stop"

$buildDir = "build\windows\x64\runner\$BuildMode"
if (-not (Test-Path "$buildDir\fluffychat.exe")) {
    throw "No Windows build found in $buildDir. Run 'flutter build windows' first."
}

# Version from pubspec.yaml without the build number, e.g. 2.9.5
$version = ((Select-String -Path pubspec.yaml -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value -split '\+')[0].Trim()

# Ship the Visual C++ runtime next to the executable, as it is not
# installed on every Windows machine.
foreach ($dll in @("msvcp140.dll", "vcruntime140.dll", "vcruntime140_1.dll")) {
    Copy-Item "$env:SystemRoot\System32\$dll" $buildDir -Force
}

$iscc = Get-ChildItem "${env:ProgramFiles(x86)}\Inno Setup*\ISCC.exe", "$env:ProgramFiles\Inno Setup*\ISCC.exe" -ErrorAction SilentlyContinue |
    Select-Object -First 1
if (-not $iscc) {
    throw "Inno Setup not found. Install it with 'choco install innosetup'."
}

& $iscc.FullName "/DAppVersion=$version" "/DBuildDir=..\$buildDir" windows\installer.iss
if ($LASTEXITCODE -ne 0) {
    throw "Inno Setup failed with exit code $LASTEXITCODE"
}

Compress-Archive -Path "$buildDir\*" -DestinationPath build\windows\installer\fluffychat-windows-x64.zip -Force
