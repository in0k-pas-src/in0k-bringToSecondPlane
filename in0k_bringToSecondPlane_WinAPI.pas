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
//	   M     ...                   Wnd_B.bringToSecondPlane-^
//    ...    ...                    ...
//    ...............................................................
//    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop
//
//----------------------------------------------------------------------------//

interface

uses Forms,windows;

procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm);
procedure in0k_bringToSecondPlane(const movable:TCustomForm);

implementation

function _bringToSecondPlane_(const wndNXT,wndTOP:TCustomForm):boolean; {$ifOPT D-}inline{$endIf}
var dwp:HDWP;
begin // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,wndTOP.Handle,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
    result:=EndDeferWindowPos(dwp);
end;

(* какой-то касяк с окнами БЕЗ границы
function _bringToSecondPlane_(const wndNXT,wndTOP:TCustomForm; const newBounds:TRect):boolean; {$ifOPT D-}inline{$endIf}
var dwp:HDWP;
begin // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,wndTOP.Handle,
                   newBounds.Left, newBounds.Top, Max(newBounds.Right-newBounds.Left,0), Max(newBounds.Bottom-newBounds.Top,0),
                   SWP_NOACTIVATE);
    result:=EndDeferWindowPos(dwp);
end;*)

//------------------------------------------------------------------------------

(* какой-то касяк с окнами БЕЗ границы
// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm TopForm форма, которая в настоящий момент находится на переднем плане
// @prm newBounds новые координаты окна
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm; const newBounds:TRect);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    {$ifOPT D+}Assert(Assigned(TopForm),'TopForm is NIL');{$endIf}
    {$ifOPT D+}Assert(Screen.FocusedForm=TopForm,'TopForm is NOT realy form in TOP layer');{$endIf}
   _bringToSecondPlane_(movable,TopForm,newBounds);
end;*)

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm TopForm форма, которая в настоящий момент находится на переднем плане
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    {$ifOPT D+}Assert(Assigned(TopForm),'TopForm is NIL');{$endIf}
    {$ifOPT D+}Assert(Screen.FocusedForm=TopForm,'TopForm is NOT realy form in TOP layer');{$endIf}
    //if true {not (Screen.CustomFormZIndex(movable)in[0,1])} then begin
        {todo: а вот чет НЕ всегда этот массив в АКТУАЛЬНОМ состоянии. РАЗОБРАТЬСЯ}
        {todo: фиговато ловятся перемещения посредством WINAPI, потому и не актуально :-( }
       _bringToSecondPlane_(movable,TopForm);
    //end;
end;

(* какой-то касяк с окнами БЕЗ границы
// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm newBounds новые координаты окна
procedure in0k_bringToSecondPlane(const movable:TCustomForm; const newBounds:TRect);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    in0k_bringToSecondPlane(movable,Screen.FocusedForm,newBounds);
end;*)

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
procedure in0k_bringToSecondPlane(const movable:TCustomForm);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    in0k_bringToSecondPlane(movable,Screen.FocusedForm);
end;

end.

