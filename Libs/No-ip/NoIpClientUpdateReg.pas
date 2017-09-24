unit NoIpClientUpdateReg;

interface

uses NoIpClientUpdate, Classes;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('No-IP', [TNoIpClientUpdate]);
end;

end.
