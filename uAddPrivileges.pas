unit uAddPrivileges;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, WinInet, variable, func, StoHtmlHelp;

type
  TFAddPrivileges = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    { Private declarations }
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  FAddPrivileges: TFAddPrivileges;

implementation

uses uAuth, uCreateProfile;

{$R *.dfm}

procedure TFAddPrivileges.WndProc(var Message: TMessage);
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

procedure EmptyIECache;
Var
    lpEntryInfo : PInternetCacheEntryInfo;
    hCacheDir   : LongWord;
    dwEntrySize : LongWord;
    dwLastError : LongWord;
Begin
    dwEntrySize := 0;
    FindFirstUrlCacheEntry( NIL, TInternetCacheEntryInfo( NIL^ ), dwEntrySize );
    GetMem( lpEntryInfo, dwEntrySize );
    hCacheDir := FindFirstUrlCacheEntry( NIL, lpEntryInfo^, dwEntrySize );
    If ( hCacheDir <> 0 ) Then
        DeleteUrlCacheEntry( lpEntryInfo^.lpszSourceUrlName );
    FreeMem( lpEntryInfo );
    Repeat
        dwEntrySize := 0;
        FindNextUrlCacheEntry( hCacheDir, TInternetCacheEntryInfo( NIL^ ), dwEntrySize );
        dwLastError := GetLastError();
        If ( GetLastError = ERROR_INSUFFICIENT_BUFFER ) Then Begin
            GetMem( lpEntryInfo, dwEntrySize );
            If ( FindNextUrlCacheEntry( hCacheDir, lpEntryInfo^, dwEntrySize ) ) Then
                DeleteUrlCacheEntry( lpEntryInfo^.lpszSourceUrlName );
            FreeMem(lpEntryInfo);
        End;
    Until ( dwLastError = ERROR_NO_MORE_ITEMS );
End;

procedure TFAddPrivileges.FormCreate(Sender: TObject);
begin
    UserSettings.FEMail:=FCreateProfile.Email.Text;
    UserSettings.FPassword:=FCreateProfile.EPass.Text;

 EmptyIECache;      // очистка куков WebBrowser1
 WebBrowser1.Navigate('http://vkontakte.ru/login.php?app=1911526&layout=popup&type=browser&settings=15615');

end;

procedure TFAddPrivileges.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
form:olevariant;
f,i:Integer;
s:string;
begin
 if (URL='http://vkontakte.ru/login.php?op=slogin&nonenone=1') then
  begin
   // заполняем поля логина и пароля
   for f:=0 to WebBrowser1.OleObject.Document.forms.Length-1 do begin
    form:=WebBrowser1.OleObject.Document.forms.Item(f).elements;
   for i:=0 to form.Length-1 do
    if form.item(i).name='email' then
     form.item(i).value:=UserSettings.FEMail
    else
     if form.item(i).id='pass' then
      form.item(i).value:=UserSettings.FPassword;
   end;
  end
 else
 if (URL='http://vkontakte.ru/api/login_failure.html') then
  begin
   WebBrowser1.Navigate('http://vkontakte.ru/login.php?app=1911526&layout=popup&type=browser&settings=15615');
   // пользовался не авторизовался, пробуем еще раз
  end
 else
 if Pos('login_success.html',URL)<>0 then
  begin
   FAddPrivileges.close;
   FAuth.GetProfiles;
   // пользователь авторизовался и дал права
  end;
end;

end.
