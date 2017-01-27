unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, StoHtmlHelp;

type
  TfSettings = class(TForm)
    ListBox1: TListBox;
    ImageList1: TImageList;
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSettings: TfSettings;
  fr: TFrame;

implementation

uses uMainFrame;

{$R *.dfm}

procedure TfSettings.FormShow(Sender: TObject);
begin
        if Assigned(fr) then FreeAndNil(fr);
        fr:=TfrMain.Create(fSettings);
        fr.Parent := fSettings;
        fr.Repaint;
end;

procedure TfSettings.ListBox1Click(Sender: TObject);
begin
  case ListBox1.ItemIndex of
    0: begin
        if Assigned(fr) then FreeAndNil(fr);
        fr:=TfrMain.Create(fSettings);
        fr.Parent := fSettings;
        fr.Repaint;
       end;
    3: Application.HelpSystem.ShowTableOfContents;
  end;
end;

end.
