program NoIP_ClientUpdateSample;

uses
  Forms,
  UMain in 'UMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'No-IP Client Update - By Manoel Campos';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
