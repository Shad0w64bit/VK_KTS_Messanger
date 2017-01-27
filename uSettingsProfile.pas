unit uSettingsProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, func, variable, StoHtmlHelp;

type
  TfSettingsProfile = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Email: TEdit;
    Epass: TEdit;
    ECode: TEdit;
    CBpass: TCheckBox;
    CBCode: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure Label3MouseLeave(Sender: TObject);
    procedure Label3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CBpassClick(Sender: TObject);
    procedure CBCodeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  fSettingsProfile: TfSettingsProfile;

implementation

{$R *.dfm}

procedure TfSettingsProfile.WndProc(var Message: TMessage);
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

procedure TfSettingsProfile.Button1Click(Sender: TObject);
var
  UserSettings: TUserSettings;
  MStream: TmemoryStream;
begin
  MStream:=TmemoryStream.Create;
  DecryptFileTo(GetEnvironmentVariable('appdata')+'\VKIM KTS\'+
  Email.Text+'\user.vim',ECode.Text, MStream);
  Mstream.Position:=0;
  MStream.ReadBuffer(UserSettings, SizeOf(TUserSettings));
  MStream.Free;

  if UserSettings.Fext=VEXT then begin
    UserSettings.FPassword:=Epass.Text;

  Mstream:=TMemorystream.Create;
    MStream.WriteBuffer(UserSettings, Sizeof(TUserSettings));
    MStream.Position:=0;
    EncryptToFile(GetEnvironmentVariable('appdata')+'\VKIM KTS\'+
  Email.Text+'\user.vim',ECode.Text,MStream);
  MStream.Free;


  end else showmessage('Код неверен!');
end;

procedure TfSettingsProfile.Button2Click(Sender: TObject);
begin
 if MyRemoveDir(GetEnvironmentVariable('appdata')+'\VKIM KTS\'+Email.Text)
   then begin
      Showmessage('Профиль успешно удален!');
      close;
   end else showmessage('Ошибка при удалении!');
end;

procedure TfSettingsProfile.CBCodeClick(Sender: TObject);
begin
  if CBCode.Checked then
  ECode.PasswordChar:=#0 else
  ECode.PasswordChar:='*';
end;

procedure TfSettingsProfile.CBpassClick(Sender: TObject);
begin
  if CBPass.Checked then
  Epass.PasswordChar:=#0 else
  Epass.PasswordChar:='*';
end;

procedure TfSettingsProfile.Label3Click(Sender: TObject);
begin
  Application.HelpSystem.ShowTableOfContents;
  Application.HelpJump('Авторизация');
end;

procedure TfSettingsProfile.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Color:=clSilver;
end;

procedure TfSettingsProfile.Label3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Label3.Font.Color:=$00FF0000;
end;

end.
