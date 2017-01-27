unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ExtCtrls, ComCtrls, ImgList, StdCtrls, JvGIF,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, func,
  variable, Jabber, GmXML, Jpeg, Menus;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    VD: TVirtualDrawTree;
    HeaderControl1: THeaderControl;
    IconsList: TImageList;
    StatusBar1: TStatusBar;
    IAvatar: TImage;
    AvaList: TImageList;
    EStatus: TEdit;
    LName: TLabel;
    IdHTTP1: TIdHTTP;
    JabberClient1: TJabberClient;
    PopupMenuContact: TPopupMenu;
    NAddGroup: TMenuItem;
    PopupMenuGroup: TPopupMenu;
    NRename: TMenuItem;
    TrayIcon1: TTrayIcon;
    NOnOFF: TMenuItem;
    ESearch: TEdit;
    EStatusO: TEdit;
    procedure Panel1Resize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure JabberClient1Connect(Sender: TObject);
    procedure JabberClient1ConnectError(Sender: TObject);
    procedure JabberClient1Disconnect(Sender: TObject);
    procedure JabberClient1JabberOnline(Sender: TObject);
    procedure IAvatarClick(Sender: TObject);
    procedure HeaderControl1SectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormShow(Sender: TObject);
    procedure JabberClient1GetRoster(Sender: TObject; RosterList: string);
    procedure FormCreate(Sender: TObject);
    procedure VDGetNodeWidth(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; var NodeWidth: Integer);
    procedure VDDrawNode(Sender: TBaseVirtualTree;
      const PaintInfo: TVTPaintInfo);
    procedure VDInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure VDShowScrollbar(Sender: TBaseVirtualTree; Bar: Integer;
      Show: Boolean);
    procedure VDMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VDCompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure JabberClient1Presence(Sender: TObject; Presence: string);
    procedure JabberClient1GetAvatar(Sender: TObject; jid: string;
      photo: TStream);
    procedure NAddGroupClick(Sender: TObject);
    procedure VDDblClick(Sender: TObject);
    procedure JabberClient1Message(Sender: TObject; jid_user, Messages: string);
    procedure EStatusEnter(Sender: TObject);
    procedure EStatusExit(Sender: TObject);
    procedure EStatusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NOnOFFClick(Sender: TObject);
    procedure ESearchChange(Sender: TObject);
    procedure VDGetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var R: TRect);
    procedure VDDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure TrayIcon1Click(Sender: TObject);
    procedure VDResize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure EStatusOKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EStatusOExit(Sender: TObject);
    procedure EStatusOEnter(Sender: TObject);
  private
    { Private declarations }
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    procedure ConnectAPI;
    procedure GetDomainID;
    procedure SetContactList;
    procedure LoadAvatars;
  end;

var
  fMain: TfMain;
  sigmd5, sid, secret, mid: string;

  tmppopup: Integer;
  StatusMsg: string;

implementation

uses uAuth, uChat, uSelGroups, uSettings;
{$R *.dfm}

procedure TfMain.WMSysCommand;
begin
  if Msg.CmdType = SC_MINIMIZE then
    fMain.Hide
  else
    inherited;
end;

procedure TfMain.LoadAvatars;
var
  i, avaID: Integer;
  bitmap, bitmapD: TBitMap;
  Jpeg: TJPEGImage;
begin
  for i := 0 to JIDNameList.Count - 1 do
  begin
    if fileExists(avadir + '\' + PJIDNameItem(JIDNameList.Items[i])
        ^.UID + '.jpg') then
    begin
      Jpeg := TJPEGImage.create;
      Jpeg.CompressionQuality := 100; { Default Value }
      Jpeg.LoadFromFile(avadir + '\' + PJIDNameItem(JIDNameList.Items[i])
          ^.UID + '.jpg');

      bitmap := TBitMap.create;
      bitmapD := TBitMap.create;
      bitmap.Assign(Jpeg);

      ResizeBitmap(bitmap, bitmapD, 50, 50);
      avaID := AvaList.AddMasked(bitmapD, clNone);

      PJIDNameItem(JIDNameList.Items[i])^.info.avaID := avaID;

      bitmapD.Free;
      bitmap.Free;
      Jpeg.Free;
    end;
  end;
end;

procedure TfMain.ConnectAPI;
var
  data: tstringlist;
  log: string;
