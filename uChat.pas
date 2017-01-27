unit uChat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, func, variable, ExtCtrls, StdCtrls, ImgList;

type
  TfChat = class(TForm)
    PageControl1: TPageControl;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
  private
    { Private declarations }
    procedure CreateParams(var Params :TCreateParams); override;
  public
    { Public declarations }
    procedure AddItem(id: integer; Fl: string);
    procedure RefreshOnline;
    procedure ReloadAvatar;
    procedure ReciveKTSMessage(id: integer; msg: string);
//    procedure AddTBButton(caption: string; Event: TNotifyEvent);
  end;

var
  fChat: TfChat;
  IdList: TStrings;
  num: cardinal;

implementation

uses uMain, uInfoProfile, uChatFrame;

{$R *.dfm}

function FindIdList(id: string): integer;
var
  i: integer;
begin
  result:=-1;
  if IdList.Count=0 then
    exit;

  for I := 0 to IdList.Count - 1 do
    if IdList.Strings[i]=id then
      result:=I;
end;

procedure TFChat.ReloadAvatar;
var
  i, id: integer;
begin
if PageControl1.PageCount<=0 then exit;

  for I := 0 to PageControl1.PageCount - 1 do
   TfChatFrame(PageControl1.Pages[i].Controls[0]).LoadAvatar;
end;

procedure TFChat.ReciveKTSMessage(id: integer; msg: string);
var
 i, j : integer;
begin
  j:=FindIdList(inttostr(id));
  if i=-1 then
  begin
    fChat.AddItem(id,PJIDNameItem(JIDNameList.Items[id])^.FLName);
    j:=idList.Count-1;
  end;

  TfChatFrame(PageControl1.Pages[j].Controls[0]).ReciveKTSMessage(msg);
end;

procedure TFChat.AddItem(id: integer; Fl: string);
var
 i, ti: integer;
 Control1, Control2: TWinControl;
 log: string;
begin
  i:=FindIdList(inttostr(id));
  if not (i=-1) then
  begin
    PageControl1.TabIndex:=I;
    Show;
    exit;
  end;

   FMain.JabberClient1.GetPhoto(PJIDNameItem(JIDNameList.Items[id])^.JID);

   if PJIDNameItem(JIDNameList.Items[ID])^.info.Status = '' then
    begin
      sigmd5 := mid + 'api_id=1911526format=XMLmethod=activity.getuid=' +
        PJIDNameItem(JIDNameList.Items[ID])^.UID + 'v=3.0' + secret;
      sigmd5 := md5(sigmd5);

      log := fMain.IdHTTP1.get
        ('http://api.vkontakte.ru/api.php?api_id=1911526' +
          '&uid=' + PJIDNameItem(JIDNameList.Items[ID])
          ^.UID
          + '&format=XML&method=activity.get&sid=' + sid + '&sig=' + sigmd5 +
          '&v=3.0');

      PJIDNameItem(JIDNameList.Items[ID])^.info.Status := ReplaceXml(Pars('<activity>', log, '</activity>'));
    end;

   inc(num);
   IdList.Add(inttostr(id));

  PageControl1.TabIndex:=PageControl1.PageCount-1;

  with TTabSheet.Create(Self) do
  begin
    PageControl := PageControl1;
    Caption :=FL+'  ';
    PageControl1.SelectNextPage(True);
    Name:='TabSheet'+inttostr(num);
    ImageIndex:=0;
  end;
  with TfChatFrame.Create(Self) do
  begin
    Parent:=PageControl1.Pages[PageControl1.TabIndex];
    Name:='frame'+inttostr(num);
    tag:=num;
   end;
   TfChatFrame(PageControl1.Pages[PageControl1.TabIndex].Controls[0]).ID:=id;
   TfChatFrame(PageControl1.Pages[PageControl1.TabIndex].Controls[0]).LoadStatus;
   TfChatFrame(PageControl1.Pages[PageControl1.TabIndex].Controls[0]).GetHistory;

    fChat.Caption:=PageControl1.Pages[PageControl1.TabIndex].Caption;
    RefreshOnline;
    ReloadAvatar;
end;

procedure TFChat.RefreshOnline;
var
 i, j: integer;
begin
  for I := 0 to PageControl1.PageCount - 1 do
    PageControl1.Pages[i].ImageIndex:=0;

  for I := 0 to OnlineList.Count - 1 do
    begin
      j:=FindIdList(OnlineList.Strings[i]);
      if not (j=-1) then
        begin
        PageControl1.Pages[j].ImageIndex:=1;
        end;
    end;
end;

procedure TfChat.FormCreate(Sender: TObject);
begin
 LoadIcons(ImageList);
 IdList:=TStringList.Create;
end;

procedure TfChat.FormDestroy(Sender: TObject);
begin
  IdList.Free;
end;

procedure TfChat.CreateParams(var Params :TCreateParams); {override;}
begin
  inherited CreateParams(Params); {CreateWindowEx}
  Params.ExStyle := Params.ExStyle or WS_Ex_AppWindow;
end;

procedure TfChat.PageControl1Change(Sender: TObject);
begin
fChat.Caption:=PageControl1.Pages[PageControl1.TabIndex].Caption;
end;

procedure TfChat.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
if fChat.Showing then
  TRichEdit(TfChatFrame(PageControl1.Pages[PageControl1.TabIndex].Controls[0]).FindComponent('SendRE')).SetFocus;
end;

procedure TfChat.PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (ssDouble in Shift) then begin
  IdList.Delete(PageControl1.TabIndex);
  PageControl1.Pages[PageControl1.TabIndex].Free;
end;

if pagecontrol1.PageCount<=0 then
  hide;
end;

end.
