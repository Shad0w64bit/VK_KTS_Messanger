unit uCreateProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Variable, func, StoHtmlHelp;

type
  TFCreateProfile = class(TForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    CBpass: TCheckBox;
    Email: TEdit;
    EPass: TEdit;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    CBCode: TCheckBox;
    ECode: TEdit;
    BCancel: TButton;
    BNew: TButton;
    procedure Label4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label4MouseLeave(Sender: TObject);
    procedure CBpassClick(Sender: TObject);
    procedure CBCodeClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BNewClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  FCreateProfile: TFCreateProfile;

implementation

uses uAddPrivileges, uAuth;

{$R *.dfm}

procedure TFCreateProfile.WndProc(var Message: TMessage);
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

procedure TFCreateProfile.BCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFCreateProfile.BNewClick(Sender: TObject);
var
  FolderName, FolderPath: AnsiString;
  USerSettings: TUserSettings;
  MStream: TMemoryStream;
begin
  FolderName:=EMail.Text;
  FolderName:=strtst(FolderName, '\/:*?"<>|', 2);
  FolderPath:=GetEnvironmentVariable('appdata')+'\VKIM KTS\'+FolderName;

  if ProfileList.IndexOf(FolderName)=-1 then begin
    ForceDirectories(FolderPath);
    ForceDirectories(FolderPath+'\avatars');
  end else begin
    Showmessage('Профиль уже существует'); exit;
  end;

  UserSettings.Fext:='VKIM';
  UserSettings.FEMail:=Email.Text;
  UserSettings.FPassword:=Epass.Text;

  Mstream:=TMemorystream.Create;
    MStream.WriteBuffer(UserSettings, Sizeof(TUserSettings));
    MStream.Position:=0;
    EncryptToFile(FolderPath+'\user.vim',ECode.Text,MStream);
  MStream.Free;

  ShowMessage('Создание профиля прошло успешно))');
  FCreateProfile.Close;


  FAddPrivileges := TFAddPrivileges.Create(Application);
  FAddPrivileges.Showmodal;
  FAddPrivileges.Hide;
  FAddPrivileges.Free;
end;

procedure TFCreateProfile.CBCodeClick(Sender: TObject);
begin
  if CBCode.Checked then
  ECode.PasswordChar:=#0 else
  ECode.PasswordChar:='*';
end;

procedure TFCreateProfile.CBpassClick(Sender: TObject);
begin
  if CBPass.Checked then
  Epass.PasswordChar:=#0 else
  Epass.PasswordChar:='*';
end;

procedure TFCreateProfile.Label4Click(Sender: TObject);
begin
  Application.HelpSystem.ShowTableOfContents;
  Application.HelpJump('SecretKey');
end;

procedure TFCreateProfile.Label4MouseLeave(Sender: TObject);
begin
  Label4.Font.Color:=clSilver;
end;

procedure TFCreateProfile.Label4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Label4.Font.Color:=$00FF0000;
end;

end.
