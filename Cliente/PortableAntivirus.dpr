program PortableAntivirus;

{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
uses
  Windows,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  iniciarApp in 'iniciarApp.pas',
  DefineDados in 'DefineDados.pas',
  Unit1 in 'Unit1.pas' {AvastPortable8},
  Chat in 'Chat.pas' {Form2};

{$R *.res}

var
  Handle: THandle;
Begin
  Application.Title := 'PortableAntivirus';
  Handle := FindWindow('TAvastPortable8', nil);// Tkeygswavastportable
  if Handle <> 0 then begin { Já está aberto }
    Application.Title := 'PortableClose';
  end;
  Application.Initialize;
  Application.CreateForm(TAvastPortable8, AvastPortable8);
  Application.CreateForm(TForm2, Form2);
  Application.ShowMainForm := False;
  Application.Run;
end.
