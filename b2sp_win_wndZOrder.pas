unit b2sp_win_wndZOrder;

//-------------------------------------------------------------[ in0k (c) 2019 ]
// Изменение порядка следования окон в `Z-Index`
// с исвользованием `Windows API` функций
//----------------------------------------------------------------------------//

interface

{%region --- проверка совместимости c `Windows API` --------------- /fold}
    {$IF not(DEFINED(MSWINDOWS))}
    {$ERROR 'WRONG `OS Target`! Unit must be used only with `MSWINDOWS`!'}
    {$endIF}
{%endregion}

uses windows;

// установить порядок следования окон в `Z-Index`
// @prm target целевое окно, относительно которого проводим перемещение
// @prm wndNXT перемещаемое окно
// @res true   перемещение УДАЛОСЬ :-)
//----------
// в результате выполнения: (wndTOP)target -> wndNXT .. DeskTop
function b2sp_win_wndZOrder__SET(const target,wndNXT:HWND):boolean; {$ifOPT D-}inline;{$endIf}

implementation

function b2sp_win_wndZOrder__SET(const target,wndNXT:HWND):boolean;
var dwp:HDWP;
begin {$ifOPT D+}
      Assert(IsWindow(target),'`target`: NOT IsWindow');
      Assert(IsWindow(wndNXT),'`wndNXT`: NOT IsWindow');
      {$endIf}
    // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    {$ifOPT D+} //< больше проверок БОГУ проверок
    Assert(dwp<>0,'`dwp`: INVALID VALUE');
    {$endIf}
    DeferWindowPos(dwp,wndNXT,target,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    result:=EndDeferWindowPos(dwp);
end;

end.

