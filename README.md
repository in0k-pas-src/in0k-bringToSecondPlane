# in0k-bringToSecondPlane

Move the window (`tForm`) to the SECOND position in the `Z-Order' list of application windows.

#### Scheme of work

     Z-Index                                                       
                                                                   
    TOP   Wnd00              +-> Wnd_A                        Wnd_A
     1    Wnd01              |   Wnd00                  +---> Wnd_B
     2     ...               |   Wnd01                  |     Wnd00
     3     ...               |    ...                   |     Wnd01
    ...    ...               |    ...                   |          
     N    Wnd_A.bringToFront-^    ...                   |          
     M     ...                   Wnd_B.bringToSecond----^          
    ...    ...                    ...                              
    ...............................................................
    DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop DeskTop


#### Composition
* `in0k_bringToSecondPlane_LazLCL.pas` cross-platform version.
   * The functionality of the `bring to Second` procedure is achieved by a sequential call `Wnd_B.bringToFront; Wnd_A.bringToFront`.
   * `+` Should work on ALL platforms. 
   * `-` Periodically noticeable characteristic flickering of the interface. 
* `in0k_bringToSecondPlane_WinAPI.pas` widgetSet `LCLWin32`, `LCLWin64`. 
   * `+`no flicker.
* `in0k_bringToSecondPlane_lclGtk2.pas` widgetSet `LCLgtk2`.
   * `+` no flicker.
* `in0k_bringToSecondPlane.pas` **general** version. If possible use
   **native** implementation for the target platform. If there is no implementation, 
   it is a cross-platform option.

#### Setup
Special installation **NO** required.

* Copy the contents of the repository to your local folder `%SomeDIR%`.
* Specify `%SomeDIR%` in the project search paths.
* In the `uses` section, add `in0k_bringToSecondPlane` or one of the implementations.


#### UI test as an example of use

The project `demo/uiDemoTEST.lpi` is an example of using this "library".
