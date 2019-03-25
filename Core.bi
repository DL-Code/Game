Sub _log(ByRef text As String = "")
	Dim As Integer fn = FreeFile
	Open Cons For Output As #fn
	Print #fn, text
	Close #fn
End Sub

Function Regulate(Byval MyFps As long,Byref fps As long) As long
    Static As Double timervalue,lastsleeptime,t3,frames
    Dim As Double t=Timer
    frames+=1
    If (t-t3)>=1 Then t3=t:fps=frames:frames=0
    Dim As long sleeptime=lastsleeptime+((1/myfps)-T+timervalue)*1000
    If sleeptime<1 Then sleeptime=1
    lastsleeptime=sleeptime
    timervalue=T
    Return sleeptime
End Function

Const pi_180 = 0.0174532925f
	
Type v3f
	 As Single x,y,z
End Type

Type v2f
	 As Single x,y
End Type

Type c4f
	As Single r,g,b,a
End Type

#Include "fbgfx.bi"
#Include "GL/glu.bi"
#include "GL/glext.bi"
#Include "M_Texture.bi"
#Include "M_Material.bi"
#Include "M_Mesh.bi
#Include "M_Light.bi"
#Include "main.bas"