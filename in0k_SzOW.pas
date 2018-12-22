unit in0k_SzOW;

//-------------------------------------------------------------[ in0k (c) 2018 ]
// Screen Z-Order Work
//----------------------------------------------------------------------------//

{$mode objfpc}{$H+}

interface

uses Forms;

function  SzOW_get_topForm_inZOrder:TCustomForm;                     {$ifOPT D-}inline;{$endIf}
function  SzOW_form_is_TOP_inZOrder(const form:TCustomForm):boolean; {$ifOPT D-}inline;{$endIf}
function  SzOW_SecondPlane_possible(const form:TCustomForm):boolean; {$ifOPT D-}inline;{$endIf}

implementation

// получить форму с вершины списка `Z-Order`
function SzOW_get_topForm_inZOrder:TCustomForm;
begin
    if Screen.CustomFormZOrderCount>0
    then result:=Screen.CustomFormsZOrdered[0]
    else result:=nil;
end;

// Форма находится на ВЕРШИНЕ списка `Z-Order`
function SzOW_form_is_TOP_inZOrder(const form:TCustomForm):boolean;
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    result:= form=SzOW_get_topForm_inZOrder;
end;

// Перемещение формы на второй план ВОЗМОЖНО
// @prm form форма для которой проводим ТЕСТ
function SzOW_SecondPlane_possible(const form:TCustomForm):boolean;
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    result:=(Screen.CustomFormZOrderCount>1) AND   // форм ДОЛЖНО быть МИНИМУМ две
            (Screen.CustomFormsZOrdered[1]<>form); // и Форма НЕ-На-Месте
end;

end.

