Dim Shared As Integer xres,yres
dim shared as long fps
#Include "fbgfx.bi"
#Include "GL/glu.bi"
#include "GL/glext.bi"
#Include "M_GL.bi"

Sub _log(ByRef text As String = "", flag As BOOLEAN = TRUE)
	Dim As Integer fn = FreeFile
	Open Cons For Output As #fn
	Print #fn, text;
	If flag Then Print #fn, ""
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

Sub Setup_Widow(x As Integer=640, y As Integer=480)
using fb
screencontrol SET_GL_2D_MODE ,OGL_2D_MANUAL_SYNC
ScreenRes x,y,32,,GFX_OPENGL
width x\8,y\16 'larger fonts
Screeninfo xres,yres
glShadeModel(GL_SMOOTH)                 ' Enables Smooth Color Shading
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) 
glEnable(GL_DEPTH_TEST)
glDepthFunc(GL_LEQUAL)
glEnable(GL_NORMALIZE)
glViewport(0, 0, xres, yres)       ' Set the viewport
glMatrixMode(GL_PROJECTION)        ' Change Matrix Mode to Projection
glLoadIdentity                     ' Reset View
gluPerspective(45.0, xres/yres, 1.0, 100.0) 
glMatrixMode(GL_MODELVIEW)         ' Return to the modelview matrix
glEnable gl_texture_2d                        '' Depth Buffer Setup
glLoadIdentity                     '  Reset View
glClearColor 0.2,0.2,0.2,1.0

#Macro glBindProc( n )
n = screenGLProc( #n )
#endmacro
glBindProc( glGenVertexArrays )
glBindProc( glBindVertexArray )
glBindProc( glGenBuffers )
glBindProc( glBindBuffer )
glBindProc( glBufferData )
glBindProc( glEnableVertexAttribArray )
glBindProc( glDisableVertexAttribArray )
glBindProc( glVertexAttribPointer )
glBindProc( glCreateShader )
glBindProc( glShaderSource )
glBindProc( glCompileShader )
glBindProc( glGetShaderiv )
glBindProc( glGetShaderInfoLog )
glBindProc( glDeleteShader )
glBindProc( glCreateProgram )
glBindProc( glAttachShader )
glBindProc( glLinkProgram )
glBindProc( glDetachShader )
glBindProc( glGetProgramiv )
glBindProc( glGetProgramInfoLog )
glBindProc( glUseProgram )
glBindProc( glDeleteProgram )
glBindProc( glDeleteBuffers )
glBindProc( glDeleteVertexArrays )
glBindProc( glGetUniformLocation )
glBindProc( glUniform1f )
glBindProc( glUniform1i )
glBindProc( glUniform2f )
glBindProc( glUniform2fv )
glBindProc( glUniform3fv )
glBindProc( glActiveTexture )
glBindProc( glUniformMatrix3fv )
glBindProc( glDrawArraysInstanced )
glBindProc( glValidateProgram )
glBindProc( glGetAttribLocation )
glBindProc( glUniformMatrix4fv )
End Sub 

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

Type M_DataMesh 
	As v3f M_Vertex, M_Normal
	As v2f M_TexCoord
End Type


#Include "M_2D.bi"
#Include "M_Texture.bi"
#Include "M_Material.bi"
#Include "M_Mesh.bi
#Include "M_Light.bi"
#Include "main.bas"