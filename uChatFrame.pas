unit uChatFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, ExtCtrls, ImgList, StdCtrls, variable, func, gmXML;

type
  TfChatFrame = class(TFrame)
    Panel1: TPanel;
    AvaImage: TImage;
    PInfo: TPanel;
    HC1: THeaderControl;
    pluglist: TImageList;
    PStatus: TPanel;
    ChatRE: TRichEdit;
    Panel4: TPanel;
    BSend: TButton;
    SendRE: TRichEdit;
    Splitter1: TSplitter;
    procedure BSendClick(Sender: TObject);
    procedure SendREKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrameMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure HC1SectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
  private
    { Private declarations }
    procedure rMessage(title, msg: string; bold: boolean = true);
    procedure sMessage(title, msg: string; bold: boolean = true);
  public
    { Public declarations }
    ID: cardinal;
    procedure LoadAvatar;
    procedure LoadStatus;
    procedure ReciveKTSMessage(msg: string);
    procedure SendKTSMessage;
    procedure GetHistory;
  end;

implementation

uses uMain, uChat, uInfoProfile, uHistory;

{$R *.dfm}

procedure TfChatFrame.BSendClick(Sender: TObject);
begin
  SendKTSMessage;
end;

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

procedure TfChatFrame.LoadStatus;
begin
  PStatus.Caption:=PJIDNameItem(JIDNameList.Items[id])^.info.Status;
  PStatus.Hint:=PJIDNameItem(JIDNameList.Items[id])^.info.Status;
end;

procedure TfChatFrame.LoadAvatar;
begin
  fMain.AvaList.GetBitmap(PJIDNameItem(JIDNameList.Items[id])^.info.avaID,
      AvaImage.Picture.Bitmap);
    AvaImage.Repaint;
end;

procedure TfChatFrame.FrameMouseActivate(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
SendRE.SetFocus;
end;

procedure TfChatFrame.HC1SectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
case section.Index of
  0:  begin
        FInfoProfile := TFInfoProfile.Create(Application);
        FInfoProfile.uid:=PJIDNameItem(JIDNameList.Items[ID])^.UID;
        FInfoProfile.Show;
      end;
  1:  begin
        FHistory := TFHistory.Create(Application);
        FHistory.ID:=ID;
        FHistory.Show;
      end;
end;
end;

procedure TfChatFrame.rMessage(title, msg: string; bold: boolean = true);
begin
ChatRE.Lines.BeginUpdate;

ChatRE.SelStart:=length(ChatRE.Lines.Text);
ChatRE.SelAttributes.Color:=clBlue;
if bold then
  ChatRE.SelAttributes.Style:=[fsBold];
ChatRE.Lines.Add(title);
ChatRE.SelLength:=length(title);

ChatRE.SelStart:=length(ChatRE.Lines.Text);
ChatRE.SelAttributes.Color:=clBlack;
ChatRE.SelAttributes.Style:=[];
ChatRE.Lines.Add(msg);
ChatRE.SelLength:=length(msg);

ChatRE.Lines.EndUpdate;
SendMessage(ChatRE.Handle, EM_SCROLL, SB_BOTTOM, 0);
end;

procedure TfChatFrame.sMessage(title, msg: string; bold: boolean = true);
begin
ChatRE.Lines.BeginUpdate;

ChatRE.SelStart:=length(ChatRE.Lines.Text);
ChatRE.SelAttributes.Color:=clred;
if bold then
ChatRE.SelAttributes.Style:=[fsBold];
ChatRE.Lines.Add(title);
ChatRE.SelLength:=length(title);

ChatRE.SelStart:=length(ChatRE.Lines.Text);
ChatRE.SelAttributes.Color:=clBlack;
ChatRE.SelAttributes.Style:=[];
ChatRE.Lines.Add(msg);
ChatRE.SelLength:=length(msg);

ChatRE.Lines.EndUpdate;
SendMessage(ChatRE.Handle, EM_SCROLL, SB_BOTTOM, 0);
end;

procedure TfChatFrame.ReciveKTSMessage(msg: string);
var
 s, title: string;
 today : TDateTime;
begin
today := Time;

Title:=PJIDNameItem(JIDNameList.Items[ID])^.FLName+'  ['+TimeToStr(today)+']';

rMessage(title,msg);

show;
SendRE.SetFocus;
end;

procedure TfChatFrame.SendKTSMessage;
var
  today : TDateTime;
  s, title, msg: string;
begin
if FMain.JabberClient1.Connected =false then exit;

today := Time;

Fmain.JabberClient1.SendMessage(PJIDNameItem(JIDNameList.Items[id])^.JID,
  'chat',SendRE.Lines.Text);

  msg:=SendRE.Lines.Text;
  SendRE.Clear;

  title:=fMain.LName.Caption+'  ['+TimeToStr(today)+']';

  sMessage(title,msg);
end;

procedure TfChatFrame.GetHistory;
var
  log: string;
  XMLParser: TGmXML;
  XMLItem, tmpitem: TGmXmlNode;
  i: integer;
  title, msg: string;
  today : TDateTime;
begin
  ChatRE.Clear;
  sigmd5 := mid + 'api_id=1911526count=10format=XMLmethod=messages.getHistoryuid=' +
    PJIDNameItem(JIDNameList.Items[ID])^.UID + 'v=3.0' + secret;
  sigmd5 := md5(sigmd5);

  log := fMain.IdHTTP1.get('http://api.vkontakte.ru/api.php?api_id=1911526'+
    '&uid=' + PJIDNameItem(JIDNameList.Items[ID])^.UID+
    '&format=XML&method=messages.getHistory&sid=' + sid +
    '&count=10&sig=' + sigmd5 + '&v=3.0');

  XMLParser := TGmXML.create(self);
  XMLParser.Text := log;
  XMLItem := XMLParser.Nodes.Root;;
  i:= XMLItem.Children.Count-1;
while i>=0 do
begin
  tmpitem:=XMLItem.Children.Node[i];
  if tmpitem.Name='message' then
  begin
    today:=UnixTimeToDateTime(strtoint(tmpitem.Children.NodeByName['date'].AsString));

    if tmpitem.Children.NodeByName['from_id'].AsString=PJIDNameItem(JIDNameList.Items[ID])^.UID
    then begin
      title:=PJIDNameItem(JIDNameList.Items[ID])^.FLName+'  ['+
      TimeToStr(today)+'  '+DateToStr(today)+']';
      msg:=tmpitem.Children.NodeByName['body'].AsString;
      rMessage(title, msg+#13#10,false);
    end else begin
      title:=fMain.LName.Caption+'  ['+
      TimeToStr(today)+'  '+DateToStr(today)+']';
      msg:=tmpitem.Children.NodeByName['body'].AsString;
      sMessage(title, msg+#13#10, false);
    end;
  end;
  i:=i-1;
end;
  FreeAndNil(XMLParser);
end;


procedure TfChatFrame.SendREKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key=13) and (ssCtrl in Shift) then begin
  exit;
end;

if key=13 then
  SendKTSMessage;
end;

end.
