{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uForm3;

{$mode objfpc}{$H+}

interface

uses
  Forms;

type

  { TForm3 }

  TForm3 = class(TForm)
    procedure FormCreate(Sender: TObject);
  end;

var
  Form3: TForm3;

implementation
uses uMainForm;

{$R *.lfm}

{ TForm3 }

procedure TForm3.FormCreate(Sender: TObject);
begin
    MainForm.form_place(self,3);
end;

end.

