unit bringToSecond;

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
//     M     ...                   bringToSecond(Wnd_B)-----^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//
{%region ---               Выбираем РЕАЛИзацИЮ                 --- /fold }
{$unDef b2sp_implementation_selected}
//--- #0. по ЦЕЛЕВОЙ платформе
{{$If DEFINED(MSWINDOWS)}
  {$IF DEFINED(LCLWin32) or DEFINED(LCLWin64)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$elseIf DEFINED(LCLqt) or DEFINED(LCLqt5)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$elseIf DEFINED(LCLgtk2)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$endIF}
{$endIF}}
//--- #1. по ЦЕЛЕВЫМ виджитам
{$ifNdef b2sp_implementation_selected} // видимо нативно через ВИДЖИТЫ
  {$if DEFINED(LCLqt) or DEFINED(LCLqt5)}
    {$define b2sp_implementation_QtX}{$define b2sp_implementation_SET}
  {$elseIf DEFINED(LCLgtk2) or DEFINED(LCLgtk3)}
    {$define b2sp_implementation_GtkX}{$define b2sp_implementation_SET}
  {$endIF}
{$endIF}



{%endRegion -------------------------------------------------------------}
//----------------------------------------------------------------------------//

{$mode objfpc}{$H+}

interface

uses
  Forms,
  {$if     defined(b2sp_implementation_WIN) } bringToSecond_WIN
  {$elseif defined(b2sp_implementation_QtX) } bringToSecond_QtX
  {$elseif defined(b2sp_implementation_GtkX)} bringToSecond_GtkX
  {$else}{шансов НЕТ .. вариант по умолчанию} bringToSecond_LCL
    {$note --------------------------------------------------------------------}
    {$note  in0k-bringToSecondPlane: The basic cross-platform version is used. }
    {$note  Can work slowly and with flicker.                                  }
    {$note --------------------------------------------------------------------}
  {$endIF};

procedure bringToSecondppp(const form:TCustomForm);

implementation

procedure bringToSecondppp(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
  {$if defined(b2sp_implementation_WIN)}
    bringToSecond_WIN.bringToSecond(form);
  {$elseif defined(b2sp_implementation_QtX)}
    bringToSecond_QtX.bringToSecond(form);
  {$elseif defined(b2sp_implementation_GtkX)}
    bringToSecond_GtkX.bringToSecond(form);
  {$else}
    bringToSecond_LCL.bringToSecond(form);
  {$endIF}
end;

end.

