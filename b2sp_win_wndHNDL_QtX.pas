unit b2sp_win_wndHNDL_QtX;

{$mode objfpc}{$H+}

interface
{%region --- проверка совместимости ------------------------------- /fold}
{$ifNdef MSWINDOWS}
{$ErrOr 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
{$endIF}
{$IF not(DEFINED(LCLqt) or DEFINED(LCLqt5))}
{$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLqt` or `LCLqt5`!'}
{$endIF}
{%endregion}

uses
  Forms,
  Windows,
  //-------
  {$if defined(LCLqt)}
  qt4,
  {$elseIf defined(LCLqt5)}
  qt5,
  {$else}
  {$error 'main `WidgetSet` unit NOT define'}
  {$endIf}
  //-------
  qtwidgets;

function b2sp_win_wndHNDL_GET(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}

implementation

function b2sp_win_wndHNDL_GET(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+} //БОЛЬШЕ проверок БОГУ проверок
      Assert(Assigned(form)                         ,'`form`: must be defined'             );
      Assert(form.HandleAllocated                   ,'`form.Handle`: must be defined'      );
      Assert(Assigned(TQtWidget(form.Handle))       ,'`TQtWidget(form.Handle)`: NIL'       );
      Assert(Assigned(TQtWidget(form.Handle).Widget),'`TQtWidget(form.Handle).Widget`: NIL');
      {$endIf}
    result:=QWidget_winID(TQtWidget(form.Handle).Widget);
      {$ifOPT D+} //БОЛЬШЕ проверок БОГУ проверок
      Assert(result<>null                         ,'`form`: must be defined'             );
      {$endIf}
      {$IF DEFINED(LCLqt))}
      {$warning 'NOT tested in `LCLqt`!'}
      {$endIF}
end;

end.

