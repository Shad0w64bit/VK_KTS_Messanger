unit uAuth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, variable, func, StoHtmlHelp;

type
  TFAuth = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EMail: TComboBox;
    ECode: TEdit;
    BNewProfile: TButton;
    BOK: TButton;
    Bsettings: TButton;
    IconsList: TImageList;
    procedure BOKClick(Sender: TObject);
    procedure BNewProfileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GetProfiles;
    procedure ECodeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BsettingsClick(Sender: TObject);
  private
    { Private declarations }
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  FAuth: TFAuth;

implementation

uses uMain, uCreateProfile, uAddPrivileges, uSettingsProfile;

{$R *.dfm}

procedure TFAuth.WndProc(var Message: TMessage);
begin
with message do
  case Msg of
    WM_SYSCOMMAND:
          if message.WParam = 61824 then begin
          Application.HelpSystem.ShowTableOfContents;
          Application.HelpJump('Авторизация');
          exit;
        end;
    WM_NCLBUTTONDOWN: begin
        if message.WParam = 21 then begin
          Application.HelpSystem.ShowTableOfContents;
          Application.HelpJump('Авторизация');
          exit;
        end;
    end;
  end;

  inherited WndProc(Message);
end;

procedure TFAuth.GetProfiles;
begin
  GetProfileList(GetEnvironmentVariable('appdata')+'\VKIM KTS');
  if ProfileList.Count=0 then begin
    BOK.Enabled:=false;
  end else begin
    Email.Clear;
    Email.Items:=ProfileList;
    EMail.ItemIndex:=0;
    BOK.Enabled:=true;
  end;
end;

procedure TFAuth.BNewProfileClick(Sender: TObject);
begin
  FCreateProfile := TFCreateProfile.Create(Application);
  FCreateProfile.Showmodal;
  FCreateProfile.Hide;
  FCreateProfile.Free;
end;

procedure TFAuth.BOKClick(Sender: TObject);
var
  UserS: TUserSettings;
  MStream: TmemoryStream;
begin
  MStream:=TmemoryStream.Create;
  DecryptFileTo(GetEnvironmentVariable('appdata')+'\VKIM KTS\'+
  Email.Text+'\user.vim',ECode.Text, MStream);
  Mstream.Position:=0;
  MStream.ReadBuffer(UserS, SizeOf(TUserSettings));
  MStream.Free;

  if UserS.Fext=VEXT then begin
  FAuth.Hide;
  AvaDir:=GetEnvironmentVariable('appdata')+'\VKIM KTS\'+EMail.Text+'\avatars';
  UserSettings:=UserS;
  FMain.Show;
  Fmain.TrayIcon1.Visible:=true;
  Fmain.ConnectAPI;
  end else showmessage('Код неверен!!!')
end;

procedure TFAuth.BsettingsClick(Sender: TObject);
begin
  fSettingsProfile := TfSettingsProfile.Create(Application);
  FSettingsProfile.Email.Text:=Email.Text;
  fSettingsProfile.Showmodal;
  fSettingsProfile.Hide;
  fSettingsProfile.Free;
end;

procedure TFAuth.ECodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=13 then
  BOK.Click;
end;

procedure TFAuth.FormCreate(Sender: TObject);
begin
LoadIcons(IconsList);
Application.HintShortPause:=100;
Application.HintHidePause:=5000;
InitKTSLists;
GetProfiles;
end;

procedure TFAuth.FormDestroy(Sender: TObject);
begin
FreeKTSList;
end;

procedure TFAuth.FormShow(Sender: TObject);
begin
 SetForegroundWindow(FAuth.Handle);
 FAuth.SetFocus;

  if ProfileList.Count=0 then begin
    BOK.Enabled:=false;
    Bsettings.Enabled:=false;
    BNewProfile.SetFocus;
  end else begin
    Email.Clear;
    Email.Items:=ProfileList;
    EMail.ItemIndex:=0;
    BOK.Enabled:=true;
    Bsettings.Enabled:=true;
    ECode.SetFocus;
  end;
end;

end.
