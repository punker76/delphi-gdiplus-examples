program GDITEST54;

uses
  Windows,
  Messages,
  SysUtils,
  GDIPAPI,
  GDIPOBJ;

Procedure OnPaint(DC: HDC);
var
  graphics : TGPGraphics;
  str: String;
  fontFamily: TGPFontFamily;
  font: TGPFont;
  rectF: TGPRectF;
  stringFormat: TGPStringFormat;
  solidBrush: TGPSolidBrush;
  pen: TGPPen;
begin
  graphics := TGPGraphics.Create(DC);
  str := 'Use StringFormat and RectF objects to center text in a rectangle.';

  fontFamily:= TGPFontFamily.Create('Arial');
  font:= TGPFont.Create(fontFamily, 12, FontStyleBold, UnitPoint);
  rectF:= MakeRect(30.0, 10.0, 120.0, 140.0);
  stringFormat:= TGPStringFormat.Create;
  solidBrush:= TGPSolidBrush.Create(MakeColor(255, 0, 0, 255));

  // Center-justify each line of text.
  stringFormat.SetAlignment(StringAlignmentCenter);

  // Center the block of text (top to bottom) in the rectangle.
  stringFormat.SetLineAlignment(StringAlignmentCenter);

  graphics.DrawString(str, -1, font, rectF, stringFormat, solidBrush);

  pen:= TGPPen.Create(MakeColor(255, 0, 0, 0));
  graphics.DrawRectangle(pen, rectF);

  fontFamily.Free;
  font.Free;
  stringFormat.Free;
  solidBrush.Free;
  pen.Free;
  graphics.Free;
end;


function WndProc(Wnd : HWND; message : UINT; wParam : Integer; lParam: Integer) : Integer; stdcall;
var
  Handle: HDC;
  ps: PAINTSTRUCT;
begin
  case message of
    WM_PAINT:
      begin
        Handle := BeginPaint(Wnd, ps);
        OnPaint(Handle);
        EndPaint(Wnd, ps);
        result := 0;
      end;

    WM_DESTROY:
      begin
        PostQuitMessage(0);
        result := 0;
      end;

   else
      result := DefWindowProc(Wnd, message, wParam, lParam);
   end;
end;

var
  hWnd     : THandle;
  Msg      : TMsg;
  wndClass : TWndClass;
begin
   wndClass.style          := CS_HREDRAW or CS_VREDRAW;
   wndClass.lpfnWndProc    := @WndProc;
   wndClass.cbClsExtra     := 0;
   wndClass.cbWndExtra     := 0;
   wndClass.hInstance      := hInstance;
   wndClass.hIcon          := LoadIcon(0, IDI_APPLICATION);
   wndClass.hCursor        := LoadCursor(0, IDC_ARROW);
   wndClass.hbrBackground  := HBRUSH(GetStockObject(WHITE_BRUSH));
   wndClass.lpszMenuName   := nil;
   wndClass.lpszClassName  := 'GettingStarted';

   RegisterClass(wndClass);

   hWnd := CreateWindow(
      'GettingStarted',       // window class name
      'Formatting Text',       // window caption
      WS_OVERLAPPEDWINDOW,    // window style
      Integer(CW_USEDEFAULT), // initial x position
      Integer(CW_USEDEFAULT), // initial y position
      Integer(CW_USEDEFAULT), // initial x size
      Integer(CW_USEDEFAULT), // initial y size
      0,                      // parent window handle
      0,                      // window menu handle
      hInstance,              // program instance handle
      nil);                   // creation parameters

   ShowWindow(hWnd, SW_SHOW);
   UpdateWindow(hWnd);

   while(GetMessage(msg, 0, 0, 0)) do
   begin
      TranslateMessage(msg);
      DispatchMessage(msg);
   end;
end.
