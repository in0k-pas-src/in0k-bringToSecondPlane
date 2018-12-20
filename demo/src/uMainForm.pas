{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  in0k_bringToSecondPlane_LazLCL,
  in0k_bringToSecondPlane,
  //----
  uForm1, uForm2,
  //----
  LCLType, LCLIntf,
  SysUtils, Forms, StdCtrls, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Shape1: TShape;
    Shape2: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure form_place(const form:TCustomForm; const indx:integer);
    procedure info_Write;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
    in0k_bringToSecondPlane_LazLCL.bringToSecondPlane(Form1);
    info_Write;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
    bringToSecond(Form2);
    info_Write;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
    info_Write;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
    info_Write;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    form_place(self,0);
end;

//------------------------------------------------------------------------------

procedure TMainForm.info_Write;
var i:integer;
    f:TCustomForm;
begin
    memo1.Lines.BeginUpdate;
    memo1.Lines.Clear;
    //---
    for i:=0 to Screen.CustomFormZOrderCount-1 do begin
        f:=Screen.CustomFormsZOrdered[i];
        //---
        memo1.Lines.Add('z='+inttostr(i)+' ['+inttostr(Screen.CustomFormIndex(f))+'] '+f.Name);
    end;
    //---
    memo1.Lines.EndUpdate;
end;

//------------------------------------------------------------------------------

procedure TMainForm.form_place(const form:TCustomForm; const indx:integer);
var delta:integer;
begin
    if form<>self then begin
        form.Width :=self.Width;
        form.Height:=self.Height;
    end;
    delta:=GetSystemMetrics(SM_CYCAPTION)*indx;
    form.Left  :=Screen.PrimaryMonitor.Left+((Screen.PrimaryMonitor.Width -self.Width)  div 2)+delta;
    form.Top   :=Screen.PrimaryMonitor.Top +((Screen.PrimaryMonitor.Height-self.Height) div 2)-delta;
end;

end.

