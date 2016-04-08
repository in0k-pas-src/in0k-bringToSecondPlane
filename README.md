# in0k-bringToSecondPlane

Пеперместить окно (`tForm`) по последовательности Z-Order непосредственно под
активное (окно которое в данный момент владеет фокусом).


#### Схема работы функции на примере

     Z-Index
     
     0    Wnd00              +-> Wnd_A                        Wnd_A
     1    Wnd01              |   Wnd00                    +-> Wnd_B
     2     ...               |   Wnd01                    |   Wnd00
     3     ...               |    ...                     |   Wnd01
    ...    ...               |    ...                     |
     N    Wnd_A.bringToFront-^    ...                     |
	 M     ...                   Wnd_B.bringToSecondPlane-^
    ...    ...                    ...
    ...............................................................
    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop


#### Особенности реализации

* `in0k_bringToSecondPlane_LazLCL`
   реализует функционал посредством СТАНДАРТНЫх операций `bringToFront`
   * `+` мультиплатформенно
   * `-` приводит к мерцанию интерфейса

* `in0k_bringToSecondPlane_WinAPI`
   используются вызовы `WinAPI`
   * `+` интерфейс НЕ мерцает
   * `-` ограничение по применению

