{**Component that update Real IP
in a No-IP Dynamic DNS account.
For more information about No-IP, visit http://www.no-ip.com.

For more information about component, see source
code comments.

For more information about No-IP API
visit http://www.no-ip.com/integrate

The component requires Indy 10 library or higher, because,
internally, use an object of TIdHttp Class (unit IdHttp),
to send Http request to No-IP server for update IP
in a No-IP account.

~version 1.0
~autor Manoel Campos da Silva Filho
       Teacher of Escola Técnica Federal de Palmas, Tocantins, Brazil
       Active Delphi Magazine, Clube Delphi Magazine
email manoelcampos@gmail.com
sites http://manoelcampos.wordpress.com
      http://lab.etfto.gov.br}
unit NoIpClientUpdate;

interface

uses IdHTTP, SysUtils, Windows, Classes, Dialogs, TypInfo;

type
  {**Event fired when a Check IP procedure fail.

  ~param Sender Object that fired the event
  ~param E The Exception Object that contains error information}
  TOnGetIpError = procedure (Sender: TObject; E: Exception) of object;

  {**Event fired when a Check IP procedure is executed.

  ~param Sender Object that fired the event}
  TOnGetIp = procedure (Sender: TObject) of object;

  {Forward declaration}
  TCheckIpThread = class;

  {**Define No-IP server response types, after the client application  send IP update request.  } 
  TNoIpUpdateProtocolResponse = (
    nuprGood, {**DNS hostname update successful.
              Followed by a space and the IP address it was updated to.}
    nuprNoChg, {**IP address is current, no update performed.
                  Followed by a space and the IP address that
                  it is currently set to.}
    nuprNoHost, {**Hostname supplied does not exist under
                    specified account, client exit and require
                    user to enter new login credentials before
                    performing and additional request.}
    nuprBadAuth, {**Invalid username password combination}
    nuprBadAgent, {**Client disabled. Client should exit
                      and not perform any more updates
                      without user intervention. }
    nuprDonator, {**An update request was sent including a
                     feature that is not available to that
                     particular user such as offline options.}
    nuprAbuse, {**Username is blocked due to abuse.
                   Either for not following our update
                   specifications or disabled due to violation
                   of the No-IP terms of service.
                   Our terms of service can be viewed at
                   http://www.no-ip.com/legal/tos.
                   Client should stop sending updates.}
    nupr911, {**A fatal error on our side such as a database outage.
                 Retry the update no sooner 30 minutes.}
    nuprUnknownError {**Unknown Error}
  );

  {**Event fired when the client IP is changed

  ~param Sender Object that fired the event
  ~param OldIP Old IP, before change
  ~param NewIP New IP discovered}
  TOnIpChange = procedure (
    Sender: TObject; const OldIP, NewIP: ShortString) of object;

  {**Event fired when a IP update request is send
  to No-IP server. When this event is implemented
  in application, anyone exception that can occur is showed.

  ~param Sender Object that fired the event
  ~param IpUpdated IP that was sent to update

  ~param NoIpUpdateProtocolResponse of type ~see TNoIpUpdateProtocolResponse
  that identify the No-IP server response, with IP update status.}
  TAfterIpUpdate = procedure (
    Sender: TObject; const IpUpdated: ShortString;
    const NoIpUpdateProtocolResponse: TNoIpUpdateProtocolResponse) of object;

  {**Class that implements the comunication protocol with No-IP server to update
  IP in a dynamic DNS account.}
  TNoIpClientUpdate = class(TComponent)
  private
    FHttpAgentName: String;
    FPassword: ShortString;
    FHostName: String;
    FUserName: ShortString;
    FCurrentIP: ShortString;
    FCheckIpServerName: String;
    FActive: Boolean;
    FCheckIpInterval: Integer;
    FOnIpChange: TOnIpChange;
    FAutoUpdateIp: Boolean;
    FAfterIpUpdate: TAfterIpUpdate;
    FOnGetIpError: TOnGetIpError;
    FOnGetIP: TOnGetIP;
    FLastIpUpdateResponse: TNoIpUpdateProtocolResponse;

    procedure SetHostName(const Value: String);
    procedure SetPassword(const Value: ShortString);
    procedure SetUserName(const Value: ShortString);
    procedure SetCheckIpServerName(const Value: String);
    procedure SetActive(const Value: Boolean);
    procedure SetCheckIpInterval(const Value: Integer);
    procedure SetAutoUpdateIp(const Value: Boolean);
  protected
    {**Thread that will be used to check IP changes.}
    FCheckIpThread: TCheckIpThread;
  published
    {**Username registered in a No-IP account}
    property UserName: ShortString read FUserName write SetUserName;
    {**Password registered in No-IP account}
    property Password: ShortString read FPassword write SetPassword;
    {**DNS Host Name registered in a No-IP account}
    property HostName: String read FHostName write SetHostName;
    {**Real IP real actually assigned for client computer.}
    property CurrentIP: ShortString read FCurrentIP;

    {**DNS name or IP of a server that returns the real IP
    of client computer, for example, http://ip1.dynupdate.no-ip.com or
    c. The IP address will be extracted
    from HTML response.}
    property CheckIpHttpServerURL: String read FCheckIpServerName write SetCheckIpServerName;

    {**Miliseconds interval for IP change automatica verification
    occur. If the ~see Active property
    is True, the IP verification is executed automatically at interval
    defined.}
    property CheckIpInterval: Integer read FCheckIpInterval write SetCheckIpInterval;

    {**Indicate if automatic IP verification is active.}
    property Active: Boolean read FActive write SetActive;

    {**Event fired when IP is changed.}
    property OnIpChange: TOnIpChange read FOnIpChange write FOnIpChange;
    
    {**Event fired when a IP update request is sent to
    No-IP server}
    property AfterIpUpdate: TAfterIpUpdate read FAfterIpUpdate write FAfterIpUpdate;

    {**Indicate if the IP update request is sent automatically
    to No-IP server when component detect IP change.}
    property AutoUpdateIp: Boolean read FAutoUpdateIp write SetAutoUpdateIp;
	
  	{**HTTP Agent name assigned to component, to No-IP server know origin of IP update.
    The property value represents the name
	  of application that update IP on No-IP Server. This a read only property. }
  	property HttpAgentName: String Read FHttpAgentName;

    {**Event fired when a Check IP procedure fail.}
    property OnGetIpError: TOnGetIpError read FOnGetIpError write FOnGetIpError;

    {**Event fired when a Check IP procedure is executed.}
    property OnGetIP: TOnGetIp read FOnGetIP write FOnGetIP;
  public
    {**Indicate the last ip update response from No-IP Server.
    This property is read only and set when a Ip Update is send
    to No-IP Server, through the ~link SendIpUpdate method.}
    property LastIpUpdateResponse: TNoIpUpdateProtocolResponse read FLastIpUpdateResponse;

    {**Send a IP update request for a dynamic DNS account
    on No-IP server.

    ~returns Returns a value of enumerated type ~see TNoIpUpdateProtocolResponse
    that indicate the result of IP update request.}
    function SendIpUpdate: TNoIpUpdateProtocolResponse;

    {**Default class constructor. Create and initialize the component.

    ~param AOwner Owner of component. The owner free the owned component
    when it self is freed.}
    constructor Create(AOwner: TComponent); overload; override;

    {**Check the current real IP on a external server.

    ~returns The current real IP}
    function CheckIp: String;

    {**Default class destructor. Free resources when component is freed.}
    destructor Destroy; override;
  end;

  
  {**Thread for monitor IP change.}
  TCheckIpThread = class(TThread)
  private
    {**Object TNoIpClientUpdate used to fire events
    of component, for the background operations
    that this thread execute.}
    FNoIpClientUpdate: TNoIpClientUpdate;
  protected
    {**Start thread work.}
    procedure Execute;  override;
    {**Extract only the IP of a HTML response.

    ~param Response HTML response containing a IP number.
    This is a HTML content string returned by request
    of a check real IP service like http://ip1.dynupdate.no-ip.com.
    The ~see TNoIpClientUpdate component request a page
    like this to obtain real iP.

    ~returns The IP found in HTML response.}
    class function ExtractIpFromHttpResponse(Response: String): ShortString;
  public
    {**Default class constructor. Create a initiate the thread.
    The thread is created suspended, it don't execute this
    work on creation, only when Active property of ~see TNoIpClientUpdate component
    is set to True.

    ~param NoIpClientUpdate A ~see TNoIpClientUpdate object that
    thread will use internally to check IP change from
    a webserver and send IP update request to No-IP server.}
    constructor Create(NoIpClientUpdate: TNoIpClientUpdate);

    {**Check the current real IP on the URL configured in
    FNoIpClientUpdate private object

    ~param aIdHttp The IdHttp component used to get the current real ip.
    If this param is nil, a TIdHttp component will be created and destroyed}
    function CheckIp(aIdHttp: TIdHttp = nil): ShortString;
  end;

{$IFDEF MSWINDOWS}
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

implementation

{ TNoIpClientUpdate }

function TNoIpClientUpdate.CheckIp: String;
begin
  result:= FCheckIpThread.CheckIp();
end;

constructor TNoIpClientUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //CheckIpHttpServerURL := 'http://ip1.dynupdate.no-ip.com';
  //or CheckIpHttpServerURL := 'http://ip2.dynupdate.no-ip.com';
  CheckIpInterval:= 1000;
  FCurrentIP := '127.0.0.1';
  //FLastIpUpdateResponse:= nuprBadAuth;
  FHttpAgentName := 'MCampos NoIP Client Update/1.0 manoelcampos@gmail.com';
end;

destructor TNoIpClientUpdate.Destroy;
begin
  if (FCheckIpThread <> nil) and (not FCheckIpThread.Terminated) then
     FCheckIpThread.Terminate;
  //FreeAndNil(FCheckIpThread);
  inherited;
end;

function TNoIpClientUpdate.SendIpUpdate: TNoIpUpdateProtocolResponse;
var
  idHttp1: TIdHttp;
  response, url: string;
  i: Integer;
  intNoIpUpdateProtocolResponse: Integer;
begin
  {http://username:password@dynupdate.no-ip.com/nic/update?
  hostname=mytest.testdomain.com&myip=1.2.3.4}
  Result := nuprUnknownError;
  idHttp1:= TIdHttp.Create(nil);
  try
      url:= Format(
        'http://dynupdate.no-ip.com/nic/update?hostname=%s&myip=%s',
        [FHostName, FCurrentIp]);

      idHttp1.HandleRedirects:= true;
      idHttp1.Request.BasicAuthentication := true;
      idHttp1.Request.Username := FUserName;
      idHttp1.Request.Password := FPassword;

      idHttp1.Request.UserAgent := FHttpAgentName;
      try
        try
          response:= trim(AnsiLowerCase(idHttp1.Get(url)));
          i:= pos(' ', response);
          if i > 0 then
             delete(response, i, length(response));

          intNoIpUpdateProtocolResponse:= GetEnumValue(
            TypeInfo(TNoIpUpdateProtocolResponse), 'nupr'+response);
          if intNoIpUpdateProtocolResponse <> -1 then
          begin
             FLastIpUpdateResponse:= TNoIpUpdateProtocolResponse(intNoIpUpdateProtocolResponse);
             result:= FLastIpUpdateResponse;
          end;
        except
          if not Assigned(AfterIpUpdate) then
             raise;
        end;
      finally
        if Assigned(AfterIpUpdate) then
           AfterIpUpdate(Self, FCurrentIp, Result)
      end;
  finally
    FreeAndNil(idHttp1);
  end;
end;

procedure TNoIpClientUpdate.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if not(csDesigning in ComponentState) then
  begin
    if Value and (FCheckIpThread = nil) then
       FCheckIpThread:= TCheckIpThread.Create(Self);

    if (FCheckIpThread <> nil) and (not FCheckIpThread.Terminated) then
    begin
      if Value then
         FCheckIpThread.Resume
      else FCheckIpThread.Suspend;
    end;
  end;
end;

procedure TNoIpClientUpdate.SetAutoUpdateIp(const Value: Boolean);
begin
  FAutoUpdateIp := Value;
end;

procedure TNoIpClientUpdate.SetCheckIpInterval(const Value: Integer);
begin
  FCheckIpInterval := Value;
end;

procedure TNoIpClientUpdate.SetCheckIpServerName(const Value: String);
begin
  FCheckIpServerName := Value;
  if pos('http://', AnsiLowerCase(value)) = 0 then
     FCheckIpServerName:= 'http://' + value;
end;

procedure TNoIpClientUpdate.SetHostName(const Value: String);
begin
  FHostName := Value;
end;

procedure TNoIpClientUpdate.SetPassword(const Value: ShortString);
begin
  FPassword := Value;
end;

procedure TNoIpClientUpdate.SetUserName(const Value: ShortString);
begin
  FUserName := Value;
end;

{ TCheckIpThread }

function TCheckIpThread.CheckIp(aIdHttp: TIdHttp): ShortString;
var
  DestroyIdHttp: Boolean;
begin
  result:= '';
  if aIdHttp = nil then
  begin
    DestroyIdHttp := true;
    aIdHttp:= TIdHTTP.Create(nil);
  end
  else DestroyIdHttp := false;

  try
    aIdHttp.HandleRedirects := true;
    try
      result:= aIdHttp.Get(FNoIpClientUpdate.CheckIpHttpServerURL);
      result := ExtractIpFromHttpResponse(result);
      if Assigned(FNoIpClientUpdate.OnGetIp) then
         FNoIpClientUpdate.OnGetIp(FNoIpClientUpdate);
    except
      on E: Exception do
      begin
        if Assigned(FNoIpClientUpdate.OnGetIpError) then
           FNoIpClientUpdate.OnGetIpError(FNoIpClientUpdate, E);
        exit;
      end;
    end;
  finally
    if DestroyIdHttp then
       FreeAndNil(aIdHttp);
  end;

end;

constructor TCheckIpThread.Create(NoIpClientUpdate: TNoIpClientUpdate);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FNoIpClientUpdate:= NoIpClientUpdate;
end;

procedure TCheckIpThread.Execute;
var
  MilisecondsWaited: Integer;
  idHttp1: TIdHTTP;
  NewIP, OldIP: string;
begin
  MilisecondsWaited:= FNoIpClientUpdate.CheckIpInterval;
  idHttp1:= TIdHTTP.Create(nil);
  try
    idHttp1.HandleRedirects := true;
    while not Terminated do
    begin
       if MilisecondsWaited >= FNoIpClientUpdate.CheckIpInterval then
       begin
         MilisecondsWaited:= 0;
         NewIP:= CheckIp(idHttp1);
         if NewIP <> '' then
         begin
           {If the IP change or the last update response
           was a error, then, send ip update to No-IP Server.}
           if (FNoIpClientUpdate.FCurrentIP <> NewIP)
           or (FNoIpClientUpdate.LastIpUpdateResponse >= nuprNoHost) then
           begin
              OldIP:= FNoIpClientUpdate.FCurrentIP;
              FNoIpClientUpdate.FCurrentIP:= NewIP;
              if FNoIpClientUpdate.AutoUpdateIp then
                 FNoIpClientUpdate.SendIpUpdate;

              if Assigned(FNoIpClientUpdate.OnIpChange) then
                 FNoIpClientUpdate.OnIpChange(
                    FNoIpClientUpdate, OldIP, NewIP);
           end;
         end;
       end;
       Sleep(1);
       inc(MilisecondsWaited);
    end;
  finally
    FreeAndNil(idHttp1);
  end;
end;

class function TCheckIpThread.ExtractIpFromHttpResponse(
  Response: String): ShortString;
var
  iStart, iEnd, ipLenght: Integer;
begin
  result:= '';

  {Search the IP begin on HTML response}
  for iStart := 1 to length(Response) do
  begin
     if response[iStart] in ['0'..'9'] then
        break;
  end;

  {Search the IP end on HTML response}
  ipLenght:= 0;
  for iEnd := iStart to length(Response) do
  begin
     if not(response[iEnd] in ['0'..'9','.']) then
        break;
     inc(ipLenght);
  end;

  result:= copy(response, iStart, ipLenght);
end;


end.
