unit in0k_bringToSecondPlane_WinAPI;

//--- Схема работы функции на примере ------------------------ [ in0k (c) 2016 ]
//
//     Z-Index
//
//     0    Wnd00              +-> Wnd_A                        Wnd_A
//     1    Wnd01              |   Wnd00                    +-> Wnd_B
//     2     ...               |   Wnd01                    |   Wnd00
//     3     ...               |    ...                     |   Wnd01
//    ...    ...               |    ...                     |
//     N    Wnd_A.bringToFront-^    ...                     |
//     M     ...                   Wnd_B.bringToSecondPlane-^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//
// "НАТИвНаЯ" реализация, НЕ моргает.
//----------------------------------------------------------------------------//
   {%region --- проверка совместимости ------------------------- /fold}
    {$IF not(DEFINED(LCLWin32) or DEFINED(LCLWin64))}
    {$ERROR 'WRONG `WidgetSet`! Unit must be used only with `LCLWin32` or `LCLWin64`!'}
    {$endIF}
   {%endregion}
//----------------------------------------------------------------------------//

interface

uses
  in0k_WwSZO,
  Forms,
  windows;

procedure bringToSecondPlane(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

// расположить `Формы` в порядке `zIndex` (.. source -> wndNXT .. DeskTop).
// @res true все удалось :-)
function _set_zIndex_in_Order_(const source,wndNXT:TCustomForm):boolean; {$ifOPT D-}inline;{$endIf}
var dwp:HDWP;
begin {$ifOPT D+}
      Assert(Assigned(source),'`source`: must be defined');
      Assert(Assigned(wndNXT),'`wndNXT`: must be defined');
      {$endIf}
    // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,source.Handle,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    result:=EndDeferWindowPos(dwp);
end;

// переместить форму на "Второй План"
// @prm fTop форма, которая в настоящий момент находится на переднем плане
// @prm form перемещаемая форма
procedure in0k_bringToSecondPlane(const fTop,form:TCustomForm); {$ifOPT D-}inline;{$endIf}
var list:tListFT2F;
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(fTop),'`fTop`: must be defined');
      Assert(WwSZO_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form in the app');
      {$endIf}
      // Особенности см. `in0k_WwSZO.Параграф#2`
    list:=WwSZO_listFT2F_make(form);
    if _set_zIndex_in_Order_(fTop,form) then begin
        WwSZO_listFT2F_zFIX (fTop,form,list);
    end
    {$ifOPT D+}
    else Assert(false,'`form`: unable to move');
    {$endIf};
    WwSZO_listFT2F_free(list);
end;

// Переместить форму на "Второй План"
procedure bringToSecondPlane(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    if WwSZO_2SecondPlane_possible(form)
    then in0k_bringToSecondPlane(WwSZO_get_topForm_inZOrder,form);
end;

end.

