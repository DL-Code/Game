#include "crt/stdio.bi"
#Include "core.bi"


Enum
    opengl      = 2
    fullscreen  = 1
End Enum
windowtitle "Тест русского языка"
Dim As UInteger gui
Dim Shared As Integer xres,yres
ScreenRes 1024,768,32,,opengl
Width 1024\8,512\16 'larger fonts
Screeninfo xres,yres
#Include "albom_font.bi"
'Simple structure just to hold corners of one quad
Type pair
    As single x,y
End Type
Operator *(x As Double,n As pair) As pair
Return Type<pair>(x*n.x,x*n.y)
End Operator




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

'Set a Quad to hold image
Sub setbackgroundquad(e() As pair)
    Dim As Single r1=xres/yres,r2=1 'same ratio as screen
    Dim As Single n=1 'left open for a fiddle around
    e(4)=n*Type(-r1,r2)
    e(3)=n*Type(r1,r2)
    e(2)=n*Type(r1,-r2)
    e(1)=n*Type(-r1,-r2)
End Sub
'draw the quad
Sub DrawBackGroundQuad(e() As pair, tex As UInteger)

   Dim as integer w, h
	ScreenInfo w, h
    
		glBindTexture( GL_TEXTURE_2D, tex )
    Dim As Single n=1
    
    glTranslatef(0,0,0) 'adjust the z translate for a good fit
    glbegin gl_quads
    glTexCoord2f( 0,0 )
    glVertex3f(0,0,0)'(e(1).x,e(1).y,0)
    glTexCoord2f( 0,n )
    glVertex3f(0,h,0)'(e(2).x,e(2).y,0)
    glTexCoord2f( n,n )
    glVertex3f(w,h,0)'(e(3).x,e(3).y,0)
    glTexCoord2f( n,0 )
    glVertex3f(w,0,0)'(e(4).x,e(4).y,0)
    glend
End Sub

Sub glsetup
	
    glShadeModel(GL_SMOOTH)                 ' Enables Smooth Color Shading
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
	 glClearDepth 1.0     
	 glCullFace(GL_BACK)                          '' Set Culling Face To Back Face
	 glEnable(GL_CULL_FACE)
	 glEnable gl_texture_2d                        '' Depth Buffer Setup
	 'glEnable GL_DEPTH_TEST
    'glBlendFunc (GL_ONE,GL_ONE)'_MINUS_SRC_ALPHA )
    'glEnable GL_ALPHA
    'glAlphaFunc(GL_GEQUAL,0.1)
    'glEnable(GL_ALPHA_TEST)     
    glEnable GL_BLEND
    glViewport(0, 0, xres, yres)       ' Set the viewport
    glMatrixMode(GL_PROJECTION)        ' Change Matrix Mode to Projection
    glLoadIdentity                     ' Reset View
    gluPerspective(45.0, xres/yres, 1.0, 100.0)
    glMatrixMode(GL_MODELVIEW)         ' Return to the modelview matrix
    glLoadIdentity                     '  Reset View
End Sub

'Transfer FB image to OpenGL
Function settexture(image As Any Ptr) As gluint
    static As gluint texture,s
    if s=0 then glGenTextures(1, @texture):
    glBindTexture( GL_TEXTURE_2D, texture ):s=1
    glTexImage2d( GL_TEXTURE_2D, 0, 4, Cast(fb.image Ptr, image)->Width, Cast(fb.image Ptr, image)->height, 0, GL_BGRA, GL_UNSIGNED_BYTE, image+Sizeof(fb.image) )
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )
    'glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)
    Return texture
End Function



'=============== for ball only  =========
type pt
        as long x=100,y=100
        as single dx,dy
        as long kx,ky
    end type
sub ball(byref i as any ptr)
    line i,(100,100)-(400,400),rgba(0,255,0,128),bf
End sub
'===============
sub ClearImage(byref im as any ptr)
    imagedestroy im:im=0
    im=imagecreate (xres,yres,rgba(0,0,0,0),32)
end sub

'Some variables
Dim As gluint tex1
Dim As any Ptr background=Imagecreate(xres,yres,rgba(255,255,255,255),32)
Dim  As pair BackgroundCorners(1 To 4)
setbackgroundquad(BackgroundCorners())

'NOW START OPENGL
glsetup
Dim As _M_Mesh m
Dim As _M_light l
m._LoadMesh("monstr")
l._Point()
Dim As Single angle
dim as long fps
   Dim as integer w, h
	ScreenInfo w, h
	
Do

    angle=angle+0.3
    'glClear(GL_COLOR_BUFFER_BIT)
	 glClear  GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT


  
   'glDisable gl_texture_2d
   'glColor4ub 255,255,255,255
     m._Rotation(0,angle,0)
     m._Draw()
   'glColor4ub 1,1,1,1 
   
     
   'draw the background image
  	'glEnable gl_texture_2d 
   glDisable (GL_LIGHTING)
	glDisable GL_DEPTH_TEST                                         '' Disables Depth Testing
	glMatrixMode GL_PROJECTION                                      '' Select The Projection Matrix
		glLoadIdentity                                              '' Reset The Projection Matrix
		glOrtho 0, w, h, 0,-1, 1                                '' Set Up An Ortho Screen
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
			glLoadIdentity                                          '' Reset The Modelview Matrix

    
    DrawBackGroundQuad(BackgroundCorners(), tex1)
    glMatrixMode(GL_PROJECTION)        ' Change Matrix Mode to Projection
    glLoadIdentity                     ' Reset View
    gluPerspective(45.0, xres/yres, 1.0, 100.0)
    glMatrixMode(GL_MODELVIEW)         ' Return to the modelview matrix
    glLoadIdentity 
    glEnable GL_DEPTH_TEST
    
    glEnable(GL_LIGHTING)
     
   'Free basic graphics
    ClearImage(background)
    ball(background)
    Draw string background,(120,120),"Проба русского языка",RGBA(255,255,255,255),, Trans
    Draw string background,(120,140),"fps  = " &fps,RGBA(255,255,255,255),, trans
	 Draw string background,(120,160),"Фаил модели формата obj" ,RGBA(255,255,255,255),,Alpha
	 Draw string background,(120,180),"Фаил материала формата mtl" ,RGBA(255,255,255,255),,PReset
	 'Draw string background,(120,200),"Test" ,RGBA(255,255,255,196),,And
	 'Draw string background,(120,220),"Test" ,RGBA(255,255,255,128),,or
    tex1=settexture(background)
  
    'glend
    Flip
    Sleep regulate(60,fps),1
Loop Until Inkey=Chr(27)
Imagedestroy background
    