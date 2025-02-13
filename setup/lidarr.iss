; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define AppName "Lidarr"
#define AppPublisher "Team Lidarr"
#define AppURL "https://lidarr.audio/"
#define ForumsURL "https://lidarr.audio/discord"
#define AppExeName "Lidarr.exe"
#define BaseVersion GetEnv('MAJORVERSION')
#define BuildNumber GetEnv('MINORVERSION')
#define BuildVersion GetEnv('LIDARRVERSION')

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{56C1065D-3523-4025-B76D-6F73F67F7F93}
AppName={#AppName}
AppVersion={#BaseVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#ForumsURL}
AppUpdatesURL={#AppURL}
DefaultDirName={commonappdata}\Lidarr
DisableDirPage=yes
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputBaseFilename=Lidarr.{#BuildVersion}.{#Runtime}
SolidCompression=yes
AppCopyright=Creative Commons 3.0 License
AllowUNCPath=False
UninstallDisplayIcon={app}\bin\Lidarr.exe
DisableReadyPage=True
CompressionThreads=2
Compression=lzma2/normal
AppContact={#ForumsURL}
VersionInfoVersion={#BaseVersion}.{#BuildNumber}
SetupLogging=yes
OutputDir=output
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopIcon"; Description: "{cm:CreateDesktopIcon}"
Name: "windowsService"; Description: "Install Windows Service (Starts when the computer starts as the LocalService user, you will need to change the user to access network shares)"; GroupDescription: "Start automatically"; Flags: exclusive
Name: "startupShortcut"; Description: "Create shortcut in Startup folder (Starts when you log into Windows)"; GroupDescription: "Start automatically"; Flags: exclusive unchecked
Name: "none"; Description: "Do not start automatically"; GroupDescription: "Start automatically"; Flags: exclusive unchecked

[Dirs]
Name: "{app}"; Permissions: users-modify

[Files]
Source: "..\_artifacts\{#Runtime}\{#Framework}\Lidarr\Lidarr.exe"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "..\_artifacts\{#Runtime}\{#Framework}\Lidarr\*"; Excludes: "Lidarr.Update"; DestDir: "{app}\bin"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\bin\{#AppExeName}"; Parameters: "/icon"
Name: "{commondesktop}\{#AppName}"; Filename: "{app}\bin\{#AppExeName}"; Parameters: "/icon"; Tasks: desktopIcon
Name: "{userstartup}\{#AppName}"; Filename: "{app}\bin\Lidarr.exe"; WorkingDir: "{app}\bin"; Tasks: startupShortcut

[InstallDelete]
Name: "{app}\bin"; Type: filesandordirs

[Run]
Filename: "{app}\bin\Lidarr.Console.exe"; StatusMsg: "Removing previous Windows Service"; Parameters: "/u /exitimmediately"; Flags: runhidden waituntilterminated;
Filename: "{app}\bin\Lidarr.Console.exe"; Description: "Enable Access from Other Devices"; StatusMsg: "Enabling Remote access"; Parameters: "/registerurl /exitimmediately"; Flags: postinstall runascurrentuser runhidden waituntilterminated; Tasks: startupShortcut none;
Filename: "{app}\bin\Lidarr.Console.exe"; StatusMsg: "Installing Windows Service"; Parameters: "/i /exitimmediately"; Flags: runhidden waituntilterminated; Tasks: windowsService
Filename: "{app}\bin\Lidarr.exe"; Description: "Open Lidarr Web UI"; Flags: postinstall skipifsilent nowait; Tasks: windowsService;
Filename: "{app}\bin\Lidarr.exe"; Description: "Start Lidarr"; Flags: postinstall skipifsilent nowait; Tasks: startupShortcut none;

[UninstallRun]
Filename: "{app}\bin\lidarr.console.exe"; Parameters: "/u"; Flags: waituntilterminated skipifdoesntexist

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Exec('net', 'stop lidarr', '', 0, ewWaitUntilTerminated, ResultCode)
  Exec('sc', 'delete lidarr', '', 0, ewWaitUntilTerminated, ResultCode)
end;
