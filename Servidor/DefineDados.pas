unit DefineDados;
interface

uses
Windows;

type
  TConfig = record
  Temp: String[10];
end;
PConfig = ^TConfig;

function WriteSettings(Filename: PChar; Conf: PConfig): Boolean;

implementation

function WriteSettings(Filename: PChar; Conf: PConfig): Boolean;
var
  Res: THandle;
begin
  Result := False;
  Res := BeginUpdateResource(Filename, False);
  if Res <> 0 then begin
    if UpdateResource(Res, RT_RCDATA, 'CFG', 0, Conf, SizeOf(Conf^)) then
      Result := True;
    EndUpdateResource(Res, False);
  end;
end;

end.
