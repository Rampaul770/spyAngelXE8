unit NoIpClientUpdateReg;

interface

uses NoIpClientUpdate, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MCampos No-IP', [TNoIpClientUpdate]);
end;

end.
