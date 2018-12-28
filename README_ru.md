# in0k-bringToSecondPlane
Библиотека [модулей][1] для использования в [Lazarus][2] [LCL][3].

## Назначение
Переместить окно (`tForm`) во ВТОРУЮ позицию списка Z-Order окон приложения. 


     Z-Index                                                       
                                                                   
    T0P   Wnd00              +-> Wnd_A                        Wnd_A
     1    Wnd01              |   Wnd00                  +---> Wnd_B
     2     ...               |   Wnd01                  |     Wnd00
     3     ...               |    ...                   |     Wnd01
    ...    ...               |    ...                   |          
     N    Wnd_A.bringToFront-^    ...                   |          
     M     ...                   bringToSecond(Wnd_B)---^          
    ...    ...                    ...                              
    ...............................................................
    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop


## Использование

* Готовый пример в проекте `demo/uiDemoTEST.lpi`

* Пример использования в коде

     ```pascal    
        uses ...
             in0k_bringToSecondPlane,
             ...;
        
        ..
        bringToSecond(myForm);
        ..
     ```    
        

## Установка
1. Скопируйте или клонируйте содержимое репозитория к себе в папку `%SomeDIR%`
2. В параметрах проекта укажите папку `%SomeDIR%` в [путях поиска][s1]


## Состав
* `in0k_bringToSecondPlane.pas` **обобщенный** вариант. По возможности использует
   **нативную** реализацию для целевой платформы. Если реализации нет, то кроссплатформенный вариант.
* `in0k_bringToSecondPlane_LazLCL.pas`  кроссплатформенный вариант.
   * Функционал процедуры `bringToSecond` достигается последовательным вызовом `Wnd_B.bringToFront; Wnd_A.bringToFront `.
   * `+` должно работать на ВСЕХ платформах. 
   * `-` периодически заметно характерное мерцание интерфейса. 
* `*` `in0k_bringToSecondPlane_WinAPI.pas` платформа **LCLWin32**, **LCLWin64** 
* `*` `in0k_bringToSecondPlane_lclGtk2.pas` платформа **LCLgtk2**
* `*` `in0k_bringToSecondPlane_lclGtk3.pas` платформа **LCLgtk3**

###### примечания

 * `*` - мерцание ОТСУТСТВУЕТ.

[1]: http://wiki.lazarus.freepascal.org/Unit
[2]: http://wiki.lazarus.freepascal.org
[3]: http://wiki.lazarus.freepascal.org/LCL
[s1]: http://wiki.lazarus.freepascal.org/IDE_Window:_Project_Options#Other_Unit_Files 
