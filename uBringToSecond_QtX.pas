unit uBringToSecond_QtX;

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
// "НАТИвНаЯ" реализация (!!! АНАЛОГИЧНА варианту LCL !!!).
//  В связи с тем, что QtX НЕ поддерживает прямое управление порядком окон,
//  то делаем всё тоже самое, но на функциях QtX (субъективно БЫСТРЕЕ чем LCL)
//----------------------------------------------------------------------------//
   {%region --- проверка совместимости ------------------------ /fold}
    {$IF not(DEFINED(LCLqt) or DEFINED(LCLqt5))}
    {$ErrOr 'WRONG `WidgetSet`! Unit must be used only with `LCLqt` or `LCLqt5`!'}
    {$endIF}
   {%endregion}
   {%region --- подсказки про СИСТЕМНЫЕ библиотеки ------------ /fold}
    {$If DEFINED(MSWINDOWS)}
    {$note ------------------------------------------------------}
    {$note   Under "Windows" system it doesn't work very well.   }
    {$note   For best results, try use `bringToSecond_WIN.pas`.  }
    {$note ------------------------------------------------------}
    {$endIF}
   {%endregion}
//----------------------------------------------------------------------------//

interface

uses
  uB2SP_SzOW,
  uB2SP_SzOF,
  Forms;

procedure bringToSecond(const form:TCustomForm); {$ifOPT D-}inline;{$endIf}

implementation
{% TESTed in0k 20190530 i386-win32-qt5 Lazarus:2.0.0.4 FPC:3.0.4              %}
{% TESTed in0k 20190530 x86_64-linux-qt Lazarus:2.0.2.0 FPC:3.0.4             %}
{% TESTed in0k 20190530 x86_64-linux-qt5 Lazarus:2.0.2.0 FPC:3.0.4            %}
uses //-------
     {$if defined(LCLqt)}
     qt4,
     {$elseIf defined(LCLqt5)}
     qt5,
     {$else}
     {$error 'main `WidgetSet` unit NOT define'}
     {$endIf}
     //-------
     qtwidgets;

// разрешить\блокировать обновлене окна
procedure _qtX_setUpdatesEnbld_(const form:TCustomForm; const value:boolean); {$ifOpt D-}inline;{$endIf}
begin {$ifOPT D+}
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Assigned(TQtWidget(form.Handle)),'`TQtWidget(form.Handle)`: is NULL');
      {$endIf}
    // подсмотрел в исходниках Qt5, там вообще БЕЗ проверок !!!
    TQtWidget(form.Handle).setUpdatesEnabled(value);
end;

// разрешить\блокировать обновлене СПИСКА окон
procedure _qtX_setUpdatesEnbld_(const list:tListFT2F; const value:boolean); {$ifOpt D-}inline;{$endIf}
var i:integer;
begin
    for i:=0 to Length(list)-1 do begin
       _qtX_setUpdatesEnbld_(list[i],value)
    end;
end;

// расположить `Формы` в порядке `zIndex` ( topWND -> second .. DeskTop).
procedure _set_zIndex_in_Order_(const topWND,second:TCustomForm);
begin {$ifOPT D+}
      Assert(Assigned(topWND),'`topWND`: must be defined');
      Assert(Assigned(TQtWidget(topWND.Handle)),'`TQtWidget(topWND.Handle)`: is NULL');
      Assert(Assigned(second),'`second`: must be defined');
      Assert(Assigned(TQtWidget(second.Handle)),'`TQtWidget(second.Handle)`: is NULL');
      {$endIf}
   _qtX_setUpdatesEnbld_(topWND,false);   // запрещаем обновлять
   _qtX_setUpdatesEnbld_(second,false);   //
    TQtWidget(second.Handle).raiseWidget; // перемещение
    TQtWidget(topWND.Handle).raiseWidget; //
   _qtX_setUpdatesEnbld_(second,true);    // разрешаем обновлять
   _qtX_setUpdatesEnbld_(topWND,true);    //
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
   _qtX_setUpdatesEnbld_(list,FALSE); // запрещаем обновлять окна
   _set_zIndex_in_Order_(fTop,form);  // перемещаем
   _qtX_setUpdatesEnbld_(list,true);  // разрешаем обновлять окна
    SzOF_listFT2F_zFIX  (fTop,form,list);
    SzOF_listFT2F_free  (list);
end;

// Переместить форму на "Второй План"
procedure bringToSecond(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    if SzOW_SecondPlane_possible(form)
    then _bringToSecond_(SzOW_get_topForm_inZOrder,form);
end;

end.

