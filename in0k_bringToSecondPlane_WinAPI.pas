unit in0k_bringToSecondPlane_WinAPI;

{$mode objfpc}{$H+}

interface

uses Forms,Classes,windows;

procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm; const newBounds:TRect);
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm);
procedure in0k_bringToSecondPlane(const movable:TCustomForm; const newBounds:TRect);
procedure in0k_bringToSecondPlane(const movable:TCustomForm);

implementation

function _bringToSecondPlane_(const wndNXT,wndTOP:TCustomForm):boolean; {$ifOPT D-}inline{$endIf}
var dwp:HDWP;
begin // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,wndTOP.Handle,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
    result:=EndDeferWindowPos(dwp);
end;

function _bringToSecondPlane_(const wndNXT,wndTOP:TCustomForm; const newBounds:TRect):boolean; {$ifOPT D-}inline{$endIf}
var dwp:HDWP;
begin // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,wndTOP.Handle,
                   newBounds.Left, newBounds.Top, Max(newBounds.Right-newBounds.Left,0), Max(newBounds.Bottom-newBounds.Top,0),
                   SWP_NOACTIVATE);
    result:=EndDeferWindowPos(dwp);
end;

//------------------------------------------------------------------------------

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
end;

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm TopForm форма, которая в настоящий момент находится на переднем плане
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    {$ifOPT D+}Assert(Assigned(TopForm),'TopForm is NIL');{$endIf}
    {$ifOPT D+}Assert(Screen.FocusedForm=TopForm,'TopForm is NOT realy form in TOP layer');{$endIf}
    if not (Screen.CustomFormZIndex(movable)in[0,1]) then begin
       _bringToSecondPlane_(movable,TopForm);
    end;
end;

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm newBounds новые координаты окна
procedure in0k_bringToSecondPlane(const movable:TCustomForm; const newBounds:TRect);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    in0k_bringToSecondPlane(movable,Screen.FocusedForm,newBounds);
end;

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
procedure in0k_bringToSecondPlane(const movable:TCustomForm);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    in0k_bringToSecondPlane(movable,Screen.FocusedForm);

   // movable.;

end;

end.

