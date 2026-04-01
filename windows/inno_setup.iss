#ifndef BuildType
#define BuildType "Release"
#endif

[Setup]
AppId={{DAA3E7EE-659A-40D4-B471-55ECCDD2170D}
AppName=FluffyChat
AppVersion={#MyAppVersion}
DefaultDirName={autopf}\FluffyChat
DisableProgramGroupPage=yes
OutputDir=..\build
OutputBaseFilename=fluffychat-windows-setup
Compression=lzma
SolidCompression=yes
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\fluffychat.exe
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "chinesetraditional"; MessagesFile: "compiler:Languages\ChineseTraditional.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Code]
procedure KillOldProcess;
var ResultCode: Integer;
begin
  Exec('taskkill', '/F /IM fluffychat.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

function InitializeSetup(): Boolean;
begin
  KillOldProcess;
  Result := True;
end;

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\build\windows\x64\runner\{#BuildType}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\FluffyChat"; Filename: "{app}\fluffychat.exe"
Name: "{autodesktop}\FluffyChat"; Filename: "{app}\fluffychat.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\fluffychat.exe"; Description: "{cm:LaunchProgram,FluffyChat}"; Flags: runascurrentuser nowait postinstall skipifsilent
