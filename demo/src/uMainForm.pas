{$define
[Test - отметка для GitExtensions -- это ТЕСТы
}unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Interfaces,
  InterfaceBase,
  //---
  bringToSecond,
  bringToSecond_LCL,
  //----
  uTestForm,
  //----
  LazVersion,
  //bringToSecond_X11,
  LCLType, LCLIntf, LCLPlatformDef,
  SysUtils, Forms, StdCtrls, ExtCtrls, Classes;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  protected
    function  _CTRLs_get_widest_nLabel_:tLabel;
    procedure _CTRLs_btn_setLEFT_(const target:tLabel);
    function  _CTRLs_get_widest_Button_:tButton;
    procedure _CTRLs_btn_setWDTH_(const target:tButton);
    function  _CTRLs_get_widest_lCaptn_:tLabel;
    procedure _CTRLs_mem_setWDTH_(const target:tLabel);
  protected
    procedure CreateWnd; override;
  protected
    Form1:TForm;
    Form2:TForm;
    Form3:TForm;
  public
    procedure form_place(const form:TCustomForm; const indx:integer);
    procedure info_Write;
  end;

var
  MainForm: TMainForm;

implementation


//------------------------------------------------------------------------------

const
 _cTXT_Lazarus_='Lazarus';
 _cTXT_FPC_    ='FPC';
 _cTXT_Target_ ='target';
 _cDLMTR_      =':';
 _cSPACE_      =' ';


function _aboutString_:string;
begin
    result:='';
    //---
    result:=FormatDateTime('YYYYmmdd',now);
    result:=result+' ';
    //--- target
    result:=result+lowerCase({$I %FPCTARGETCPU%})+'-'+lowerCase({$I %FPCTARGETOS%})+'-'+LCLPlatformDisplayNames[GetDefaultLCLWidgetType];
    result:=result+' ';
    //--- lazarus
    result:=result+_cTXT_Lazarus_+':'+laz_version;
    result:=result+' ';
    //--- FPC
    result:=result+_cTXT_FPC_+':'+{$I %FPCVERSION%};
end;


{$R *.lfm}
//uses x, xlib , gdk2,gtk2,glib2,gdk2x;
//, qt5,qtwidgets;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin  //Form1.bringToSecond (use BringToFront [Blink?!])
    bringToSecond_LCL.bringToSecond(Form1);
    info_Write;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin //Form2.bringToSecond (try use System call)
    bringToSecond.bringToSecondppp(Form2);
    info_Write;
end;


function TMainForm._CTRLs_get_widest_nLabel_:tLabel;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Label1.Width then begin
        result:=Label1;
        w:=Label1.Width;
    end;
    if w<Label2.Width then begin
        result:=Label2;
        w:=Label2.Width;
    end;
end;

procedure TMainForm._CTRLs_btn_setLEFT_(const target:tLabel);
begin
    Button1.AnchorSideLeft.Control:=target;
    Button2.AnchorSideLeft.Control:=target;
end;

function TMainForm._CTRLs_get_widest_Button_:tButton;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Button1.Width then begin
        result:=Button1;
        w:=Button1.Width;
    end;
    if w<Button2.Width then begin
        result:=Button2;
        w:=Button2.Width;
    end;
end;

procedure TMainForm._CTRLs_btn_setWDTH_(const target:tButton);
begin
    Button1.Width:=target.Width;
    Button1.AutoSize:=false;
    Button2.Width:=target.Width;
    Button2.AutoSize:=false;
end;

function TMainForm._CTRLs_get_widest_lCaptn_:tLabel;
var w:integer;
begin
    w:=0;
    result:=nil;
    //
    if w<Label3.Width then begin
        result:=Label3;
        w:=Label3.Width;
    end;
    if w<Label4.Width then begin
        result:=Label4;
        w:=Label4.Width;
    end;
end;

procedure TMainForm._CTRLs_mem_setWDTH_(const target:tLabel);
begin
    Memo1.AnchorSideRight.Control:=target;
end;

procedure TMainForm.CreateWnd;
begin
    inherited;
    //
   _CTRLs_btn_setLEFT_(_CTRLs_get_widest_nLabel_);
   _CTRLs_btn_setWDTH_(_CTRLs_get_widest_Button_);
    //
    with _CTRLs_get_widest_lCaptn_ do
    self.Constraints.MinWidth:=Left+width;
    self.Constraints.MinHeight:=memo1.Top+self.Canvas.TextHeight('W')*5;
    //
    memo1.Constraints.MinWidth:=Canvas.TextWidth('W'+_aboutString_);
    if self.Constraints.MinWidth<memo1.Constraints.MinWidth
    then self.Constraints.MinWidth:=memo1.Constraints.MinWidth;
end;




procedure TMainForm.Button4Click(Sender: TObject);
{var //wnds:array of TWindow;
    i:integer;
var Display:PDisplay;
    r:integer;
      p:pointer;
    wnds:array [0..2] of TWindow;}
begin    //;
  {   QWidget_stackUnder
    Form3.BringToFront;   }

 {
  function DefaultScreen(dpy : PDisplay) : cint;
begin
   DefaultScreen:=(PXPrivDisplay(dpy))^.default_screen;
end;
 }

  (*  // g_mem
    //SetLength(wnds,2);
//    wnds[0]:=GDK_WINDOW_XWINDOW(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[1].Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);
   // wnds[0]:=GDK_WINDOW_XWINDOW(PGtkWidget(PtrUInt(Self.Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);
   // wnds[1]:=GDK_WINDOW_XWINDOW(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[2].Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);
   // wnds[1]:=GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[2].Handle)^.window);
    //i:=1;
    //w:=TQtWidget(self.Handle).Widget;
    //wnds[i]:=GDK_WINDOW_XID(PGtkWidget(self.Handle)^.window);
    //
   { for i:=Screen.CustomFormZOrderCount-1 downto 2 do begin
        wnds[i]:=GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[i].Handle)^.window);
            //f:=;
            //---
            //memo1.Lines.Add('z='+inttostr(i)+' ['+inttostr(Screen.CustomFormIndex(f))+'] '+f.Name);
        end;          //gdk_display:=;
    // }

//    p:=g_new(sizeof(TWindow),2) ;
    //p[0]:= GDK_WINDOW_XWINDOW(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[2].Handle))^.window)
    //p[1]:= GDK_WINDOW_XWINDOW(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[1].Handle))^.window)


    Display:= gdk_display;//GDK_WINDOW_XDISPLAY(PGtkWidget(self.Handle)^.window);
    //Display:= GDK_WINDOW_XDISPLAY(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[1].Handle))^.window);
    //p:=@ wnds[0];


    wnds[0]:=GDK_WINDOW_XID(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[2].Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);
    wnds[1]:=GDK_WINDOW_XID(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[1].Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);
    wnds[2]:=GDK_WINDOW_XID(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[1].Handle))^.window);//GDK_WINDOW_XID(PGtkWidget(Screen.CustomFormsZOrdered[1].Handle)^.window);



    wnds[0]:=GDK_WINDOW_XID(PGtkWidget(Form1.Handle)^.window);
    wnds[1]:=GDK_WINDOW_XID(PGtkWidget(Form2.Handle)^.window);
    wnds[2]:=GDK_WINDOW_XID(PGtkWidget(Form3.Handle)^.window);

    //wnds[0]:=GDK_WINDOW_XID(PGtkWidget(self.Memo1.Handle)^.window);
    //wnds[1]:=GDK_WINDOW_XID(PGtkWidget(self.Button4.Handle)^.window);
    Display:= GDK_WINDOW_XDISPLAY(PGtkWidget(self.Handle)^.window);
            //              self.Canvas.Handle:=;
    if GDK_is_WINDOW(PGtkWidget(Form3.Handle)^.window) then begin
    r:=XRaiseWindow(Display,wnds[0]);//,Screen.FormCount);
    r:=XRaiseWindow(Display,wnds[1]);//,Screen.FormCount);
    r:=XRestackWindows(Display,@wnds,3);
    end;
    //r:=XRaiseWindow(Display,wnds[1]);//,Screen.FormCount);

    caption:=inttostr(r);

    //PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[0].Handle))^.window.
      {$IFDEF LCLGTK2}
    //xid:=GDK_WINDOW_XID(widget^.window);
  {$ENDIF}



















  *)



   // gdk_


