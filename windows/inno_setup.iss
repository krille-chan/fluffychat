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
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "chinesesimplified"; MessagesFile: "languages\ChineseSimplified.isl"
Name: "chinesetraditional"; MessagesFile: "languages\ChineseTraditional.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

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
