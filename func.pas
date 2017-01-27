unit func;

interface

uses
  Windows, Classes, DCPrijndael, DCPsha256, SysUtils, IdHashMessageDigest,
  Graphics, ImgList, Controls;

  function EncryptToFile(FileName, password: string; InputStream: TStream): boolean;
  function DecryptFileTo(FileName, password: string; OutputStream: TStream): boolean;

  function strtst(var Input: Ansistring; EArray: string; Action: integer): Ansistring;
  procedure GetProfileList(Path: string);
  function Pars(T_, ForS, _T: string): string;
  function md5(s: string): string;
  procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);
  procedure GetGroupList;
  procedure LoadIcons(ImageList: TImageList);
  function ReplaceXml(s:string): string;
  function MyRemoveDir(sDir: string): Boolean;
  function UnixTimeToDateTime(UnixTime : LongInt): TDate;

implementation

uses variable;

function ReplaceXml(s:string): string;
begin
s:=StringReplace(s, '&amp;', '&', [rfReplaceAll, rfIgnoreCase]);
s:=StringReplace(s, '&quot;', '"', [rfReplaceAll, rfIgnoreCase]);
s:=StringReplace(s, '&lt;', '<', [rfReplaceAll, rfIgnoreCase]);
result:=StringReplace(s, '&gt;', '>', [rfReplaceAll, rfIgnoreCase]);
end;

function UnixTimeToDateTime(UnixTime : LongInt): TDate;
const
    SecPerDay = 86400;
    Offset1970 = 25569;
begin
    Result := UnixTime / SecPerDay + Offset1970;
end;

function MyRemoveDir(sDir: string): Boolean;
var
  iIndex: Integer;
  SearchRec: TSearchRec;
  sFileName: string;
begin
  Result := False;
  sDir := sDir + '\*.*';
  iIndex := FindFirst(sDir, faAnyFile, SearchRec);

  while iIndex = 0 do
  begin
    sFileName := ExtractFileDir(sDir)+'\'+SearchRec.name;
    if ((SearchRec.Attr and faDirectory) = faDirectory) then
    begin
      if (SearchRec.name <> '' ) and
         (SearchRec.name <> '.') and
         (SearchRec.name <> '..') then
        MyRemoveDir(sFileName);
    end
    else
    begin
      if SearchRec.Attr <> faArchive then
        FileSetAttr(sFileName, faArchive);
        if not SysUtils.DeleteFile(sFileName) then begin
          result:=false;
          exit;
        end;
    end;
    iIndex := FindNext(SearchRec);
  end;

  SysUtils.FindClose(SearchRec);

  RemoveDir(ExtractFileDir(sDir));
  Result := True;
end;

procedure LoadIcons(ImageList: TImageList);
var
  Bmp, tmpbmp: TBitMap;
  i,j: integer;
begin
bmp:=TBitmap.Create;
tmpbmp:=TBitmap.Create;
tmpbmp.Width:=16;
tmpbmp.Height:=16;
bmp.LoadFromFile(extractfilepath(paramstr(0))+'\icons.bmp');
for J := 0 to bmp.Width div 16 -1 do
  for I := 0 to bmp.Height div 16 -1 do
    begin
      tmpbmp.Canvas.CopyRect(Rect(0,0,16,16),bmp.Canvas,rect(i*16,j*16,i*16+16,j*16+16));
      ImageList.AddMasked(tmpbmp, clFuchsia);
    end;

tmpbmp.Free;
bmp.Free;
end;

procedure ResizeBitmap(imgo, imgd: TBitmap; nw, nh: Integer);
 var
   xini, xfi, yini, yfi, saltx, salty: single;
   x, y, px, py, tpix: integer;
   PixelColor: TColor;
   r, g, b: longint;

   function MyRound(const X: Double): Integer;
   begin
     Result := Trunc(x);
     if Frac(x) >= 0.5 then
       if x >= 0 then Result := Result + 1
       else
         Result := Result - 1;
     // Result := Trunc(X + (-2 * Ord(X < 0) + 1) * 0.5);
  end;

 begin
   // Set target size

  imgd.Width  := nw;
   imgd.Height := nh;

   // Calcs width & height of every area of pixels of the source bitmap

  saltx := imgo.Width / nw;
   salty := imgo.Height / nh;


   yfi := 0;
   for y := 0 to nh - 1 do
   begin
     // Set the initial and final Y coordinate of a pixel area

    yini := yfi;
     yfi  := yini + salty;
     if yfi >= imgo.Height then yfi := imgo.Height - 1;

     xfi := 0;
     for x := 0 to nw - 1 do
     begin
       // Set the inital and final X coordinate of a pixel area

      xini := xfi;
       xfi  := xini + saltx;
       if xfi >= imgo.Width then xfi := imgo.Width - 1;


       // This loop calcs del average result color of a pixel area
      // of the imaginary grid

      r := 0;
       g := 0;
       b := 0;
       tpix := 0;

       for py := MyRound(yini) to MyRound(yfi) do
       begin
         for px := MyRound(xini) to MyRound(xfi) do
         begin
           Inc(tpix);
           PixelColor := ColorToRGB(imgo.Canvas.Pixels[px, py]);
           r := r + GetRValue(PixelColor);
           g := g + GetGValue(PixelColor);
           b := b + GetBValue(PixelColor);
         end;
       end;

       // Draws the result pixel

      imgd.Canvas.Pixels[x, y] :=
         rgb(MyRound(r / tpix),
         MyRound(g / tpix),
         MyRound(b / tpix)
         );
     end;
   end;
 end;

