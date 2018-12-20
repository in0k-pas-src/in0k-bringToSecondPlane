unit uForm2;

{$mode objfpc}{$H+}

interface

{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}uses
  Forms;

type

  { TForm2 }

  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
  end;

var
  Form2: TForm2;

implementation
uses uMainForm;

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
    MainForm.form_place(self,2);
end;

end.