end;

procedure TMainForm.Button5Click(Sender: TObject);
(*var Display:PDisplay;
    Changes:TXWindowChanges;
    WindowAttributes:TXWindowAttributes;
    www:TWindow;
    //para3:PWindow; para4:PWindow; para5:PPWindow;
    //       para6:longword;   *)
begin
 (*

    //bringToSecond_X11.bringToSecond(Form3);
        info_Write;

    {Display:=gdk_display;// GDK_WINDOW_XDISPLAY(PGtkWidget(self.Handle)^.window);

    if
    _wndZOrder_SET_(gdk_display,
    GDK_WINDOW_XWINDOW(PGtkWidget(self.Handle)^.window),
    GDK_WINDOW_XID      (PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[3].Handle))^.window))
    then caption:='ok'
    else caption:='er';

    {www:=GDK_WINDOW_XWINDOW(PGtkWidget(self.Handle)^.window);

    XGetWindowAttributes(Display,GDK_WINDOW_XID(PGtkWidget(self.Handle)^.window),@WindowAttributes);

    changes.sibling := GDK_WINDOW_XID      (PGtkWidget(self.Handle)^.window);//TWindow(GDK_WINDOW_XID(PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[3].Handle))^.window));
    changes.stack_mode := 1;//above ? Above : Below;
  XReconfigureWMWindow (GDK_WINDOW_XDISPLAY (PGtkWidget(self.Handle)^.window),
			GDK_WINDOW_XID      (PGtkWidget(PtrUInt(Screen.CustomFormsZOrdered[3].Handle))^.window),
			_get_screenNumber_(Display, GDK_WINDOW_XID      (PGtkWidget(self.Handle)^.window)),//0,//gdk_screen_get_number (GDK_WINDOW_SCREEN (PGtkWidget(self.Handle)^.window)),
                        CWStackMode or CWSibling, @changes);

     }
   { para6:=0;
    para3:=nil;
    para4:=nil;
    para5:=nil;
    XQueryTree(Display,www,
        para3,para4,para5,@para6);  }

    }  *)
