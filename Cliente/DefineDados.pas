unit DefineDados;
interface

uses
Windows;

type
  TConfig = record
  Temp: String[10];
end;
PConfig = ^TConfig;

function ReadSettings(var Conf: PConfig): Boolean;

implementation

function ReadSettings(var Conf: PConfig): Boolean;
var
  Info: HRSRC;
  Res: HGLOBAL;
begin
  Result := False;
  Info := FindResource(HInstance, 'CFG', RT_RCDATA);
  if Info <> 0 then begin
    Res := LoadResource(hInstance, Info);
    if Res <> 0 then begin
      Conf := LockResource(Res);
      Result := True;
    end;
  end;
end;
end.
