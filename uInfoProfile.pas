unit uInfoProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, variable, func, jpeg, ExtCtrls, StdCtrls;

type
  TfInfoProfile = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    LName: TLabel;
    LNick: TLabel;
    Label3: TLabel;
    LOnOff: TLabel;
    LSex: TLabel;
    LDPhone: TLabel;
    LSPhone: TLabel;
    Label4: TLabel;
    LBDay: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    uid: string;
  end;

var
  fInfoProfile: TfInfoProfile;

implementation

uses uMain;

{$R *.dfm}

procedure TfInfoProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FInfoProfile.Hide;
  FInfoProfile.Free;
end;

procedure TfInfoProfile.FormShow(Sender: TObject);
var log :string;
    MS:TMemoryStream;
    pic: TJPEGImage;
    sigmd5, photo: string;
// метод getProfiles. ID берем из ProfileEdit
begin
 sigmd5:=uMain.mid+'api_id=1911526fields=sex,nickname,bdate,city,country,timezone,photo_big,has_mobile,rate,contacts,educationformat=XMLmethod=getProfilesuids='+uid+'v=3.0'+uMain.secret;
 sigmd5:=md5(sigmd5);
 log:=fMain.IdHTTP1.get('http://api.vkontakte.ru/api.php?api_id=1911526&format=XML&method=getProfiles&sid='+sid+'&sig='+sigmd5+'&uids='+UID+'&v=3.0&fields=sex,nickname,bdate,city,country,timezone,photo_big,has_mobile,rate,contacts,education');
 LName.Caption:=Pars('<first_name>', log, '</first_name>')+' '+
  Pars('<last_name>', log, '</last_name>');
  case strtoint(Pars('<sex>', log, '</sex>')) of
    0: LSex.Caption:='Пол не указан';
    1: LSex.Caption:='Женский';
    2: LSex.Caption:='Мужской';
  end;
 LNick.Caption:=Pars('<nickname>', log, '</nickname>');
 LBDay.Caption:=Pars('<bdate>', log, '</bdate>');
 LSPhone.Caption:='Моб. Телефон: '+Pars('<mobile_phone>', log, '</mobile_phone>');
 LDPhone.Caption:='Дом. Телефон: '+Pars('<home_phone>', log, '</home_phone>');
 photo:=Pars('<photo_big>', log, '</photo_big>');

 // запрашиваем фото
 if photo<>'http://vkontakte.ru/images/question_a.gif' then
  begin
   MS:=TMemoryStream.Create;
   pic:= TJPEGImage.Create;
   fMain.idHTTP1.Get(photo,MS);
   MS.Position:=0;
   pic.LoadFromStream(MS);
   image1.Width:=pic.Width;
   image1.Height:=pic.Height;
   Image1.Picture.Assign(pic);
   MS.Free;
   pic.Free;
  end
// else
//  Image1.Picture.LoadFromFile('question_a.jpg');
end;

end.
