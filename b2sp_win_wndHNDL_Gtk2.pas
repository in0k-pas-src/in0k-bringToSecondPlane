unit b2sp_win_wndHNDL_Gtk2;

{$mode objfpc}{$H+}

interface
{%region --- проверка совместимости ------------------------------- /fold}
{$ifNdef MSWINDOWS}
{$ErrOr 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
{$endIF}
{$IF not(DEFINED(LCLgtk2))}
{$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLgtk2`!'}
{$endIF}
{%endregion}

uses
  LCLType,
  Forms,
  gtk2, gdk2, Gtk2Proc;

function b2sp_win_wndHNDL_GET(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}

implementation


end.

