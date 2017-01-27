unit variable;

interface

uses
  Classes, SysUtils, Graphics;

const
  VEXT: AnsiString = 'VKIM';

type
  TCharSet = set of AnsiChar;

  TUserSettings = record
    Fext : string[4];
    FEMail: String[30];
    FPassword: String[30];
  end;

  TOnlineInfo = record
    Status: string[128];
    avaID: integer;
    Online: boolean;
  end;

  PJIDNameItem = ^TJIDNameItem;
  TJIDNameItem = record
    JID:  string[30];
    UID:   string[12];
    GROUP:string[28];
    FLName: string[40];
    info: TOnlineInfo;
  end;

  PVDItem = ^TVDItem;
  TVDItem = record
    ID: integer;
    FLName: string[50];
  end;

  TSkinList = record
    groups: TBitMap;
    groupso: TBitMap;
    vgroups: TBitMap;
    vgroupso: TBitMap;
//    groupscrol: TBitMap;
  end;

  TGIFVersionRec = array[0..2] of ansichar;

  TGIFHeaderRec = packed record
    Signature: array[0..2] of ansichar; { contains 'GIF' }
    Version: TGIFVersionRec;   { '87a' or '89a' }
  end;

  procedure InitKTSLists;
  procedure FreeKTSList;

  function GetId(domain: string):string;
  function StripNonConforming(const S: string;
  const ValidChars: TCharSet): string;
  function DomExtract(s: string): string;
  function isID(s: string): boolean;
  function StripNonNumeric(const S: string): string;
  function FindIDItem(id: string): integer;
  procedure GetOnlineList;
  function JidtoItemID(jid: string): integer;

  procedure ResizeSkin(width,height: integer);

var
  ProfileList: TStrings;
  JIDNameList: TList;
  GroupsList: TStrings;
  OnlineList: TStrings;
  UserSettings: TUserSettings;
  SkinList: TSkinList;

  AvaDir: string;

implementation

uses
  func;

procedure InitKTSLists;
begin
ProfileList:=TStringList.Create;
JIDNameList:=TList.Create;
GroupsList:=TStringList.Create;
OnlineList:=TStringList.Create;

SkinList.groups:=TBitMap.Create;
SkinList.groupso:=TBitMap.Create;
SkinList.vgroups:=TBitMap.Create;
SkinList.vgroupso:=TBitMap.Create;
//SkinList.groupscrol:=TBitMap.Create;
end;

procedure FreeKTSList;
begin
SkinList.vgroups.free;
SkinList.vgroupso.free;
SkinList.groups.free;
SkinList.groupso.free;
//SkinList.groupscrol.free;

ProfileList.Free;
JIDNameList.Free;
GroupsList.Free;
OnlineList.Free;
end;

procedure ResizeSkin(width,height: integer);
var
  bmp: TBitMap;
begin
if (width>=SkinList.groups.Width*2) or (width>=SkinList.groupso.Width*2) then exit;

  bmp:=TBitMap.Create;

  bmp.Assign(SkinList.groups);
  ResizeBitMap(bmp,SkinList.vgroups,width, height);

  bmp.Assign(SkinList.groupso);
  ResizeBitMap(bmp,SkinList.vgroupso,width, height);

  bmp.Free;
end;


function JidtoItemID(jid: string): integer;
var
  s: string;
begin
  s:=domExtract(jid);
  if not isID(s) then
    s:=GetId(s);
  result:=FindIDItem(s);
end;

procedure GetOnlineList;
var
  i: integer;
begin
  OnlineList.Clear;
  for i := 0 to JIDNameList.Count - 1 do
    if PJIDNameItem(JIDNameList.Items[i])^.info.Online then
        OnlineList.Add(inttostr(i));
end;

function StripNonNumeric(const S: string): string;
begin
  Result := StripNonConforming(S, ['0'..'9'])
end;

function isID(s: string): boolean;
begin
  if s=StripNonNumeric(s) then
    result:=true
  else
    result:=false;
end;

function GetId(domain: string):string;
var
  i: integer;
  rs: string;
begin
  rs:='error';
for I := 0 to JIDNameList.Count - 1 do
  if PJIDNameItem(JIDNameList.Items[i])^.JID=domain+'@vk.com' then
    rs:=PJIDNameItem(JIDNameList.Items[i])^.UID;
  result:=rs;
end;

function StripNonConforming(const S: string;
  const ValidChars: TCharSet): string;
var
  DestI: Integer;
  SourceI: Integer;
begin
  SetLength(Result, Length(S));
  DestI := 0;
  for SourceI := 1 to Length(S) do
    if S[SourceI] in ValidChars then
    begin
      Inc(DestI);
      Result[DestI] := S[SourceI]
    end;
  SetLength(Result, DestI)
end;

function FindIDItem(id: string): integer;
var
 i, Rs: integer;
begin
  rs:=-1;
  for I := 0 to JIDNameList.Count - 1 do
    if PJIDNameItem(JIDNameList.Items[i])^.UID=id then
        rs:=i;
  Result:=rs;
end;

function DomExtract(s: string): string;
var
  i,b: integer;
begin
  b:=AnsiPos('@vk.com',s);
  if Copy(s,1,2)='id' then  begin
    if length(StripNonNumeric(s))=length(Copy(s,3,b-3)) then
    Result:=Copy(s,3,b-3) else
    Result:=Copy(s,1,b-1);
  end else begin
    Result:=Copy(s,1,b-1);
  end;
end;

end.
