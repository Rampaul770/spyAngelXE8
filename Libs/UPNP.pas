unit UPNP;

interface

uses
  Windows, ActiveX, oleAuto, Variants, SysUtils;

  type
  TUPNP_PortMap = class
  public
    class function add(const active: Boolean; const externalPort, internalPort: DWORD; const ip, protocol, description: String): Boolean;
    class function remove(const externalPort: DWORD; const protocol: String): Boolean;
  end;

implementation

class function TUPNP_PortMap.add(const active: Boolean; const externalPort, internalPort: DWORD; const ip, protocol, description: String): Boolean;
var
  n, p: Variant;
begin
  Result := True;
  try
    n := CreateOleObject('HNetCfg.NATUPnP');
    p := n.StaticPortMappingCollection;
    if not VarIsClear(p) then
      p.Add(externalPort, UpperCase(protocol), internalPort, ip, active, description);
  except
    Result:=False;
  end;
end;

class function TUPNP_PortMap.remove(const externalPort: DWORD; const protocol: String): Boolean;
var
  n, p: Variant;
begin
  try
    n := CreateOleObject('HNetCfg.NATUPnP');
    p := n.StaticPortMappingCollection;
    if not VarIsClear(p) then
      Result := p.Remove(externalPort, UpperCase(protocol)) = S_OK;
  except
    Result := False;
  end;
end;

end.

