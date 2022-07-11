unit Starter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CoolTools, CoolCtrls, StdCtrls, FileCtrl, RzFilSys, ExtCtrls, Mask,
  ToolEdit, RzLaunch, RzDlgBtn, Menus,Registry;

type
  TFormCD = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    CoolGroupBox1: TCoolGroupBox;
    CoolLabel1: TCoolLabel;
    RzLauncher1: TRzLauncher;
    FilenameEdit1: TFilenameEdit;
    CoolLabel2: TCoolLabel;
    RzDriveComboBox1: TRzDriveComboBox;
    CoolCheckRadioBox1: TCoolCheckRadioBox;
    Bevel1: TBevel;
    RzDialogButtons1: TRzDialogButtons;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    CoolDisksInformant1: TCoolDisksInformant;
    Timer2: TTimer;
    Edit1: TEdit;
    CoolLabel3: TCoolLabel;
    procedure FormCreate(Sender: TObject);
    procedure RzDialogButtons1ClickOk(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCD : TFormCD;
  LoadAtStartup : boolean;
  Size1,Size2 : int64;
  StartProg : String;
  Drive : String[1];
  Param : String;
  Reg:TRegistry;

implementation

{$R *.DFM}

procedure TFormCD.FormCreate(Sender: TObject);
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',false);
    if Reg.ReadString('CDStarter')<>''
      then LoadAtStartup:=true
      else LoadAtStartup:=false;
    if LoadAtStartup
      then CoolCheckRadioBox1.Checked:=True
      else CoolCheckRadioBox1.Checked:=False;
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.OpenKey('Software\CDStarter\',false);
    StartProg:=Reg.ReadString('StartProg');
    Drive:=Reg.ReadString('Drive');
    Param:=Reg.ReadString('Param');
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  FormCD.Height:=183;
  FormCD.Width:=287;
end;

procedure TFormCD.RzDialogButtons1ClickOk(Sender: TObject);
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run\',false);
    if CoolCheckRadioBox1.Checked
      then Reg.WriteString('CDStarter',Application.EXEName)
      else Reg.DeleteValue('CDStarter');
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.OpenKey('Software\CDStarter\',true);
    if FileNameEdit1.Text<>'' then Reg.WriteString('StartProg',FileNameEdit1.Text);
    if RzDriveComboBox1.Drive<>'' then Reg.WriteString('Drive',RzDriveComboBox1.Drive);
    if Edit1.Text<>'' then Reg.WriteString('Param',Edit1.Text);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  Hide;
end;

procedure TFormCD.N3Click(Sender: TObject);
begin
  CoolTrayIcon1.Active:=False;
  Show;
end;

procedure TFormCD.N1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormCD.FormActivate(Sender: TObject);
var st1:string[1];
    i:byte;
    YesDrive:boolean;
begin
  YesDrive:=False;
  if RzDriveComboBox1.Items.Count<>0
    then
      begin
        For i:=0 to RzDriveComboBox1.Items.Count do
          begin
            st1:=copy(RzDriveComboBox1.Items[i],1,1);
            if st1=Drive
              then
                begin
                  RzDriveComboBox1.ItemIndex:=i;
                  RzDriveComboBox1.Drive:=st1[1];
                  YesDrive:=True;
                end;
          end;
        if not YesDrive
          then
            begin
              RzDriveComboBox1.ItemIndex:=0;
              st1:=copy(RzDriveComboBox1.Items[0],1,1);
              RzDriveComboBox1.Drive:=st1[1];
            end;
      end
    else Close;
  if LoadAtStartup
    then CoolCheckRadioBox1.Checked:=True
    else CoolCheckRadioBox1.Checked:=False;
  if StartProg<>''
    then FileNameEdit1.Text:=StartProg;
  if Param<>''
    then Edit1.Text:=Param;
end;

procedure TFormCD.Timer1Timer(Sender: TObject);
begin
  CoolDisksInformant1.Drive:=RzDriveComboBox1.Drive+':\';
  Size2:=CoolDisksInformant1.TotalBytes;
  if (Size2<>Size1)and(Size2<>0)
    then
      begin
        RzLauncher1.FileName:=FilenameEdit1.Text;
        RzLauncher1.Parameters:=Param;
        RzLauncher1.Launch;
      end;
  Size1:=Size2;
end;

procedure TFormCD.FormHide(Sender: TObject);
begin
  CoolTrayIcon1.Active:=True;
end;

procedure TFormCD.Timer2Timer(Sender: TObject);
begin
  Hide;
  Timer2.Enabled:=False;
end;

procedure TFormCD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CoolTrayIcon1.Active:=False;
end;

end.
