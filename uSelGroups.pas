unit uSelGroups;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, variable, func;

type
  TfSelGroups = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ID: integer;
    procedure Load;
  end;

var
  fSelGroups: TfSelGroups;

implementation

uses uMain;

{$R *.dfm}

procedure TfSelGroups.Button1Click(Sender: TObject);
begin
  if ComboBox1.Text='Äðóçüÿ' then begin
    fMain.JabberClient1.SendNewGroup(PJIDNameItem(JIDNameList.Items[ID])^.JID,
          PJIDNameItem(JIDNameList.Items[ID])^.FLName,'');
    PJIDNameItem(JIDNameList.Items[ID])^.GROUP:=''
  end else begin
    fMain.JabberClient1.SendNewGroup(PJIDNameItem(JIDNameList.Items[ID])^.JID,
          PJIDNameItem(JIDNameList.Items[ID])^.FLName,ComboBox1.Text);
    PJIDNameItem(JIDNameList.Items[ID])^.GROUP:=ComboBox1.Text;
  end;

  GetGroupList;
  fMain.SetContactList;

  close;
end;

procedure TfSelGroups.Load;
var
  i: integer;
begin
  ComboBox1.Clear;
  if PJIDNameItem(JIDNameList.Items[ID])^.GROUP='' then  begin
    ComboBox1.Items:=GroupsList;
    ComboBox1.ItemIndex:=0;
  end else begin
    ComboBox1.Items.Add('Äðóçüÿ');
    ComboBox1.ItemIndex:=0;
    if GroupsList.Count=0 then exit;
    for I := 0 to GroupsList.Count - 1 do
        if not (PJIDNameItem(JIDNameList.Items[ID])^.GROUP=GroupsList[i]) then
          ComboBox1.Items.Add(GroupsList[i]);
  end;
end;

end.