begin
  // JabberClient1.JID:=UserSettings.FEMail;

  StatusBar1.Panels[0].Text := 'Подключение 1/2...';
  StatusBar1.Repaint;

  IdHTTP1.ConnectTimeout := 30000;
  IdHTTP1.ReadTimeout := 30000;

  log := IdHTTP1.get(
    'http://vkontakte.ru/login.php?app=1911526&layout=popup&type=browser&settings=15615');

  data := tstringlist.create;
  data.Add('act=login');
  data.Add('app=1911526');
  data.Add('app_hash=' + Pars('app_hash = ''', log, ''''));
  data.Add('email=' + UserSettings.FEMail);
  data.Add('pass=' + UserSettings.FPassword);
  data.Add('permanent=1');
  try
    log := IdHTTP1.post('http://login.vk.com/', data);
    data.clear;
    data.Add('s=' + Pars('value=''', log, ''''));
    data.Add('act=auth_result');
    data.Add('m=4');
    data.Add('permanent=1');
    data.Add('app=1911526');
    data.Add('app_hash=' + Pars('app_hash" value="', log, '"'));
    log := IdHTTP1.post('http://vkontakte.ru/login.php', data);

    if Pos('parent.onDone', log) <> 0 then
    begin
      StatusBar1.Panels[0].Text := 'Подключение 2/2...';
      StatusBar1.Repaint;
      mid := Pars('mid":', log, ',');
      sid := Pars('sid":"', log, '"');
      secret := Pars('secret":"', log, '"');
      JabberClient1.jid := 'id' + mid;
      JabberClient1.Password := UserSettings.FPassword;
      JabberClient1.Connect(0);
    end
    else
    begin
      // ShowMessage('Не удалось подключится :''(');
      StatusBar1.Panels[0].Text := 'Не удалось подключится';
      StatusBar1.Repaint;
    end;
    // Ошибка приложения
  except
    // ShowMessage('Не удалось подключится :''(');
    StatusBar1.Panels[0].Text := 'Авторизация не удалась';
    StatusBar1.Repaint;
    // Авторизация не удалась
  end;
  data.Free;
end;

procedure TfMain.EStatusOEnter(Sender: TObject);
begin
  StatusMsg := EStatus.Text;
end;

procedure TfMain.EStatusOExit(Sender: TObject);
begin
  if ((JabberClient1.Connected) and not(EStatus.Text = StatusMsg)) then
    JabberClient1.SetStatusMessage(EStatus.Text);
end;

procedure TfMain.EStatusOKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    if (JabberClient1.Connected) then
      JabberClient1.SetStatusMessage(EStatus.Text);
end;

procedure TfMain.ESearchChange(Sender: TObject);
begin
  SetContactList;
end;

procedure TfMain.EStatusEnter(Sender: TObject);
begin
  StatusMsg := EStatus.Text;
end;

procedure TfMain.EStatusExit(Sender: TObject);
begin
  if ((JabberClient1.Connected) and not(EStatus.Text = StatusMsg)) then
    JabberClient1.SetStatusMessage(EStatus.Text);
end;

procedure TfMain.EStatusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    if (JabberClient1.Connected) then
      JabberClient1.SetStatusMessage(EStatus.Text);
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fAuth.Close;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
  LoadIcons(IconsList);
  VD.NodeDataSize := SizeOf(TVDItem);
  SkinList.groups.LoadFromFile(extractfilepath(paramstr(0)) + '\group.bmp');
  SkinList.groupso.LoadFromFile(extractfilepath(paramstr(0)) + '\groupo.bmp');
  ResizeSkin(VD.Width - 5, 20);
  AvaList.GetBitmap(0, IAvatar.Picture.Bitmap);
  IAvatar.Repaint;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
  VD.SetFocus;
end;

procedure TfMain.HeaderControl1SectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  case Section.ID of
    0:
      begin
        if JabberClient1.Connected then
          JabberClient1.Disconnect
        else
          ConnectAPI;
      end;
    1:
      if ESearch.Visible then
      begin
        ESearch.Visible := false;
        SetContactList;
      end
      else
      begin
        ESearch.Visible := true;
        ESearch.SetFocus;
        SetContactList;
      end;
    2:
      begin
        FSettings.Show;
      end;
  end;
end;

procedure TfMain.IAvatarClick(Sender: TObject);
begin
  HeaderControl1.Sections[0].ImageIndex := 1;
end;

procedure TfMain.JabberClient1Connect(Sender: TObject);
var
  log: string;
begin
  sigmd5 := mid + 'api_id=1911526format=XMLmethod=activity.getv=3.0' + secret;
  sigmd5 := md5(sigmd5);

  log := IdHTTP1.get('http://api.vkontakte.ru/api.php?api_id=1911526&' +
      'format=XML&method=activity.get&sid=' + sid + '&sig=' + sigmd5 +
      '&v=3.0');

  EStatus.Text := ReplaceXml(Pars('<activity>', log, '</activity>'));
  EStatusO.Text:=EStatus.Text;

  sigmd5 := mid + 'api_id=1911526format=XMLmethod=getProfilesuids=' + mid +
    'v=3.0' + secret;
  sigmd5 := md5(sigmd5);

  log := IdHTTP1.get
    ('http://api.vkontakte.ru/api.php?api_id=1911526' + '&uids=' +
      mid + '&format=XML&method=getProfiles&sid=' + sid + '&sig=' + sigmd5 +
      '&v=3.0');

  LName.Caption := Pars('<first_name>', log, '</first_name>') + ' ' + Pars
    ('<last_name>', log, '</last_name>');

  HeaderControl1.Sections[0].ImageIndex := 1;
  StatusBar1.Panels[0].Text := 'Загрузка контактов...';
end;

procedure TfMain.JabberClient1ConnectError(Sender: TObject);
begin
  HeaderControl1.Sections[0].ImageIndex := 0;
  StatusBar1.Panels[0].Text := 'Ошибка связи';
end;

procedure TfMain.JabberClient1Disconnect(Sender: TObject);
begin
  HeaderControl1.Sections[0].ImageIndex := 0;
  StatusBar1.Panels[0].Text := 'Отключен';
end;

procedure TfMain.SetContactList;
var
  i, j: Integer;
  gname, s1, s2: string;
  NewNode, NewNodeO, tmpNode: PVirtualNode;
  oInfo: PVDItem;
begin
  VD.clear;

  if ESearch.Visible then
  begin

    NewNode := VD.InsertNode(VD.RootNode, amInsertBefore);
    oInfo := VD.GetNodeData(NewNode);
    if Assigned(oInfo) then
    begin
      oInfo^.FLName := 'Результаты поиска';
      oInfo^.ID := -1;
    end;
    for i := 0 to JIDNameList.Count - 1 do
    begin
      s1 := AnsiUpperCase(PJIDNameItem(JIDNameList.Items[i])^.FLName);
      s2 := AnsiUpperCase(ESearch.Text);
      if Pos(s2, s1) > 0 then
      begin
        tmpNode := VD.AddChild(NewNode);
        oInfo := VD.GetNodeData(tmpNode);
        oInfo^.ID := i;
      end;
    end;
    VD.FullExpand(NewNode);
    VD.SortTree(VD.Header.Columns.Items[0].Index, VD.Header.SortDirection);
    exit;
  end;

  if NOnOFF.Checked then
  begin
    NewNodeO := VD.InsertNode(VD.RootNode, amInsertBefore);
    oInfo := VD.GetNodeData(NewNodeO);
    if Assigned(oInfo) then
    begin
      oInfo^.FLName := 'Онлайн';
      oInfo^.ID := -1;
    end;

    NewNode := VD.InsertNode(VD.RootNode, amInsertBefore);
    oInfo := VD.GetNodeData(NewNode);
    if Assigned(oInfo) then
    begin
      oInfo^.FLName := 'Оффлайн';
      oInfo^.ID := -1;
    end;

    for i := 0 to JIDNameList.Count - 1 do
    begin
      if PJIDNameItem(JIDNameList.Items[i])^.info.Online then
      begin
        tmpNode := VD.AddChild(NewNodeO);
        oInfo := VD.GetNodeData(tmpNode);
        oInfo^.ID := i;
      end
      else
      begin
        tmpNode := VD.AddChild(NewNode);
        oInfo := VD.GetNodeData(tmpNode);
        oInfo^.ID := i;
      end;
    end;

  end
  else
  begin

    for j := 0 to GroupsList.Count - 1 do
    begin
      gname := GroupsList.Strings[j];
      NewNode := VD.InsertNode(VD.RootNode, amInsertBefore);
      oInfo := VD.GetNodeData(NewNode);
      if Assigned(oInfo) then
      begin
        oInfo^.FLName := gname;
        oInfo^.ID := -1;
      end;
      for i := 0 to JIDNameList.Count - 1 do
      begin
        if PJIDNameItem(JIDNameList.Items[i])^.GROUP = gname then
        begin
          tmpNode := VD.AddChild(NewNode);
          oInfo := VD.GetNodeData(tmpNode);
          if Assigned(oInfo) then
            oInfo^.ID := i;
        end;
      end;
    end;

    NewNode := VD.InsertNode(VD.RootNode, amInsertBefore);
    oInfo := VD.GetNodeData(NewNode);
    if Assigned(oInfo) then
    begin
      oInfo^.FLName := 'Друзья';
      oInfo^.ID := -1;
    end;
    for i := 0 to JIDNameList.Count - 1 do
    begin
      if PJIDNameItem(JIDNameList.Items[i])^.GROUP = '' then
      begin
        tmpNode := VD.AddChild(NewNode);
        oInfo := VD.GetNodeData(tmpNode);
        oInfo^.ID := i;
      end;
    end;
  end;

  VD.SortTree(VD.Header.Columns.Items[0].Index, VD.Header.SortDirection);
end;

procedure TfMain.TrayIcon1Click(Sender: TObject);
begin
  if fMain.Showing then
  begin
    SetForegroundWindow(fMain.Handle);
    fMain.SetFocus;
  end
  else
  begin
    SetForegroundWindow(fMain.Handle);
    fMain.Show;
    fMain.SetFocus;
  end;
end;

procedure TfMain.TrayIcon1DblClick(Sender: TObject);
begin
if fMain.Showing then
  fMain.Hide;
end;

procedure TfMain.VDCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PVDItem;
  n1, n2: Boolean;
  i: Integer;
begin
  if (Node1.Parent = VD.RootNode) or (Node2.Parent = VD.RootNode) then
    exit;

  Data1 := VD.GetNodeData(Node1);
  n1 := PJIDNameItem(JIDNameList.Items[Data1^.ID])^.info.Online;
  Data2 := Sender.GetNodeData(Node2);
  n2 := PJIDNameItem(JIDNameList.Items[Data2^.ID])^.info.Online;

  { if n1 and n2=false then
    Result:=1; }

  if n1 and not n2 then
    Result := -1
  else if n2 and not n1 then
    Result := 1
  else if n1 = n2 then
    Result := 0;
end;

procedure TfMain.VDDblClick(Sender: TObject);
var
  info: PVDItem;
begin
  if VD.FocusedNode = nil then
    exit;

  if VD.FocusedNode.Parent = VD.RootNode then
    exit;

  info := VD.GetNodeData(VD.FocusedNode);
  // showmessage(PJIDNameItem(JIDNameList.Items[info^.ID])^.FLName);

  FChat.AddItem(info^.ID, PJIDNameItem(JIDNameList.Items[info^.ID])^.FLName);
  if FChat.Showing then
    FChat.SetFocus
  else
    FChat.Show;
  // не наоборот!
end;

procedure TfMain.VDDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
  Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  info: PVDItem;
  OldBkMode: Integer;
  Format: Word;
  tmpstr: string;
  tmpRect: TRect;
begin
  if Node = nil then
    exit;

  info := VD.GetNodeData(Node);

  if Node.Parent = VD.RootNode then
  begin
    with HintCanvas do
    begin
      brush.Color := clSilver;
      FillRect(R);
      tmpstr := info^.FLName;
      Font.Size := 10;
      Font.Color := clBlack;
      TextOut(4, 2, tmpstr);
      Font.Size := 8;
      TextOut(4, 18, 'Участников: ' + inttostr(Node.ChildCount));
    end;
  end
  else
  begin
    Format := DT_LEFT or DT_WORDBREAK;

    with HintCanvas do
    begin
      brush.Color := clSilver;
      FillRect(R);

      if not(PJIDNameItem(JIDNameList.Items[info^.ID])^.info.avaID = -1) then
        AvaList.Draw(HintCanvas, 2, 2,
          PJIDNameItem(JIDNameList.Items[info^.ID])^.info.avaID)
      else
        AvaList.Draw(HintCanvas, 2, 2, 0);
      brush.Color := clRed;
      OldBkMode := SetBkMode(HintCanvas.Handle, TRANSPARENT);
      Font.Size := 12;
      Font.Color := clBlack;
      tmpRect := R;
      tmpRect.Left := 54;
      tmpstr := PJIDNameItem(JIDNameList.Items[info^.ID])^.FLName;
      DrawText(HintCanvas.Handle, tmpstr, length(tmpstr), tmpRect, Format);
      // TextOut(58, 8, tmpstr, length(tmpstr),);
      tmpstr := PJIDNameItem(JIDNameList.Items[info^.ID])^.info.Status;
      tmpRect.Top := 25;
      DrawText(HintCanvas.Handle, tmpstr, length(tmpstr), tmpRect, Format);
      // TextOut(58, 25, PJIDNameItem(JidNameList.Items[info^.ID])^.info.Status);
      SetBkMode(HintCanvas.Handle, OldBkMode);
    end;
  end;
end;

procedure TfMain.VDDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var
  Names: string;
  info: PVDItem;
  OldBkMode: Integer;
begin
  info := VD.GetNodeData(PaintInfo.Node);

  if PaintInfo.Node.Parent = Sender.RootNode then
  begin
    if VD.Expanded[PaintInfo.Node] then
      PaintInfo.Canvas.Draw(0, 0, SkinList.vgroupso)
    else
      PaintInfo.Canvas.Draw(0, 0, SkinList.vgroups);
    { Paintinfo.Canvas.brush.Color:=clSilver;
      Paintinfo.Canvas.FillRect(rect(0,0,Paintinfo.NodeWidth,Paintinfo.Node.NodeHeight)); }
    PaintInfo.Canvas.Font.Size := 8;
    PaintInfo.Canvas.Font.Color := clBlack;
    PaintInfo.Canvas.Font.Style := [fsBold];
    info := VD.GetNodeData(PaintInfo.Node);
    OldBkMode := SetBkMode(PaintInfo.Canvas.Handle, TRANSPARENT);
    PaintInfo.Canvas.TextOut(8, 2, info^.FLName);
    SetBkMode(PaintInfo.Canvas.Handle, OldBkMode);
  end
  else
  begin
    with PaintInfo.Canvas do
    begin
      PaintInfo.Canvas.Font.Style := [];
      if (VD.Selected[PaintInfo.Node]) then
      begin
        brush.Color := $00F8F0EC;
        FillRect(rect(0, 0, PaintInfo.NodeWidth, PaintInfo.Node.NodeHeight));
        Font.Color := $00CDB6B1;
        DrawFocusRect(rect(0, 0, PaintInfo.NodeWidth - 1,
            PaintInfo.Node.NodeHeight - 1));
      end
      else
      begin
        brush.Color := clWhite;
        FillRect(rect(0, 0, PaintInfo.NodeWidth, PaintInfo.Node.NodeHeight));
      end;

      if (PJIDNameItem(JIDNameList.Items[info^.ID])^.info.Online) then
        IconsList.Draw(PaintInfo.Canvas, 2, 2, 1)
      else
        IconsList.Draw(PaintInfo.Canvas, 2, 2, 0);

      brush.Color := clRed;
      OldBkMode := SetBkMode(PaintInfo.Canvas.Handle, TRANSPARENT);
      Font.Size := 10;
      Font.Color := clBlack;
      TextOut(20, 2, PJIDNameItem(JIDNameList.Items[info^.ID])^.FLName);
      SetBkMode(PaintInfo.Canvas.Handle, OldBkMode);
    end;
  end;
end;

procedure TfMain.VDGetHintSize(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var R: TRect);
var
  info: PVDItem;
  Format: Word;
  tmpstr: string;
  tmpRect: TRect;
  log: string;
begin
  if Node = nil then
    exit;

  if Node.Parent = VD.RootNode then
  begin
    R.Top := 0;
    R.Left := 0;
    R.Right := 150;
    R.Bottom := 50;
  end
  else
  begin
    info := VD.GetNodeData(Node);
    JabberClient1.GetPhoto(PJIDNameItem(JIDNameList.Items[info^.ID])^.jid);

    if PJIDNameItem(JIDNameList.Items[info^.ID])^.info.Status = '' then
    begin
      sigmd5 := mid + 'api_id=1911526format=XMLmethod=activity.getuid=' +
        PJIDNameItem(JIDNameList.Items[info^.ID])^.UID + 'v=3.0' + secret;
      sigmd5 := md5(sigmd5);

      log := fMain.IdHTTP1.get
        ('http://api.vkontakte.ru/api.php?api_id=1911526' +
          '&uid=' + PJIDNameItem(JIDNameList.Items[info^.ID])
          ^.UID
          + '&format=XML&method=activity.get&sid=' + sid + '&sig=' + sigmd5 +
          '&v=3.0');

      PJIDNameItem(JIDNameList.Items[info^.ID])^.info.Status := ReplaceXml(Pars
        ('<activity>', log, '</activity>'));
    end;

    Format := DT_LEFT or DT_WORDBREAK or DT_CALCRECT;
    fMain.Canvas.Font.Size := 12;

    tmpstr := PJIDNameItem(JIDNameList.Items[info^.ID])^.info.Status;
    tmpRect.Top := 0;
    tmpRect.Left := 0;
    tmpRect.Right := 256;
    tmpRect.Bottom := 0;

    DrawText(fMain.Canvas.Handle, tmpstr, length(tmpstr), tmpRect, Format);

    R := tmpRect;
    R.Top := 0;
    R.Left := 0;
    if R.Right < 256 then
      R.Right := 300
    else
      R.Right := R.Right + 54;
    R.Bottom := R.Bottom + 38;
    if R.Bottom < 54 then
      R.Bottom := 54
    else
    end;
  end;

  procedure TfMain.VDGetNodeWidth(Sender: TBaseVirtualTree;
    HintCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
    var NodeWidth: Integer);
  begin
    NodeWidth := VD.Header.Columns[Column].Width;
    // NodeWidth:=VD.Width-20;
  end;

  procedure TfMain.VDInitNode(Sender: TBaseVirtualTree;
    ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  begin
    if Node.Parent = Sender.RootNode then
      Sender.NodeHeight[Node] := 20
    else
      Sender.NodeHeight[Node] := 20;
  end;

  procedure TfMain.VDMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  var
    info: PVDItem;
    OldBkMode: Integer;
    Node: PVirtualNode;
  begin
    Node := VD.GetNodeAt(X, Y);
    if Node = nil then
      exit;

    if (mbRight = Button) then
    begin

      if Node.Parent = VD.RootNode then
      begin
        tmppopup := Node.Index;
        VD.PopupMenu := PopupMenuGroup;
        exit;
      end;

      VD.PopupMenu := PopupMenuContact;
      info := VD.GetNodeData(Node);
      tmppopup := info.ID;
      VD.Selected[Node] := true;
    end;
  end;

procedure TfMain.VDResize(Sender: TObject);
  function ScrollBarVisible(Handle: HWnd; Style: Longint): Boolean;
  begin
    Result := (GetWindowLong(Handle, GWL_STYLE) and Style) <> 0;
  end;
begin
//if VD.RootNodeCount=0 then exit;

  if ScrollBarVisible(VD.Handle, WS_VSCROLL) then
    VD.Header.Columns[0].Width := VD.Width - GetSystemMetrics(SM_CXVSCROLL)- 5
  else
    VD.Header.Columns[0].Width := VD.Width - 5;

  ResizeSkin(VD.Width - 5, 20);
  VD.Realign;
  VD.Repaint;
end;

procedure TfMain.VDShowScrollbar(Sender: TBaseVirtualTree; Bar: Integer;
    Show: Boolean);
  function ScrollBarVisible(Handle: HWnd; Style: Longint): Boolean;
  begin
    Result := (GetWindowLong(Handle, GWL_STYLE) and Style) <> 0;
  end;
begin
  if ScrollBarVisible(VD.Handle, WS_VSCROLL) then
    VD.Header.Columns[0].Width := VD.Width - GetSystemMetrics(SM_CXVSCROLL)- 5
  else
    VD.Header.Columns[0].Width := VD.Width - 5;

  VD.Realign;
  VD.Repaint;
end;

  procedure TfMain.GetDomainID;
  type
    TCharSet = set of AnsiChar;

    function StripNonConforming(const S: string;
      const ValidChars: TCharSet): string;
    var
      DestI: Integer;
      SourceI: Integer;
    begin
      SetLength(Result, length(S));
      DestI := 0;
      for SourceI := 1 to length(S) do
        if S[SourceI] in ValidChars then
        begin
          Inc(DestI);
          Result[DestI] := S[SourceI]
        end;
      SetLength(Result, DestI)
    end;

    function StripNonNumeric(const S: string): string;
    begin
      Result := StripNonConforming(S, ['0' .. '9'])
    end;

    function DomExtract(S: string): string;
    var
      i, b: Integer;
    begin
      b := AnsiPos('@vk.com', S);
      if Copy(S, 1, 2) = 'id' then
      begin
        if length(StripNonNumeric(S)) = length(Copy(S, 3, b - 3)) then
          Result := Copy(S, 3, b - 3)
        else
          Result := Copy(S, 1, b - 1);
      end
      else
      begin
        Result := Copy(S, 1, b - 1);
      end;
    end;

  var
    i, itmp: Integer;
    log, dom, tmps: string;
    APIvkList: TStrings;
    XMLParser: TGmXML;
    XMLItem, tmpItem: TGmXmlNode;
  begin
    APIvkList := tstringlist.create;
    dom := '';
    for i := 0 to JIDNameList.Count - 1 do
    begin
      tmps := DomExtract(PJIDNameItem(JIDNameList.Items[i])^.jid);
      if tmps = StripNonNumeric(tmps) then
        PJIDNameItem(JIDNameList.Items[i])^.UID := tmps
      else
      begin
        APIvkList.Add(inttostr(i));
        if dom = '' then
          dom := tmps
        else
          dom := dom + ',' + tmps;
      end;
    end;

    sigmd5 := mid + 'api_id=1911526domains=' + dom +
      'format=XMLmethod=getProfilesv=3.0' + secret;
    sigmd5 := md5(sigmd5);

    log := IdHTTP1.get('http://api.vkontakte.ru/api.php?api_id=1911526' +
        '&domains=' + dom + '&format=XML&method=getProfiles&sid=' + sid +
        '&sig=' + sigmd5 + '&v=3.0');

    // XMLItem := XMLParser.Nodes.NodeByName['query'];
    // XMLItem := XMLParser.Nodes.Root.Children.NodeByName['query'];
    // showmessage(XmlItem.Children.Node[0]);
    XMLParser := TGmXML.create(self);

    XMLParser.Text := log;

    XMLItem := XMLParser.Nodes.Root;
    // xmlparser.Nodes.Root.Children.Count
    // Pairs := TStringlist.Create();
    for i := 0 to XMLItem.Children.Count - 1 do
    begin
      itmp := strtoint(APIvkList.Strings[i]);
      PJIDNameItem(JIDNameList.Items[itmp])^.UID := XMLItem.Children.Node[i]
        .Children.NodeByName['uid'].AsString;
    end;

    APIvkList.Free;
    FreeAndNil(XMLParser);
  end;

  procedure TfMain.JabberClient1GetAvatar(Sender: TObject; jid: string;
    photo: TStream);
  var
    bitmap, bitmapD: TBitMap;
    Jpeg: TJPEGImage;
    i, j, avaID: Integer;
    GNode, INode: PVirtualNode;
    gif: TGIFHeaderRec;
    S: string;
  begin
    photo.ReadBuffer(gif, SizeOf(TGIFHeaderRec));
    photo.Position := 0;

    if gif.Signature = 'GIF' then
      exit;

    Jpeg := TJPEGImage.create;
    Jpeg.CompressionQuality := 100; { Default Value }
    Jpeg.LoadFromStream(photo);

    bitmap := TBitMap.create;
    bitmapD := TBitMap.create;
    bitmap.Assign(Jpeg);

    ResizeBitmap(bitmap, bitmapD, 50, 50);
    avaID := AvaList.AddMasked(bitmapD, clNone);

    if jid = JabberClient1.jid + '@vk.com' then
      IAvatar.Picture.bitmap.Assign(bitmap)
    else
    begin
      j := JidtoItemID(jid);
      PJIDNameItem(JIDNameList.Items[j])^.info.avaID := avaID;

      S := avadir + '\' + PJIDNameItem(JIDNameList.Items[j])^.UID + '.jpg';
      Jpeg.SaveToFile(S);
    end;

    FChat.ReloadAvatar;

    bitmapD.Free;
    bitmap.Free;
    Jpeg.Free;
  end;

  procedure TfMain.JabberClient1GetRoster(Sender: TObject; RosterList: string);
  var
    XMLParser: TGmXML;
    XMLItem, tmpItem: TGmXmlNode;
    i: Integer;
    JIDNameItem: PJIDNameItem;
  begin
    JIDNameList.Clear;

    XMLParser := TGmXML.create(self);

    XMLParser.Text := RosterList;
    // XMLItem := XMLParser.Nodes.NodeByName['query'];
    XMLItem := XMLParser.Nodes.Root.Children.NodeByName['query'];
    // showmessage(XmlItem.Children.Node[0]);

    // Pairs := TStringlist.Create();
    for i := 0 to XMLItem.Children.Count - 1 do
    begin
      GetMem(JIDNameItem, SizeOf(JIDNameItem^));
      JIDNameItem^.jid := '';
      JIDNameItem^.UID := '';
      JIDNameItem^.GROUP := '';
      JIDNameItem^.FLName := '';
      JIDNameItem^.info.Status := '';
      JIDNameItem^.info.avaID := 0;
      JIDNameItem^.info.Online := false;

      JIDNameItem^.jid := XMLItem.Children.Node[i].Params.Values['jid'];

      JIDNameItem^.FLName := XMLItem.Children.Node[i].Params.Values['name'];
      if XMLItem.Children.Node[i].Children.NodeByName['group'] <> nil then
        JIDNameItem^.GROUP := XMLItem.Children.Node[i].Children.NodeByName
          ['group'].AsString
      else
        JIDNameItem^.GROUP := '';
      JIDNameList.Add(JIDNameItem);
    end;

    FreeAndNil(XMLParser);
    GetDomainID;
    application.ProcessMessages;
    LoadAvatars;
    application.ProcessMessages;

    GetGroupList;

    SetContactList;

    JabberClient1.GetPhoto(JabberClient1.jid + '@vk.com');

    // GetStatus;
    StatusBar1.Panels[0].Text := '';
  end;

  procedure TfMain.JabberClient1JabberOnline(Sender: TObject);
  begin
    HeaderControl1.Sections[0].ImageIndex := 1;
    StatusBar1.Panels[0].Text := '';
  end;

procedure TfMain.JabberClient1Message(Sender: TObject;
  jid_user, Messages: string);
begin
  FChat.ReciveKTSMessage(findiditem(getId(DomExtract(jid_user))), Messages);

  JabberClient1.SendMsgWrite(jid_user);
end;

procedure TfMain.JabberClient1Presence(Sender: TObject; Presence: string);
var
  GM: TGmXML;
  Node: TGmXmlNode;
  i: Integer;
  ID: string;
begin
    GM := TGmXML.create(nil);
    GM.Text := Presence;
    Node := GM.Nodes.Root;

    ID := DomExtract(Node.Params.Values['from']);

    if not(isID(ID)) then
    begin
      ID := getId(ID);
      if ID = 'error' then
      begin
        showmessage('error!!!');
        exit;
      end;
    end;

    if Node.Children.NodeByName['x'] <> nil then
      if Node.Children.NodeByName['x'].Children.NodeByName['photo'] <> nil then
      begin
        PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.info.Online := true;
        TrayIcon1.BalloonTitle:='Статус контакта';
        TrayIcon1.BalloonHint:=PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.FLName+
            ' вошел в сеть';
        TrayIcon1.ShowBalloonHint;
      end else if Node.Params.Values['type'] <> '' then
      begin
        if Node.Params.Values['type'] = 'unavailable' then begin
          PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.info.Online := false;
          TrayIcon1.BalloonTitle:='Статус контакта';
          TrayIcon1.BalloonHint:=PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.FLName+
            ' отключен';
          TrayIcon1.ShowBalloonHint;
        end else begin
          PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.info.Online := true;
          TrayIcon1.BalloonTitle:='Статус контакта';
          TrayIcon1.BalloonHint:=PJIDNameItem(JIDNameList.Items[findiditem(ID)])^.FLName+
            ' вошел в сеть';
          TrayIcon1.ShowBalloonHint;
        end;
      end;

    GM.Free;

    GetOnlineList;
    if NOnOFF.Checked then
      SetContactList;

    VD.SortTree(VD.Header.Columns.Items[0].Index, VD.Header.SortDirection);

    FChat.RefreshOnline; // Оповещание о сообщениях
  end;

procedure TfMain.NAddGroupClick(Sender: TObject);
begin
  FSelGroups := TFSelGroups.Create(Application);
  FSelGroups.ID:=tmppopup;
  FSelGroups.Load;
  FSelGroups.Showmodal;
  FSelGroups.Hide;
  FSelGroups.Free;
end;

  procedure TfMain.NOnOFFClick(Sender: TObject);
  begin
    SetContactList;
  end;

  procedure TfMain.Panel1Resize(Sender: TObject);
  begin
    EStatus.Width := Panel1.Width - 74;
  end;

end.