function EncryptToFile(FileName, password: string; InputStream: TStream): boolean;
var
  DCP_RSA: TDCP_rijndael;
  OutputStream: TFileStream;
begin
  Result := True;
  try
    OutputStream:=TFileStream.Create(FileName, fmCreate);
    DCP_RSA := TDCP_rijndael.Create(nil);
    DCP_RSA.InitStr(Password, TDCP_sha256);
    DCP_RSA.EncryptStream(InputStream, OutputStream, InputStream.Size);
    DCP_RSA.Burn;
    DCP_RSA.Free;
    OutputStream.Free;
  except
    Result := False;
 end;
end;

function DecryptFileTo(FileName, password: string; OutputStream: TStream): boolean;
var
  DCP_RSA: TDCP_rijndael;
  InputStream: TFileStream;
begin
  Result := True;
  try
    InputStream:=TFileStream.Create(FileName, fmOpenRead);
    DCP_RSA := TDCP_rijndael.Create(nil);
    DCP_RSA.InitStr(Password, TDCP_sha256);
    DCP_RSA.DecryptStream(InputStream, OutputStream, InputStream.Size);
    DCP_RSA.Burn;
    DCP_RSA.Free;
    InputStream.Free;
  except
    Result := False;
  end;
end;

function md5(s: string): string;
begin
Result := '';
  with TIdHashMessageDigest5.Create do
  try
    Result :=LowerCase(HashStringAsHex(s));
  finally
    Free;
  end;
end;

function Pars(T_, ForS, _T: string): string;
var
  a, b: integer;
begin
  Result := '';
  if (T_ = '') or (ForS = '') or (_T = '') then
    Exit;
  a := Pos(T_, ForS);
  if a = 0 then
    Exit
  else
    a := a + Length(T_);
  ForS := Copy(ForS, a, Length(ForS) - a + 1);
  b := Pos(_T, ForS);
  if b > 0 then
    Result := Copy(ForS, 1, b - 1);
end;

function strtst(var Input: Ansistring; EArray: string; Action: integer): Ansistring;
begin
  case Action of
    1:
      begin
        while length(Input) <> 0 do
        begin
          if pos(Input[1], EArray) = 0 then
            delete(Input, 1, 1)
          else
          begin
            result := result + Input[1];
            delete(Input, 1, 1);
          end;
        end;
      end;
    2:
      begin
        while length(Input) <> 0 do
        begin
          if pos(Input[1], EArray) <> 0 then
            delete(Input, 1, 1)
          else
          begin
            result := result + Input[1];
            delete(Input, 1, 1);
          end;
        end;
      end;
  end;
end;

procedure GetGroupList;
var
  i: integer;
  ngroup: ansistring;
begin
  GroupsList.Clear;
  for i := 0 to JIDNameList.Count - 1 do begin
    ngroup:=PJIDNameItem(JIDNameList.Items[i])^.GROUP;
    if length(ngroup)>3 then begin
      if GroupsList.IndexOfName(ngroup)=-1 then
        GroupsList.Add(ngroup);
    end;
  end;
end;

procedure GetProfileList(Path: string);
var
  SR: TSearchRec;
  FindRes: Integer;
begin
  ProfileList.Clear;
 FindRes := FindFirst(Path+'\*.*', faAnyFile, SR);
  while FindRes = 0 do
  begin
    // если найденный элемент каталог и
    if ((SR.Attr and faDirectory) = faDirectory) and
      // он имеет название "." или "..", тогда:
    ((SR.Name = '.') or (SR.Name = '..')) then
    begin
      FindRes := FindNext(SR); // продолжить поиск
      Continue; // продолжить цикл
    end;
    if ((SR.Attr and faDirectory) = faDirectory) then begin
      ProfileList.Add(SR.Name);
      FindRes := FindNext(SR);
    end else FindRes := FindNext(SR);
  end;
  FindClose(SR);
end;

end.
