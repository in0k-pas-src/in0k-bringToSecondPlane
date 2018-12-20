unit in0k_bringToSecondPlane_lclGtk2;

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
//     M     ...                   Wnd_B.bringToSecondPlane-^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//
// "НАТИвНаЯ" реализация, НЕ моргает.
//----------------------------------------------------------------------------//
   {%region --- проверка совместимости ------------------------ /fold}
    {$IF not(DEFINED(LCLgtk2))}
    {$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLgtk2`!'}
    {$endIF}
   {%endregion}
//----------------------------------------------------------------------------//

interface

uses
  in0k_WwSZO,
  Forms,
  gdk2, glib2, Gtk2Proc;

procedure bringToSecondPlane(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation

// она ЕСТЬ, но НЕ объявлена :-)
procedure gdk_window_restack(window: PGdkWindow; sibling: PGdkWindow; above: gboolean); cdecl; external gdklib;

// расположить `Формы` в порядке `zIndex` (.. source -> wndNXT .. DeskTop).
procedure _set_zIndex_in_Order_(const source,wndNXT:TCustomForm);
var pWndNXT:PGdkWindow;
    pSource:PGdkWindow;
begin {$ifOPT D+}
      Assert(Assigned(source),'`source`: must be defined');
      Assert(Assigned(wndNXT),'`wndNXT`: must be defined');
      {$endIf}
    // получаем `Gtk` указатели
    pSource:=GetControlWindow(pointer{PGtkWidget}(source.Handle));
    if pSource=nil then Exit;
    pWndNXT:=GetControlWindow(pointer{PGtkWidget}(wndNXT.Handle));
    if pWndNXT=nil then Exit;
    // перемещаем
    gdk_window_restack(pWndNXT,pSource,false);
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
   _set_zIndex_in_Order_(fTop,form);
    WwSZO_listFT2F_zFIX (fTop,form,list);
    WwSZO_listFT2F_free (list);
end;

// Переместить форму на "Второй План"
procedure bringToSecondPlane(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    if WwSZO_2SecondPlane_possible(form)
    then in0k_bringToSecondPlane(WwSZO_get_topForm_inZOrder,form);
end;

end.

