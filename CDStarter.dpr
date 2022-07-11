program CDStarter;

uses
  Forms,
  Windows,
  Registry,
  Starter in 'Starter.pas' {FormCD};

{$R *.RES}

var
 ExtendedStyle : integer;
 Reg:TRegistry;

begin
  Application.Initialize;
  ExtendedStyle:=GetWindowLong(Application.Handle, GWL_EXSTYLE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    ExtendedStyle or WS_EX_TOOLWINDOW AND NOT WS_EX_APPWINDOW);
  Application.CreateForm(TFormCD, FormCD);
  Application.Run;
end.
