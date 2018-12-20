{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uForm1;

{$mode objfpc}{$H+}

interface

uses
  Forms;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
uses uMainForm;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    MainForm.form_place(self,1);
end;

end.

