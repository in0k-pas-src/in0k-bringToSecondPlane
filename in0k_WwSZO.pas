unit in0k_WwSZO;

//-------------------------------------------------------------[ in0k (c) 2018 ]
// Work with Screen Z-Order
//----------------------------------------------------------------------------//
//
//  Параграф #2. Причина.
//      Прямое использование системных вызовов перемещения окон по zIndex
//      иногда НАРУШАЕТ очередность окон в списке `Screen.FCustomFormsZOrdered`.
//      Это зависит от реализации `widgetSet` (точно ломается в `win` и `Gtk2`).
//      Кривой порядок, видимо, может привести с казусам. И как следствие,
//      ЭТО НАДО ЧИНИТЬ.
//
//  Параграф #2. Особенности.
//    - Список `Screen.FCustomFormsZOrdered`, как и `Screen.FCustomForms`,
//      переодически перестраивается (например при перемещении фокуса на другое
//      окно). Однако, где это происходит и как это НЕЗАМЕТНО спровоцировать
//      я не нашёл. Т.е. судьба ... опять через "зад" :-(
//    - Список `Screen.FCustomFormsZOrdered` -- ПРИВАТНЫЙ, прямого доступа к
//      нему НЕТ. Но есть метод `Screen.MoveFormToZFront`, который работает
//      со списком, правда делает он НЕ то и НЕ так (переносит указанную форму
//      на ВеРШИНу списка в `zIndex`=0).
//
//  Параграф #2. Реализация - Исправление - Логика.
//    - Составляем "список" окон между `TOP-окном` и `form`.
//    - Перемещаем `form` на второй план.
//    - Восстанавливаем ПРАВИЛЬНЫЙ порядок `Screen.FCustomFormsZOrdered`
//      = в ОБРАТНОМ порядке по "списку" вызываем `Screen.MoveFormToZFront`
//      = добиваем вызовами для `form` и `TOP-окном`
//      = вуаля .. теперь список ПРАВИЛЬНЫЙ.
//    - МОЛИМСЯ, чтобы в последующих версиях Lazarus`а поведение метода
//      `Screen.MoveFormToZFront` кардинально не изменилось.
//
//----------------------------------------------------------------------------//

{$mode objfpc}{$H+}

interface

uses
  Classes,
  Forms;

// --- Параграф #1 ---

function  WwSZO_get_topForm_inZOrder:TCustomForm;                      {$ifOPT D-}inline;{$endIf}
function  WwSZO_form_is_TOP_inZOrder (const form:TCustomForm):boolean; {$ifOPT D-}inline;{$endIf}
function  WwSZO_2SecondPlane_possible(const form:TCustomForm):boolean; {$ifOPT D-}inline;{$endIf}

// --- Параграф #2 ---

type tListFT2F=array of TCustomForm;

function  WwSZO_listFT2F_make(const form:TCustomForm):tListFT2F;                {$ifOPT D-}inline;{$endIf}
procedure WwSZO_listFT2F_zFIX(const fTop,form:TCustomForm; var list:tListFT2F); {$ifOPT D-}inline;{$endIf}
procedure WwSZO_listFT2F_free(var list:tListFT2F);                              {$ifOPT D-}inline;{$endIf}

implementation

// получить форму с вершины списка `Z-Order`
function WwSZO_get_topForm_inZOrder:TCustomForm;
begin
    if Screen.CustomFormZOrderCount>0
    then result:=Screen.CustomFormsZOrdered[0]
    else result:=nil;
end;

// Форма находится на ВЕРШИНЕ списка `Z-Order`
function WwSZO_form_is_TOP_inZOrder(const form:TCustomForm):boolean;
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    result:= form=WwSZO_get_topForm_inZOrder;
end;

// Перемещение формы на второй план ВОЗМОЖНО
// @prm form форма для которой проводим ТЕСТ
function WwSZO_2SecondPlane_possible(const form:TCustomForm):boolean;
begin {$ifOPT D+} Assert(Assigned(form),'`form`: must be defined'); {$endIf}
    result:=(Screen.CustomFormZOrderCount>1) AND   // форм ДОЛЖНО быть МИНИМУМ две
            (Screen.CustomFormsZOrdered[1]<>form); // и Форма НЕ-На-Месте
end;

//------------------------------------------------------------------------------

// Создать список форм, находящихся МЕЖДУ `TOP-формой` и `form`
function WwSZO_listFT2F_make(const form:TCustomForm):tListFT2F;
var i:integer;
begin {$ifOPT D+}
      Assert(Screen.CustomFormZOrderCount>1,'`Screen`: forms in the application is too small, should be more than two');
      Assert(Assigned(form),'`form`: must be defined');
      Assert(Screen.CustomFormZIndex(form)>1,'`form`: wrong place, must be BELOW second plane');
      {$endIf}
    //
    SetLength(result, Screen.CustomFormZIndex(form)-1);
    for i:=1 to Screen.CustomFormZIndex(form)-1 do begin
        result[i-1]:=Screen.CustomFormsZOrdered[i];
    end;
end;

// Исправить порядок следования форм в `zIndex-списка` окон приложения
procedure WwSZO_listFT2F_zFIX(const fTop,form:TCustomForm; var list:tListFT2F);
var i:integer;
begin {$ifOPT D+}
      Assert(Assigned(list),'`list`: must be defined');
      Assert(Length(list)>0,'`list`: the number of elements must be greater than zero');
      Assert(Assigned(fTop),'`fTop`: must be defined ');
      Assert(WwSZO_form_is_TOP_inZOrder(fTop),'`fTop`: must be TOP form of the application');
      Assert(Assigned(form),'`form`: must be defined');
      {$endIf}
    for i:= Length(list)-1 downto 0 do begin
        {$ifOPT D+}
        Assert(list[i]<>fTop,'`fTop`: placed in `list`, it is ERROR');
        Assert(list[i]<>form,'`form`: placed in `list`, it is ERROR');
        {$endIf}
        Screen.MoveFormToZFront(list[i]);
    end;
    Screen.MoveFormToZFront(form);
    Screen.MoveFormToZFront(fTop);
end;

// уничтожить список
procedure WwSZO_listFT2F_free(var list:tListFT2F);
begin {$ifOPT D+} Assert(Assigned(list),'WRONG: list=nil'); {$endIf}
    SetLength(list,0)
end;

end.

