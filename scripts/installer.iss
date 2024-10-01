[Setup]
AppName=Tawkie
AppVersion={#MyAppVersion}
DefaultDirName={pf}\Tawkie
DefaultGroupName=Tawkie
OutputDir=..\build\windows\x64\runner\Release
OutputBaseFilename=TawkieInstaller
Compression=lzma
SolidCompression=yes

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Tawkie"; Filename: "{app}\Tawkie.exe"
Name: "{group}\Uninstall Tawkie"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\Tawkie.exe"; Description: "Launch Tawkie"; Flags: nowait postinstall skipifsilent
