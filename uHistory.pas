unit uHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, gmXML, variable, func;

type
  TfHistory = class(TForm)
    Panel1: TPanel;
    ChatRE: TRichEdit;
    TBMessage: TTrackBar;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure TBMessageChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure GetHistory(messages, offset: integer);
    procedure rMessage(title, msg: string; bold: boolean = true);
    procedure sMessage(title, msg: string; bold: boolean = true);
  public
    { Public declarations }
    ID: integer;
  end;

var
  fHistory: TfHistory;

implementation

uses uMain;

{$R *.dfm}

procedure TfHistory.rMessage(title, msg: string; bold: boolean = true);
begin
  ChatRE.Lines.BeginUpdate;

  ChatRE.SelStart:=length(ChatRE.Lines.Text);
  ChatRE.SelAttributes.Color:=clBlue;
  if bold then ChatRE.SelAttributes.Style:=[fsBold];
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

procedure TfHistory.sMessage(title, msg: string; bold: boolean = true);
begin
  ChatRE.Lines.BeginUpdate;

  ChatRE.SelStart:=length(ChatRE.Lines.Text);
  ChatRE.SelAttributes.Color:=clred;
  if bold then ChatRE.SelAttributes.Style:=[fsBold];
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

procedure TfHistory.GetHistory(messages, offset: integer);
var
  log, sigmd5: string;
  XMLParser: TGmXML;
  XMLItem, tmpitem: TGmXmlNode;
  i: integer;
  title, msg: string;
  today : TDateTime;
begin
  ChatRE.Clear;
  sigmd5 := mid + 'api_id=1911526count='+inttostr(messages)+'format=XMLmethod=messages.getHistory'+
  'offset='+inttostr(offset)+'uid='+PJIDNameItem(JIDNameList.Items[ID])^.UID + 'v=3.0' + secret;
  sigmd5 := md5(sigmd5);

  log := fMain.IdHTTP1.get('http://api.vkontakte.ru/api.php?api_id=1911526'+
    '&uid=' + PJIDNameItem(JIDNameList.Items[ID])^.UID+
    '&format=XML&method=messages.getHistory&sid=' + sid +
    '&count='+inttostr(messages)+'&offset='+inttostr(offset)+'&sig=' + sigmd5 + '&v=3.0');

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

procedure TfHistory.Button1Click(Sender: TObject);
begin
  Edit1.Text:=inttostr(strtoint(Edit1.Text)+TBMessage.Position);
  GetHistory(TBMessage.Position, strtoint(Edit1.Text));
  if Edit1.Text='0' then
    Button2.Caption:='Ç'
  else Button2.Caption:='<-';
end;

procedure TfHistory.Button2Click(Sender: TObject);
begin
  if not (Edit1.Text='0') then
    Edit1.Text:=inttostr(strtoint(Edit1.Text)-TBMessage.Position);

  if Edit1.Text='0' then
    Button2.Caption:='Ç'
  else Button2.Caption:='<-';

  GetHistory(TBMessage.Position, strtoint(Edit1.Text));
end;

procedure TfHistory.Edit1Change(Sender: TObject);
begin
  if Edit1.Text='0' then
    Button2.Caption:='Ç'
  else Button2.Caption:='<-';
end;

procedure TfHistory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fHistory.Hide;
  fHistory.Free;
end;

procedure TfHistory.TBMessageChange(Sender: TObject);
begin
  Label1.Caption:=inttostr(TBMessage.Position);
end;

end.
