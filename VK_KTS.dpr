program VK_KTS;

uses
  Forms,
  uAuth in 'uAuth.pas' {FAuth},
  uCreateProfile in 'uCreateProfile.pas' {FCreateProfile},
  uAddPrivileges in 'uAddPrivileges.pas' {FAddPrivileges},
  uSettingsProfile in 'uSettingsProfile.pas' {fSettingsProfile},
  uMain in 'uMain.pas' {fMain},
  variable in 'variable.pas',
  func in 'func.pas',
  uSettings in 'uSettings.pas' {fSettings},
  uChat in 'uChat.pas' {fChat},
  uInfoProfile in 'uInfoProfile.pas' {fInfoProfile},
  uChatFrame in 'uChatFrame.pas' {fChatFrame: TFrame},
  uSelGroups in 'uSelGroups.pas' {fSelGroups},
  uHistory in 'uHistory.pas' {fHistory},
  uMainFrame in 'oFrame\uMainFrame.pas' {frMain: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFAuth, FAuth);
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfChat, fChat);
  Application.CreateForm(TfSettings, fSettings);
  Application.Run;
end.
