unit bringToSecond_X11;

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
// "НАТИвНаЯ" реализация, НЕ моргает (если НЕ из под Windows).
//----------------------------------------------------------------------------//

interface

uses
  b2sp_SzOW,
  b2sp_SzOF,
  Forms,
  ctypes, x, xlib;

procedure bringToSecond(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

{%region --- #0. x11 functions ----------------------------------- /fold }

{$IF DEFINED(LCLqt) or DEFINED(LCLqt5)} //---------------------------------- QtX
{% TESTed in0k 20190530 x86_64-linux-qt Lazarus:2.0.2.0 FPC:3.0.4             %}
{% TESTed in0k 20190530 x86_64-linux-qt5 Lazarus:2.0.2.0 FPC:3.0.4            %}
uses
  {$if DEFINED(LCLqt5)}
  qt5,
  {$elseif DEFINED(LCLqt)}
  qt4,
  {$endIf}
  qtwidgets;

//получить указател на ДИсплей
function _get_Display_(const {%H-}window:TWindow):PDisplay;
begin
    result:=QX11Info_display();
    //result:=GDK_WINDOW_XDISPLAY(window);
end;

function _get_Window_(const form:TCustomForm):TWindow;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(form.HandleAllocated,'`form.Handle`: not Allocated');
      Assert(Assigned(TQtWidget(form.Handle).Widget),'`Widget`: must be defined');
      {$endIf}
    result:=QWidget_winId(TQtWidget(form.Handle).Widget);
end;

{$elseIF DEFINED(LCLgtk3)} //---------------------------------------------- Gtk3

uses gtk3int,LazGdk3;

function gdk_display_get_default: PGdkDisplay; cdecl; external;

{$elseIF DEFINED(LCLgtk2)} //---------------------------------------------- Gtk2
{% TESTed in0k 20190530 x86_64-linux-gtk2 Lazarus:2.0.2.0 FPC:3.0.4           %}
uses gtk2,gdk2x;

//получить указател на ДИсплей
function _get_Display_(const {%H-}window:TWindow):PDisplay;
begin                                                                 s
    result:=gdk_display;
end;

function _get_Window_(const form:TCustomForm):TWindow;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(form.HandleAllocated,'`form.Handle`: not Allocated');
      {$endIf}
    result:=GDK_WINDOW_XID({%H-}PGtkWidget(form.Handle)^.window);
end;

//------------------------------------------------------------------------------
{$else} // что-то пошло не так :-( // Сообщим об ошибке, поклянчим фидБек
    {$error Target platform not supported!             }
    {$note  Please, report this error to the developer.}
{$endIF}

{%endregion -------------------------------------------------------------}

{%region --- #1. ОСНОВНАЯ функция, ради неё все и затевается ----- /fold }

function _fail_(const status:TStatus):boolean; inline;
begin
    result:=(status=0);
end;

function _success_(const status:TStatus):boolean; inline;
begin
    result:=NOT _fail_(status);
end;

//------------------------------------------------------------------------------

// номер экрана на котором расположено окно
// @prm display указатель на структуру TDisplay
// @prm window  интерисуемое окно
// @res         номер SCREEN
function _get_screenNumber_(const display:PDisplay; const window:TWindow):cuint; {$ifOPT D-}inline;{$endIf}
var wa:TXWindowAttributes;
    i :cint;
begin {$ifOPT D+}
      Assert(Assigned(display),'`display`: NOT defined');
      Assert(0<>window        ,'`window`: NOT defined');
      {$endIf}
    if _fail_( XGetWindowAttributes(display,window,@wa) ) then exit(0);
    //---
    for i:=0 to XScreenCount(display)-1 do begin
        if wa.screen=XScreenOfDisplay(display,i)
        then exit(i);
    end;
    result:=0; //< по идее это КОСЯК !
end;

// установить порядок следования окон в `Z-Index`
// @prm display указатель на структуру TDisplay
// @prm target  целевое окно, относительно которого проводим перемещение
// @prm wndNXT  перемещаемое окно
// @res true    перемещение УДАЛОСЬ :-)
//----------
// в результате выполнения: (wndTOP)target -> wndNXT .. DeskTop
function _wndZOrder_SET_(const display:PDisplay; const target,wndNXT:TWindow):boolean; {$ifOPT D-}inline;{$endIf}
var changes:TXWindowChanges;
begin
    changes.sibling   := target;
    changes.stack_mode:= Below;
    result:=_success_(
        XReconfigureWMWindow(display,
                             wndNXT,
                            _get_screenNumber_(display,target),
                             CWStackMode or CWSibling,
                             @changes)
                     );
end;

{%endregion -------------------------------------------------------------}

{%region --- #2. Вызов ОСНОВАНОЙ функции ------------------------- /fold }

// расположить `Формы` в порядке `zIndex` (fTop -> form .. DeskTop).
procedure _set_zIndex_in_Order_(const display:PDisplay; const target,wndNXT:TWindow); {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      //Assert(Assigned(fTop),'`fTop`: must be defined');
      //Assert(Assigned(form),'`form`: must be defined');
      {$endIf}
     _wndZOrder_SET_(display,target,wndNXT);
end;

// переместить форму на "Второй План"
// @prm fTop форма, которая в настоящий момент находится на переднем плане
// @prm form перемещаемая форма
procedure _bringToSecond_(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
var list   :tListFT2F;
    display:pDisplay;
    x11_TOP:TWindow;
    x11_FRM:TWindow;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(SzOW_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form in the app');
      {$endIf}
    // Особенности см. `b2sp_SzOF.#1`
    list:=SzOF_listFT2F_make (form);
    //
    x11_TOP:=_get_Window_ (fTop);
    x11_FRM:=_get_Window_ (form);
    display:=_get_Display_(x11_TOP);
    {$ifOPT D+}
    Assert(Assigned(display),'`display`: must be defined');
    Assert(0<>x11_TOP,       '`x11_TOP`: must be defined');
    Assert(0<>x11_FRM,       '`x11_FRM`: must be defined');
    {$endIf}
   _set_zIndex_in_Order_(display,x11_TOP,x11_FRM);
    //
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

