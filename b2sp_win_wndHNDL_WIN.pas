unit b2sp_win_wndHNDL_WIN;

{$mode objfpc}{$H+}

interface
{%region --- проверка совместимости ------------------------------- /fold}
{$ifNdef MSWINDOWS}
{$ErrOr 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
{$endIF}
{$IF not(DEFINED(LCLWin32) or DEFINED(LCLWin64))}
{$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLWin32` or `LCLWin64`!'}
{$endIF}
{%endregion}

uses
  Forms,
  Windows;

function b2sp_win_wndHNDL_GET(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}

implementation


end.

