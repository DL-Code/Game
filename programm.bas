#Include "crt/stdio.bi"
#Include "core.bi"
start()
#Include "albom_font.bi"
Do
      glClear(GL_COLOR_BUFFER_BIT OR GL_DEPTH_BUFFER_BIT)
		glEnable(GL_CULL_FACE)
		glCullFace(GL_BACK)
		glDisable(GL_BLEND)
		Update()'draw scene
      gldisable (GL_CULL_FACE)
      glDisable (GL_LIGHTING)
      glEnable (GL_BLEND)
  		Color(,RGBA(0,0,0,0))
      cls
      glcolor4ub 255,255,255,255  'reset
		GUI() 'draw gui
    glMatrixMode GL_MODELVIEW
    glPushMatrix
    Flip
    glMatrixMode GL_PROJECTION
    glPopMatrix
    glMatrixMode GL_MODELVIEW
    Sleep regulate(60,fps),1
Loop Until Inkey=Chr(27)