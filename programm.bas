#Include "crt/stdio.bi"
#Include "core.bi"
using fb
screencontrol SET_GL_2D_MODE ,OGL_2D_MANUAL_SYNC
'screencontrol SET_GL_SCALE,1

Dim Shared As Integer xres,yres
Screenres 1024,512,32,,GFX_OPENGL
width 1024\8,512\16 'larger fonts
Screeninfo xres,yres
#Include "albom_font.bi"


glShadeModel(GL_SMOOTH)                 ' Enables Smooth Color Shading
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) 
glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA)
glEnable GL_ALPHA
glEnable GL_BLEND
glViewport(0, 0, xres, yres)       ' Set the viewport
glMatrixMode(GL_PROJECTION)        ' Change Matrix Mode to Projection
glLoadIdentity                     ' Reset View
gluPerspective(45.0, xres/yres, 1.0, 100.0) 
glMatrixMode(GL_MODELVIEW)         ' Return to the modelview matrix
glEnable gl_texture_2d                        '' Depth Buffer Setup
glLoadIdentity                     '  Reset View
glClearColor 0,0,0,0

'NOW START OPENGL

start()
Dim As Single angle
dim as long fps
Do
      glClear(GL_COLOR_BUFFER_BIT)
'=========3d==================  
      glEnable (GL_CULL_FACE)
		Update()'draw scene
      gldisable (GL_CULL_FACE)
'=========2d==================    
  		Color(,RGBA(0,0,0,0))
      cls
      glcolor3ub 255,255,255  'reset
' draw gui
      draw string (20,20),"OpenGL cube with FreeBASIC ball and text",rgb(255,100,0)
      draw string (30,50),"Frames per second  = " &fps,rgb(255,255,255)
'=============================   
    glMatrixMode GL_MODELVIEW
    glPushMatrix
    Flip
    glMatrixMode GL_PROJECTION
    glPopMatrix
    glMatrixMode GL_MODELVIEW
    Sleep regulate(30,fps),1
Loop Until Inkey=Chr(27)