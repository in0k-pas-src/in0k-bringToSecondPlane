unit in0k_bringToSecondPlane_LazLCL;

{$mode objfpc}{$H+}

interface

uses Forms, Classes;

procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm; const newBounds:TRect);
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm);
procedure in0k_bringToSecondPlane(const movable:TCustomForm; const newBounds:TRect);
procedure in0k_bringToSecondPlane(const movable:TCustomForm);

implementation

// переместить форму на "Второй План"
// @prm movable перемещаемая форма
// @prm TopForm форма, которая в настоящий момент находится на переднем плане
// @prm newBounds новые координаты окна
procedure in0k_bringToSecondPlane(const movable,TopForm:TCustomForm; const newBounds:TRect);
begin
    {$ifOPT D+}Assert(Assigned(movable),'movable is NIL');{$endIf}
    {$ifOPT D+}Assert(Assigned(TopForm),'TopForm is NIL');{$endIf}
    {$ifOPT D+}Assert(Screen.FocusedForm=TopForm,'TopForm is NOT realy form in TOP layer');{$endIf}
    movable.BoundsRect:=newBounds;
    in0k_bringToSecondPlane(movable,TopForm);
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
        movable.BringToFront;
        TopForm.BringToFront;
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
end;

end.

