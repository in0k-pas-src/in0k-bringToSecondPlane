unit in0k_bringToSecondPlane;

//--- Схема работы функции на примере ------------------------ [ in0k (c) 2018 ]
//
//     Z-Index
//
//     0    Wnd00              +-> Wnd_A                        Wnd_A
//     1    Wnd01              |   Wnd00                    +-> Wnd_B
//     2     ...               |   Wnd01                    |   Wnd00
//     3     ...               |    ...                     |   Wnd01
//    ...    ...               |    ...                     |
//     N    Wnd_A.bringToFront-^    ...                     |
//     M     ...                   Wnd_B.bringToSecond------^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//

{$mode objfpc}{$H+}

interface

uses
  {%region --- Выбираем РЕАЛИзацИЮ --- /fold}
  {$IF DEFINED(LCLWin32) or DEFINED(LCLWin64)}
    in0k_bringToSecondPlane_WinAPI,
  {$elseIf DEFINED(LCLgtk2)}
    in0k_bringToSecondPlane_lclGtk2,
  {$elseIf DEFINED(LCLgtk3)}
    in0k_bringToSecondPlane_lclGtk3,
  {$else}
    in0k_bringToSecondPlane_LazLCL,
  {$endIF}
  {%endRegion}
  Forms;

procedure bringToSecond(const form:TCustomForm);

implementation

procedure bringToSecond(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    bringToSecondPlane(form);
end;

end.

