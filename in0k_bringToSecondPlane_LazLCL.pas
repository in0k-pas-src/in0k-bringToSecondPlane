unit in0k_bringToSecondPlane_LazLCL;

//--- Схема работы функции на примере -------------------------[ in0k (c) 2016 ]
//
//     Z-Index
//
//     0    Wnd00              +-> Wnd_A                        Wnd_A
//     1    Wnd01              |   Wnd00                    +-> Wnd_B
//     2     ...               |   Wnd01                    |   Wnd00
//     3     ...               |    ...                     |   Wnd01
//    ...    ...               |    ...                     |
//     N    Wnd_A.bringToFront-^    ...                     |
//     M     ...                   bringToSecond(Wnd_B)-----^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//
// Наивно и кросПлатформенно, но недостатки ... моргает :-(
//----------------------------------------------------------------------------//

interface

uses
  in0k_SzOW,
  Forms;

procedure bringToSecondPlane(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

// переместить форму на "Второй План"
// @prm fTop форма, которая в настоящий момент находится на переднем плане
// @prm form перемещаемая форма
procedure in0k_bringToSecondPlane(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(SzOW_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form in the app');
      {$endIf}
    form.BringToFront;
    fTop.BringToFront;
end;

// Переместить форму на "Второй План"
procedure bringToSecondPlane(const form:TCustomForm);
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      {$endIf}
    if SzOW_SecondPlane_possible(form) then begin
        in0k_bringToSecondPlane(SzOW_get_topForm_inZOrder,form)
    end;
end;

end.

