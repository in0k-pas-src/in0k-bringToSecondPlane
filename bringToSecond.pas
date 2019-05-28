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
{$If DEFINED(MSWINDOWS)}
  {$IF DEFINED(LCLWin32) or DEFINED(LCLWin64)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$elseIf DEFINED(LCLqt) or DEFINED(LCLqt5)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$elseIf DEFINED(LCLgtk2)}
    {$define b2sp_implementation_WIN}{$define b2sp_implementation_selected}
  {$endIF}
{$endIF}
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
  {$elseif defined(b2sp_implementation_QtX) }
      // теперь надо определить, можно ли использовать X11 НАПРЯМУЮ
      {$if DEFINED(LCLqt5)}
        {%region --- воровано `qt56.pas` /fold }
            {$IFDEF MSWINDOWS}
            {$ELSE}
              {$IFDEF DARWIN}
                {$LINKFRAMEWORK Qt5Pas}
              {$ELSE}
                  {$IF DEFINED(LINUX) or DEFINED(FREEBSD) or DEFINED(NETBSD)}
                  {$DEFINE BINUX}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
        {%endRegion}
      {$elseif DEFINED(LCLqt)}
        {%region --- воровано `qt45.pas` /fold }
            {$IFNDEF QTOPIA}
              {$IF DEFINED(LINUX) or DEFINED(FREEBSD) or DEFINED(NETBSD)}
                {$DEFINE BINUX}
              {$ENDIF}
            {$ENDIF}
        {%endRegion}
      {$endif}
      //-- выбор реализаии
      {$if defined(BINUX)}
         {$define b2sp_implementation_X11}
         bringToSecond_X11
      {$else}
         bringToSecond_QtX
      {$endif}
  {$elseif defined(b2sp_implementation_GtkX)}
      // теперь надо определить, можно ли использовать X11 НАПРЯМУЮ
      {$if DEFINED(LCLgtk3)}
           // буду копать по необходимости
      {$elseif DEFINED(LCLgtk2)}
           {%region --- воровано `gtk2defines.inc` /fold }
                {off $define UseX}
                {$ifdef Unix}
                  // on darwin we try to use native gtk
                  {$ifdef Darwin}
                    {$ifdef UseX} // it can be overridden
                      {$define HasX}
                    {$endif}
                  {$else}
                    {$define HasX}
                  {$endif}
                {$endif}
           {%endRegion}
      {$endif}
      //-- выбор реализаии
      {$if defined(HasX)}
         {$define b2sp_implementation_X11}
         bringToSecond_X11
      {$else}
         bringToSecond_GtkX
      {$endif}
  {$else}{шансов НЕТ .. вариант по умолчанию} bringToSecond_LCL
    {$note --------------------------------------------------------------------}
    {$note  in0k-bringToSecondPlane: The basic cross-platform version is used. }
    {$note  Can work slowly and with flicker.                                  }
    {$note --------------------------------------------------------------------}
  {$endIF};

{$ifOpt D+}
const cBringToSecondUNIT=
{$if     defined(b2sp_implementation_WIN) } 'bringToSecond_WIN'
{$elseif defined(b2sp_implementation_X11) } 'bringToSecond_X11'
{$elseif defined(b2sp_implementation_QtX) } 'bringToSecond_QtX'
{$elseif defined(b2sp_implementation_GtkX)} 'bringToSecond_GtkX'
{$else}'bringToSecond_LCL'{$endIF};
{$endIF}

procedure bringToSecond(const form:TCustomForm);

implementation

procedure bringToSecond(const form:TCustomForm);
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
  {$if defined(b2sp_implementation_WIN)}
    bringToSecond_WIN.bringToSecond(form);
  {$elseif defined(b2sp_implementation_X11)}
    bringToSecond_X11.bringToSecond(form);
  {$elseif defined(b2sp_implementation_QtX)}
    bringToSecond_QtX.bringToSecond(form);
  {$elseif defined(b2sp_implementation_GtkX)}
    bringToSecond_GtkX.bringToSecond(form);
  {$else}
    bringToSecond_LCL.bringToSecond(form);
  {$endIF}
end;

end.

