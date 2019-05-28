unit bringToSecond_WIN;

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
//  "НАТИвНаЯ" реализация, c использованием WinAPI. БЫСТРО и НЕ моргает !
//----------------------------------------------------------------------------//
    {$ifNdef MSWINDOWS} // проверка совместимости
    {$ErrOr 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
    {$endIF}
{% in0k(c)Tested 20190528 i386-win32-win32/win64 Lazarus:2.0.0.4 FPC:3.0.4    %}
//----------------------------------------------------------------------------//

interface

uses
  b2sp_SzOW,
  b2sp_SzOF,
  Forms, Windows;

procedure bringToSecond(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

{%region --- #0. _wndHNDL_GET_(form):Windows.HWND ---------------- /fold }
//
// получить Handle окна в НАТИВНЫХ понятиях WinAPI

{$IF DEFINED(LCLWin32) or DEFINED(LCLWin64)} //----------------------------- WIN
{done -oin0k -cTEST : WIN 20190403 Lazarus 2.0.0 r60307 FPC 3.0.4 i386-win32-win32/win64}

function _wndHNDL_GET_(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(form.HandleAllocated,'`form.Handle`: not Allocated');
      {$endIf}
    result:=form.Handle;
end;

{$elseIF DEFINED(LCLqt) or DEFINED(LCLqt5)} //------------------------------ QtX
{TODO -cTEST : Qt4 }
{done -oin0k -cTEST : Qt5 20190403 Lazarus 2.0.0 r60307 FPC 3.0.4 i386-win32-win32/win64}

  uses
  {$if defined(LCLqt)}      qt4,
  {$elseIf defined(LCLqt5)} qt5,
  {$else} {$error 'main `WidgetSet` unit NOT define'} {$endIf}
  qtwidgets;

function _wndHNDL_GET_(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(form.HandleAllocated,'`form.Handle`: not Allocated');
      Assert(Assigned(TQtWidget(form.Handle).Widget),'`TQtWidget(form.Handle).Widget`: NIL');
      {$endIf}
    result:=QWidget_winID(TQtWidget(form.Handle).Widget);
    {$ifOPT D+} Assert(result<>0,'`win HWND`: NOT found'); {$endIf}
    //---
    {$IF DEFINED(LCLqt)}{$warning 'NOT tested in `LCLqt`!'}{$endIF}
end;

{$elseIF DEFINED(LCLgtk2)} //---------------------------------------------- Gtk2
{done -oin0k -cTEST : Gtk2 20190403 Lazarus 2.0.0 r60307 FPC 3.0.4 i386-win32-win32/win64}
uses gtk2, gdk2, Gtk2Proc;

// она есть, просто не описана ...
function gdk_win32_drawable_get_handle(D:PGdkDrawable):HWND; cdecl; external gdklib;

function _wndHNDL_GET_(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(form.HandleAllocated,'`form.Handle`: not Allocated');
      {$endIf}
    result:=gdk_win32_drawable_get_handle(GetControlWindow({%H-}PGtkWidget(form.Handle)));
    {$ifOPT D+} Assert(result<>0,'`win HWND`: NOT found'); {$endIf}
end;

//------------------------------------------------------------------------------
{$else} // Это ЗАЛЕТ, где-то я просчитался :-(
        // Сообщим об ошибке, поклянчим фидБек
    {$error Target platform not supported!             }
    {$note  Function `_wndHNDL_GET_` NOT define.       }
    {$note  Please, report this error to the developer.}
{$endIF}

{%endregion -------------------------------------------------------------}

{%region --- #1. ОСНОВНАЯ функция, ради неё все и затевается ----- /fold }

// установить порядок следования окон в `Z-Index`
// @prm target целевое окно, относительно которого проводим перемещение
// @prm wndNXT перемещаемое окно
// @res true   перемещение УДАЛОСЬ :-)
//----------
// в результате выполнения: (wndTOP)target -> wndNXT .. DeskTop
procedure _wndZOrder_SET_(const target,wndNXT:HWND); {$ifOPT D-}inline;{$endIf}
var dwp:HDWP;
begin {$ifOPT D+}
      Assert(IsWindow(target),'`target`: NOT IsWindow');
      Assert(IsWindow(wndNXT),'`wndNXT`: NOT IsWindow');
      {$endIf}
    // используем реальный WIN-API инструментарий
    dwp:=BeginDeferWindowPos(1);
    {$ifOPT D+} Assert(dwp<>0,'`dwp`: INVALID VALUE'); {$endIf}
    DeferWindowPos(dwp,wndNXT,target,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    EndDeferWindowPos(dwp);
end;

{%endregion -------------------------------------------------------------}

{%region --- #2. Вызов ОСНОВАНОЙ функции ------------------------- /fold }

// расположить `Формы` в порядке `zIndex` (fTop -> form .. DeskTop).
procedure _set_zIndex_in_Order_(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(Assigned(form),'`form`: must be defined');
      {$endIf}
   _wndZOrder_SET_(_wndHNDL_GET_(fTop),_wndHNDL_GET_(form));
end;

// переместить форму на "Второй План"
// @prm fTop форма, которая в настоящий момент находится на переднем плане
// @prm form перемещаемая форма
procedure _bringToSecond_(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
var list:tListFT2F;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(SzOW_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form in the app');
      {$endIf}
    // Особенности см. `b2sp_SzOF.#1`
    list:=SzOF_listFT2F_make (form);
   _set_zIndex_in_Order_(fTop,form);
    SzOF_listFT2F_zFIX  (fTop,form,list);
    SzOF_listFT2F_free  (list);
end;

{%endregion -------------------------------------------------------------}

// Переместить форму на "Второй План"
procedure bringToSecond(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    if SzOW_SecondPlane_possible(form)
    then _bringToSecond_(SzOW_get_topForm_inZOrder,form);
end;

end.

