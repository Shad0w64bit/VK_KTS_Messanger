unit uMainFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TfrMain = class(TFrame)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses uMain;

{$R *.dfm}

procedure TfrMain.CheckBox1Click(Sender: TObject);
begin
 fMain.Panel1.Visible:=CheckBox1.Checked;
 if CheckBox1.Checked then
    fMain.EStatusO.Visible:=false
 else
    fMain.EStatusO.Visible:=true;
end;

procedure TfrMain.CheckBox2Click(Sender: TObject);
begin
    fMain.NOnOFF.Checked:=CheckBox2.Checked;
    fMain.SetContactList;
end;

end.
