#Include "crt/stdio.bi"
#Include "core.bi"

start()
Dim As _M_2D _GUI = _M_2D(xres,yres)
#Include "albom_font.bi"
dim  As any Ptr buffered
Do
      glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT)
		glEnable(GL_CULL_FACE)
		glCullFace(GL_BACK)
		glMatrixMode(GL_PROJECTION)        ' Change Matrix Mode to Projection
		glLoadIdentity                     ' Reset View
		gluPerspective(45.0, xres/yres, 1.0, 100.0) 
		glMatrixMode(GL_MODELVIEW)         ' Return to the modelview matrix
		glLoadIdentity    
		Update()'draw scene
		ImageDestroy buffered:buffered=0
    	buffered=imagecreate (xres,yres,rgba(0,0,0,0),32)
		GUI(buffered) 'draw gui
glMatrixMode(GL_PROJECTION)
glLoadIdentity
glViewport(0,0,xres,yres)     
glOrtho(0,xres,yres,0,-128,128)
glMatrixMode(GL_MODELVIEW)     
glEnable(GL_CULL_FACE)
glCullFace(GL_BACK)
glEnable GL_TEXTURE_2D        
glLoadIdentity
_GUI._Draw(buffered)

    glMatrixMode GL_MODELVIEW
    glPushMatrix
    Flip
    glMatrixMode GL_PROJECTION
    glPopMatrix
    glMatrixMode GL_MODELVIEW
    Sleep regulate(60,fps),1
Loop Until Inkey=Chr(27)
