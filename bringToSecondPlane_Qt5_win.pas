unit bringToSecondPlane_Qt5_win;

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


{$mode objfpc}{$H+}

interface

{%region --- проверка совместимости ------------------------------- /fold}
{$ifNdef MSWINDOWS}
{$ErrOr 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
{$endIF}
{$ifNdef LCLqt5}
{$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLqt5`!'}
{$endIF}
{%endregion}

uses
  b2sp_SzOW,
  b2sp_SzOF,
  Forms, windows,
  qt5, qtwidgets,
  b2sp_win_wndZOrder;

procedure bringToSecondPlane(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

function _form_HWND_(const form:TCustomForm):HWND; {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+} //БОЛЬШЕ проверок БОГУ проверок
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(TQtWidget(form.Handle)),'`TQtWidget(form.Handle)`: NIL');
      Assert(Assigned(TQtWidget(form.Handle).Widget),'`TQtWidget(form.Handle).Widget`: NIL');
      {$endIf}
    result:=QWidget_winID(TQtWidget(form.Handle).Widget);

    //form.
end;

// расположить `Формы` в порядке `zIndex` (fTop -> form .. DeskTop).
procedure _set_zIndex_in_Order_(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(Assigned(form),'`form`: must be defined');
      {$endIf}
    b2sp_win_wndZOrder__SET(_form_HWND_(fTop),_form_HWND_(form));
end;

// переместить форму на "Второй План"
// @prm fTop форма, которая в настоящий момент находится на переднем плане
// @prm form перемещаемая форма
procedure in0k_bringToSecondPlane(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
var list:tListFT2F;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(SzOW_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form in the app');
      {$endIf}
    // Особенности см. `in0k_SzOF.#1`
    list:=SzOF_listFT2F_make (form);
   _set_zIndex_in_Order_(fTop,form);
    SzOF_listFT2F_zFIX  (fTop,form,list);
    SzOF_listFT2F_free  (list);
end;

// Переместить форму на "Второй План"
procedure bringToSecondPlane(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    if SzOW_SecondPlane_possible(form)
    then in0k_bringToSecondPlane(SzOW_get_topForm_inZOrder,form);
end;

end.

