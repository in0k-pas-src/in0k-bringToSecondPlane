
# in0k-bringToSecondPlane

Библиотека [модулей][1] для использования в [Lazarus][2] [LCL][3].



## Назначение

Переместить окно (`tForm`) на ВТОРУЮ позицию списка Z-Order окон приложения.

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



## Состав

* `bringToSecond.pas` **обобщенный** вариант. По возможности использует
   **нативную** реализацию для целевой платформы.
   Если реализации нет, то кроссплатформенный вариант.
* `bringToSecond_LCL.pas`  кроссплатформенный вариант.
   * Функционал процедуры `bringToSecond` достигается
     последовательным вызовом `Wnd_B.bringToFront; Wnd_A.bringToFront`
   * `+` должно работать на ВСЕХ платформах.
   * `-` периодически заметно характерное мерцание интерфейса
* `bringToSecond_WIN.pas` используютя функции **WinAPI**
* `bringToSecond_X11.pas` используютя функции **xlib**
* `bringToSecond_GtkX.pas` используютя методы **Gtk**
* `bringToSecond_QtX.pas` используютя методы **Qt**



## Таблица совместимости

   |              |win32/64|x11/xlib|  GTK2  |  GTK3  |   Qt4  |   Qt5  |
   |:-------------|:------:|:------:|:------:|:------:|:------:|:------:|
   | `.._LCL.pas` |  [::]  |  [::]  |  [::]  |  [::]  |  [::]  |  [::]  |
   | `.._WIN.pas` |  [+]   |        |  [+]   |        |  [#]   |  [+]   |
   | `.._X11.pas` |        |        |  [+]   |        |  [+]   |  [+]   |
   | `.._GtkX.pas`|  [~1]  |        |  [+]   |  [+]   |        |        |
   | `.._QtX.pas` |  [~2]  |        |        |        |  [~3]  |  [~3]  |

- `[::]` - должно работать ВЕЗДЕ, где присутствут Lazarus
- `[+] ` - реализовано, тестировано
- `[#] ` - реализовано, НЕ тестировано
- `[~1]` - используемая функция `gdk_window_restack` НЕКОРРЕКТНО
           работает под `WINDOWS`,
           реализация аналогична `LCL` но методами `GTK` ( [+] GTK2; [#] GTK3 ).
- `[~2]` - в связи с ОТСУТСТВИЕМ необходимых методов,
           реализация аналогична `LCL` но методами `Qt` ( [#] Qt4; [+] Qt5 ).
- `[~3]` - в связи с ОТСУТСТВИЕМ необходимых методов,
           реализация аналогична `LCL` но методами `Qt` ( [+] Qt4; [+] Qt5 ).



## Применение

1. Клонируйте или копируйте содержимое репозитория в папку `%SomeDIR%`.
2. В параметрах проекта укажите `%SomeDIR%` в [путях поиска][s1].
3. Использование в коде:

     ```pascal    
        uses ...
             bringToSecond,
             ...;
        
        ..
        bringToSecond(myForm);
        ..
     ```



## ДЕМО

Готовый для исследования пример смотрите в репрозитории [проекта][D].



[1]:  http://wiki.lazarus.freepascal.org/Unit
[2]:  http://wiki.lazarus.freepascal.org
[3]:  http://wiki.lazarus.freepascal.org/LCL
[s1]: http://wiki.lazarus.freepascal.org/IDE_Window:_Project_Options#Other_Unit_Files 
[D]:  https://github.com/in0k-pas-prj/in0kPRJ-bringToSecondPlane






