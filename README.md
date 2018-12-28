# in0k-bringToSecondPlane

[Units][1] for use in [Lazarus][2] [LCL][3].

##

Move the window (`tForm`) to the SECOND position in the Z-Order list of 
application windows. 


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


## Usage

* Ready example in the project `demo/uiDemoTEST.lpi`

* Example of usage in code

     ```pascal    
        uses ...
             in0k_bringToSecondPlane,
             ...;
        
        ..
        bringToSecond(myForm);
        ..
     ```    
        

## Installation
1. Copy or clone the contents of the repository to your folder `%SomeDIR%`.
2. In the project settings, specify the folder `%SomeDIR%` 
   in [other unit files][s1].


## Structure
* `in0k_bringToSecondPlane.pas` **generalized** version. 
   If possible, use a **native** implementation for the target platform. 
   If there is no implementation, it is a cross-platform version.
* `in0k_bringToSecondPlane_LazLCL.pas` cross-platform version
   * The functionality of the procedure `bringToSecond` 
     achieved by sequential call `Wnd_B.bringToFront; Wnd_A.bringToFront`
   * `+` should work on ALL platforms
   * `-` periodically noticeable characteristic flickering of the interface 
* `*` `in0k_bringToSecondPlane_WinAPI.pas` widgetset **LCLWin32**, **LCLWin64**
* `*` `in0k_bringToSecondPlane_lclGtk2.pas` widgetset **LCLgtk2**
* `*` `in0k_bringToSecondPlane_lclGtk3.pas` widgetset **LCLgtk3**

###### notes

 * `*` - no interface flicker.

[1]: http://wiki.lazarus.freepascal.org/Unit
[2]: http://wiki.lazarus.freepascal.org
[3]: http://wiki.lazarus.freepascal.org/LCL
[s1]: http://wiki.lazarus.freepascal.org/IDE_Window:_Project_Options#Other_Unit_Files 
