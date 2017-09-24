unit UMain;

interface

uses
  TypInfo, ShellApi, 
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms,
  Dialogs, StdCtrls, NoIpClientUpdate, ExtCtrls, Buttons, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TFrmMain = class(TForm)
    lbIP: TLabel;
    lbStatus: TLabel;
    lbEdtEmail: TLabeledEdit;
    lbEdtPassword: TLabeledEdit;
    lbEdtHostName: TLabeledEdit;
    btnUpdate: TBitBtn;
    lbEmail: TLabel;
    IdAntiFreeze1: TIdAntiFreeze;
    NoIpClientUpdate1: TNoIpClientUpdate;
    lbSendUpdate: TLabel;
    cbxAutoUpdate: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure lbEmailClick(Sender: TObject);
    procedure NoIpClientUpdate1IpChange(Sender: TObject; const OldIP,
      NewIP: ShortString);
    procedure NoIpClientUpdate1AfterIpUpdate(Sender: TObject;
      const IpUpdated: ShortString;
      const NoIpUpdateProtocolResponse: TNoIpUpdateProtocolResponse);
    procedure cbxAutoUpdateClick(Sender: TObject);
  private
    UpdatesSended: Integer;
    procedure UpdateIP;
    procedure SetNoIpParams;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.UpdateIP;
var
  response: TNoIpUpdateProtocolResponse;
  responseStr: String;
begin
  Screen.Cursor := crHourGlass;
  try
    SetNoIpParams;
    try
      response :=
        NoIpClientUpdate1.SendIpUpdate;
      case response of
        nuprGood: responseStr:= 'Ip Updated';
        nuprNoChg: responseStr:= 'No Change Required';
        nuprNoHost: responseStr:= 'Host doesn`t exists for especified account';
        nuprBadAuth: responseStr:= 'Bad Authentication';
        nuprBadAgent: responseStr:= 'Bad Agent - The Client is disabled';
        nuprDonator: responseStr:= 'Feature not available';
        nuprAbuse: responseStr:= 'Username is blocked due to abuse';
        nupr911: responseStr:= 'Server fatal error. Try again in few minutes';
        nuprUnknownError: responseStr:= 'Unknown Error';
      end;
    except
      on e: Exception do
        responseStr:= e.Message;
    end;
    lbStatus.Caption := 'Status: '+responseStr;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmMain.SetNoIpParams;
begin
  NoIpClientUpdate1.UserName := lbEdtEmail.Text;
  NoIpClientUpdate1.Password := lbEdtPassword.Text;
  NoIpClientUpdate1.HostName := lbEdtHostName.Text;
end;

procedure TFrmMain.btnUpdateClick(Sender: TObject);
begin
  btnUpdate.Enabled:= false;
  try
    UpdateIP;
  finally
    btnUpdate.Enabled:= true;
  end;
end;

procedure TFrmMain.cbxAutoUpdateClick(Sender: TObject);
begin
  NoIpClientUpdate1.AutoUpdateIp := cbxAutoUpdate.Checked;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  lbStatus.Caption:= '';
  lbIP.Caption := '';
  lbSendUpdate.Caption := '';
  UpdatesSended:= 0;
end;

procedure TFrmMain.lbEmailClick(Sender: TObject);
begin
   ShellExecute(
     handle, 'open',
     'mailto:manoelcampos@gmail.com?subject=No-IP Update Client',
     nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmMain.NoIpClientUpdate1AfterIpUpdate(Sender: TObject;
  const IpUpdated: ShortString;
  const NoIpUpdateProtocolResponse: TNoIpUpdateProtocolResponse);
begin
  inc(UpdatesSended);
  lbSendUpdate.Caption:=
   Format('%d Update(s) Request Send', [UpdatesSended]);
end;

procedure TFrmMain.NoIpClientUpdate1IpChange(Sender: TObject;
  const OldIP, NewIP: ShortString);
begin
  {You can use NewIP param ou NoIpClientUpdate1.CurrentIP
  to get the actual IP.}
  lbIP.caption:=
   'Old Real IP: '+ OldIP +
   #13'New Real IP: ' + NewIP;
  UpdateIP;
end;

end.
