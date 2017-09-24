unit login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdZLibCompressorBase, IdCompressorZLib,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, ShellApi,
  Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.Wininet, Vcl.Mask, Vcl.ComCtrls,
  Vcl.Samples.Spin, Vcl.Imaging.jpeg, Vcl.Buttons, Registry;

type
  TForm0 = class(TForm)
    http: TIdHTTP;
    compress: TIdCompressorZLib;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    senha: TMaskEdit;
    StatusBar1: TStatusBar;
    Button2: TButton;
    Label2: TLabel;
    porta: TSpinEdit;
    Image1: TImage;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure senhaClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure senhaKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure portaChange(Sender: TObject);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form0: TForm0;
  flags: DWORD;
  portUpdated:boolean;
  ParamList: TStringList;

implementation

{$R *.dfm}
{$SETPEFlAGS IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or
 IMAGE_FILE_LOCAL_SYMS_STRIPPED OR IMAGE_FILE_RELOCS_STRIPPED}

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

uses Principal;

function SysTempDir: string;
begin
  SetLength(Result, MAX_PATH);
  if GetTempPath(MAX_PATH, PChar(Result)) > 0 then
  Result := string(PChar(Result))
  else
  Result := '';
end;

procedure TForm0.Button2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm0.Edit1Click(Sender: TObject);
begin
  if(Edit1.Text='Email')then
    Edit1.Text:='';
end;

procedure TForm0.Edit1Exit(Sender: TObject);
begin
  if(Edit1.Text='')then
    Edit1.Text:='Email';
end;

procedure TForm0.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then begin
    Key := #0;
    ActiveControl:=senha;
  end;
end;

procedure TForm0.FormCreate(Sender: TObject);
begin
  ParamList := TStringList.Create;
end;

procedure TForm0.FormShow(Sender: TObject);
var regi:TRegistry;
begin
  asm nop end;
  regi := TRegistry.Create;
  regi.rootKey := HKEY_CURRENT_USER;
  portUpdated:=False;
  if(regi.OpenKeyReadOnly('Software\Conamy\AngelServer'))then begin
    Edit1.Text:=regi.ReadString('mail');
    senha.Text:='';
    porta.Value:=regi.ReadInteger('port');
  end else
    regi.OpenKey('Software\Conamy\AngelServer', True);
  regi.CloseKey;
  ActiveControl:=Edit1;
end;

procedure TForm0.Label2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://spyangel.tk', '', '', 1);
end;

procedure TForm0.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
   sc_DragMove = $f012;
begin
  ReleaseCapture;
  Perform(wm_SysCommand, sc_DragMove, 0);
end;

procedure TForm0.portaChange(Sender: TObject);
begin
portUpdated:=True;
end;

procedure TForm0.senhaClick(Sender: TObject);
begin
if(senha.Text='Senha')then
  senha.Text:='';
end;
procedure TForm0.senhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then begin
    Key := #0;
    SpeedButton1.Click;
  end;
end;

procedure TForm0.SpeedButton1Click(Sender: TObject);
var result:String;
    regi:TRegistry;
begin
  asm nop end;
  regi := TRegistry.Create;
  regi.rootKey := HKEY_CURRENT_USER;
  regi.OpenKey('Software\Conamy\AngelServer', True);
  regi.WriteString('mail', Edit1.Text);
  regi.WriteInteger('port', porta.Value);
  regi.CloseKey;
  if((edit1.Text='')or(edit1.Text='Email'))then begin
     ActiveControl:=edit1;
     Exit;
  end;
  if((senha.Text='')or(senha.Text='Senha'))then Begin
    ActiveControl:=senha;
    exit;
  End;
  SpeedButton1.Enabled:=false;
  StatusBar1.Panels.Items[1].Text := 'Conectando, aguarde...';
  ParamList.Add('9e382f340c3b999c46f1afcd3beb88ec=df32c678db49dc6543a51891049b71c3');//keycode
  ParamList.Add('db49dc6543a5=' + Edit1.Text);//username
  ParamList.Add('4f4e174866fd0ce=' + senha.Text);//password
  if(portUpdated=True)then begin
    ParamList.Add('porta=' + porta.Text);
    portUpdated:=False;
  end else
    ParamList.Add('porta=NULO');
  if InternetGetConnectedState(@flags, 0) then begin
    try
      result:=http.Post('http://conamy.hol.es/loadconfig.php',ParamList);
    except
      http.Disconnect;
      StatusBar1.Panels.Items[1].Text := 'Erro na conexão!';
      SpeedButton1.Enabled:=true;
      Exit;
    end;
    http.Disconnect;
    if(Pos('<|loggedIn|>', result)>0)then begin
      form1.porta:=StrtoInt(porta.Text);
      Delete(result, 1, Pos('<|loggedIn|>', result) + 11);
      result := Copy(result, 1, Pos('<<|', result) - 1);
      form1.IdUser:=result;
      form1.Show;
      form0.Close;
    end else
      StatusBar1.Panels.Items[1].Text := 'Email/Senha Incorretos!';
  end else
    StatusBar1.Panels.Items[1].Text := 'Você não está conectado a Internet!';
  SpeedButton1.Enabled:=true;
  ParamList.Clear;
  senha.Clear;
end;

end.
