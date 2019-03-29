Type _M_2D
	As UInteger data_id, index_id 
	As gluint screenbuf
	As UInteger index(4)={0,1,2,3}
	'=========shader=========
	As Single matrixpoj(15)
	As Single matrixview(15)
	As UInteger uniform_proj 
	As UInteger uniform_view
	As shader_prog shader
	As UInteger attrib_pos
	As UInteger attrib_tex
	As UInteger attrib_norm
	As UInteger uniform_tex
	'========================
	Declare Constructor (sx As Integer, sy As Integer)
	Declare Function _set(image As Any Ptr) As UInteger
	Declare Function _Draw(image As Any Ptr) As integer
End Type

Constructor _M_2D(sx As Integer, sy As Integer)
glGenTextures(1, @this.screenbuf)
dim 	As single meshdata(32) = { 0,sy,0,0,0,1, 0,1 ,sx,sy,0,0,0,1, 1,1 ,sx,0,0,0,0,1, 1,0 ,0,0,0,0,0,1, 0,0}
  _log("[Gui init]")
load_shader_prog(this.shader, exepath + "\gui.vert", exepath + "\gui.frag")
this.attrib_pos = glGetAttribLocation(this.shader.prog, StrPtr("position"))
this.attrib_norm = glGetAttribLocation(this.shader.prog, StrPtr("normal"))
this.attrib_tex = glGetAttribLocation(this.shader.prog, StrPtr("texcoord"))
this.uniform_tex = glGetUniformLocation(this.shader.prog, StrPtr("textures"))
this.uniform_proj = glGetUniformLocation(this.shader.prog, StrPtr("projection"))
this.uniform_view = glGetUniformLocation(this.shader.prog, StrPtr("modelview"))

glGenBuffers(1, @this.data_id)
glBindBuffer(GL_ARRAY_BUFFER, this.data_id)
glBufferData(GL_ARRAY_BUFFER, sizeof(single)*UBound(meshdata), @meshdata(0), GL_STATIC_DRAW)
glGenBuffers(1, @this.index_id )	
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER , this.index_id )
glBufferData(GL_ELEMENT_ARRAY_BUFFER , sizeof(UInteger)*UBound(this.index), @this.index(0), GL_STATIC_DRAW)
glBindBuffer(GL_ARRAY_BUFFER, 0)
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0)
_log("[Gui init complite]")
End Constructor

Function _M_2D._set(image As Any Ptr) As UInteger
		glBindTexture( GL_TEXTURE_2D, this.screenbuf )
		glTexImage2D( GL_TEXTURE_2D, 0, 4, Cast(fb.image Ptr, image)->Width, Cast(fb.image Ptr, image)->height, 0, GL_BGRA, GL_UNSIGNED_BYTE, image+Sizeof(fb.image) )
		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)
		
End Function

Function _M_2D._Draw(image As Any Ptr ) As Integer
	 glPushMatrix
    glTranslatef(0,0,0)
    	glBindTexture( GL_TEXTURE_2D, this.screenbuf )
		glTexImage2D( GL_TEXTURE_2D, 0, 4, Cast(fb.image Ptr, image)->Width, Cast(fb.image Ptr, image)->height, 0, GL_BGRA, GL_UNSIGNED_BYTE, image+Sizeof(fb.image) )
		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST )
		glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST )
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)
	 glUseProgram(this.shader.prog)
	glBindBuffer(GL_ARRAY_BUFFER, this.data_id)
	glVertexAttribPointer(this.attrib_pos, 3, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(0))
	glEnableVertexAttribArray(this.attrib_pos)
	glVertexAttribPointer(this.attrib_norm, 3, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(3 * SizeOf(GLfloat)))
	glEnableVertexAttribArray(this.attrib_norm)
	glVertexAttribPointer(this.attrib_tex, 2, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(6 * SizeOf(GLfloat)))
	glEnableVertexAttribArray(this.attrib_tex)
	glGetFloatv( GL_PROJECTION_MATRIX, @this.matrixpoj(0) )
	glGetFloatv( GL_MODELVIEW_MATRIX, @this.matrixview(0) )
	glUniformMatrix4fv(this.uniform_proj, 1, GL_FALSE, @this.matrixpoj(0))
	glUniformMatrix4fv(this.uniform_view, 1, GL_FALSE, @this.matrixview(0))
	glActiveTexture(GL_TEXTURE0)
	glBindTexture(GL_TEXTURE_2D, this.screenbuf)
	glUniform1i(this.uniform_tex, 0)
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this.index_id)
	glDrawElements(GL_QUADS, UBound(this.index), GL_UNSIGNED_INT, 0)
	glBindBuffer(GL_ARRAY_BUFFER, 0)
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0)
	glUseProgram(0)
	glDisableVertexAttribArray(this.attrib_pos)
	glDisableVertexAttribArray(this.attrib_tex)
	 glPopMatrix
End Function