end;

(*
procedure TMainForm.Button4Click(Sender: TObject);
var Display:PDisplay;
  wnds:array of LongWord;
  w:QWidgetH;
  p:pointer;
  i:integer;
  r:integer;
begin      //ss
    Display := QX11Info_display();
    //
    SetLength(wnds,Screen.FormCount);
    //
    i:=0;
    w:=TQtWidget(self.Handle).Widget;
    wnds[i]:=QWidget_winId(w);
    //
    for i:=1 to Screen.FormCount-1 do begin // downto 1  do begin
        w:=TQtWidget(Screen.Forms[i].Handle).Widget;
        wnds[i]:=QWidget_winId(w);
    end;
    //
    p:= @wnds[0];

    //GDK_WINDOW_XDISPLAY(QWidget_winId)

    r:=XRestackWindows(Display,p,Screen.FormCount);
    caption:=inttostr(r);

    //self.
    //DefaultScreen
    //WidgetSet.;

  //XRestackWindows();
  //$IFDEF LCLQT}
  {begin
  //xid -id иксового окна
  //QWidgetH(AWidget) - QT-Виджет соответствующий хэндлу AWidget
    xid:= QWidget_winId(QWidgetH(AWidget));
    hWidget:= AWidget;
  end; }


  {$IFDEF LCLGTK2}
    xid:=GDK_WINDOW_XID(widget^.window);
  {$ENDIF}

  //    bringToSecond.bringToSecondppp(Form3);
  // WidgetSet.LCLPlatform;
end;  *)

procedure TMainForm.FormActivate(Sender: TObject);
begin
    info_Write;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    {$ifOpt D+}
    Button2.ShowHint:=true;
    Button2.Hint:=cBringToSecondUNIT+'.'+Button2.Caption;
    {$endIf}
    //
    Form1:=tTestForm.Create(Application);
    Form2:=tTestForm.Create(Application);
    Form3:=tTestForm.Create(Application);
end;

procedure TMainForm.info_Write;
var i:integer;
    f:TCustomForm;
begin
    memo1.Lines.BeginUpdate;
    memo1.Lines.Clear;
    memo1.Lines.Add(_aboutString_);
    //---
    for i:=0 to Screen.CustomFormZOrderCount-1 do begin
        f:=Screen.CustomFormsZOrdered[i];
        //---
        memo1.Lines.Add('['+inttostr(i)+'] F.Index='+inttostr(Screen.CustomFormIndex(f))+' '+' '+f.ClassName+'('+f.Name+')');
    end;
    //---
    memo1.Lines.EndUpdate;
end;

//------------------------------------------------------------------------------

procedure TMainForm.form_place(const form:TCustomForm; const indx:integer);
var delta:integer;
begin
    if form<>self then begin
        form.Width :=Screen.PrimaryMonitor.Width div 4;
        form.Height:=Screen.PrimaryMonitor.Height div 4;
        //---
        delta:=GetSystemMetrics(SM_CYCAPTION)*indx;
        if delta=0 then delta:=self.Canvas.GetTextHeight('H')*indx; //< это чисто для LCLgtk3
        //---
        form.Left:=Screen.PrimaryMonitor.Left+((Screen.PrimaryMonitor.Width -form.Width)  div 2)+delta;
        form.Top :=Screen.PrimaryMonitor.Top +((Screen.PrimaryMonitor.Height-form.Height) div 2)-delta;
    end;
end;

end.

