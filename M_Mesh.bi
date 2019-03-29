Type _M_Mesh

	'=========shader=========
	As Single matrixpoj(15)
	As Single matrixview(15)
	As Single matrixmodel(15)
	As UInteger uniform_proj 
	As UInteger uniform_view
	As UInteger uniform_model
	As shader_prog shader
	As UInteger attrib_pos
	As UInteger attrib_tex
	As UInteger attrib_norm
	As UInteger uniform_tex
	'========================
	As UInteger vboID
	As UInteger vboindexID
	As single meshdata(Any) 'data mesh
	As UInteger index(Any)      'index mesh data
	As M_Material material
	As v3f position
	As v3f rotation
	As v3f scale
	Declare Sub _LoadMesh(st As String)
	Declare Sub _Draw()
	Declare Sub _Rotation(x As Single, y As Single, z As Single)
	Declare Sub _Position(x As Single, y As Single, z As Single)
End Type

Sub _M_Mesh._LoadMesh(st As String)
	Dim As Integer file, vercout=1, norcout=1, texcout=1, facecout=3
	Dim vertex() As Single
	Dim normal() As Single
	Dim texturcoor() As Single
	Dim face() As UInteger
	Dim tstr As String *2
	Dim mtl As String * 6
	dim oneline as string * 256
	Dim As String model = ExePath+"\" + st+".obj"
	Dim  mtlf As String * 256
	
	vercout=1
	norcout=1
	texcout=1
	facecout=3
	Dim f As Integer = FreeFile
	If (Open (st+".m3d" For Binary Access Read As #f)) = 0 Then
		_log("[Loading cash]")
		Dim As Integer inb,meshb
	Get #f,,meshb
	ReDim this.meshdata(meshb)
	Get #f,,this.meshdata(0),meshb
	Get #f,,inb
	ReDim this.index(inb)
	Get #f,,this.index(0),inb
	Close #f
	Else
		_log("[Not cash]")
	file = FreeFile
	if (Open(model, For input, as #file)<>0) then   
		_log("[Loading OBJ File error!]")
	Else
   _log("[Loading "+model+" file]")
	While Eof(file)=0
	Line input #file, oneline
	mtl = Left(oneline,6)
	tstr = Left(oneline,2)
	If mtl = "mtllib" Then 
		Dim As String sstr =  Mid(oneline,7)
		sscanf(strptr(sstr), "%s", mtlf)
		mtlf = ExePath+"\" + mtlf
		_log("[MTL "+mtlf+" file]")
	EndIf
	Select Case tstr
		Case "v "
			ReDim Preserve vertex(vercout,3)
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @vertex(vercout,0),@vertex(vercout,1),@vertex(vercout,2))
			vercout = vercout +1
		Case "vn"
			ReDim Preserve normal(norcout,3)
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @normal(norcout,0),@normal(norcout,1),@normal(norcout,2))
			norcout = norcout +1
		Case "vt"
			ReDim Preserve texturcoor(texcout,2)
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f", @texturcoor(texcout,0),@texturcoor(texcout,1))
			texcout = texcout +1
		Case "f "
			ReDim Preserve face(facecout,3)
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%i/%i/%i %i/%i/%i %i/%i/%i", _
										 @face(facecout-3,0),@face(facecout-3,1),@face(facecout-3,2),_
										 @face(facecout-2,0),@face(facecout-2,1),@face(facecout-2,2),_
										 @face(facecout-1,0),@face(facecout-1,1),@face(facecout-1,2))
			facecout = facecout +3
	End Select
	Wend
	If ubound(face)>0 And ubound(texturcoor)>0 And ubound(normal)>0 And ubound(vertex)>0 Then _log("[Loading "+model+" comlite]")
	Close #file
		
	_log("[Loading "+mtlf+" file]")
	This.material._LoadMtl(mtlf)
	
'============== *.obj data to VBO data =======
_log("[*.obj data to VBO data "+Str(facecout-3)+" face]")
ReDim Preserve this.index(facecout-3)
ReDim Preserve this.meshdata((facecout-3)*8)
Dim As Single progress = 100/(facecout-3)
Dim As Single progs =0
For i As Integer =0 To (facecout-3)*8-1 Step 8
		progs+=progress
	If progs >=10 Then
		_log("#", FALSE )
		progs=0
	EndIf
	Dim As Integer inface = i/8
	'_log(Str(i) )
this.index(inface)=inface
this.meshdata(i)=vertex(face(inface,0),0)
this.meshdata(i+1)=vertex(face(inface,0),1)
this.meshdata(i+2)=vertex(face(inface,0),2)
this.meshdata(i+3)=normal(face(inface,2),0)
this.meshdata(i+4)=normal(face(inface,2),1)
this.meshdata(i+5)=normal(face(inface,2),2)
this.meshdata(i+6)=texturcoor(face(inface,1),0)
this.meshdata(i+7)=texturcoor(face(inface,1),1)
Next
	_log("-100%")
	' clear memory
	Erase (vertex)
	Erase (normal)
	Erase (texturcoor)
	Erase (face)
	EndIf
	EndIf
	_log("[Clear memory complite]")
load_shader_prog(this.shader, exepath + "\model.vert", exepath + "\model.frag")
this.attrib_pos = glGetAttribLocation(this.shader.prog, StrPtr("position"))
this.attrib_norm = glGetAttribLocation(this.shader.prog, StrPtr("normal"))
this.attrib_tex = glGetAttribLocation(this.shader.prog, StrPtr("texcoord"))
this.uniform_tex = glGetUniformLocation(this.shader.prog, StrPtr("textures"))
this.uniform_proj = glGetUniformLocation(this.shader.prog, StrPtr("projection"))
this.uniform_view = glGetUniformLocation(this.shader.prog, StrPtr("modelview"))
this.uniform_model = glGetUniformLocation(this.shader.prog, StrPtr("model"))

glGenBuffers(1, @this.vboId)
glBindBuffer(GL_ARRAY_BUFFER, this.vboId)
glBufferData(GL_ARRAY_BUFFER, sizeof(single)*UBound(	this.meshdata), @	this.meshdata(0), GL_STATIC_DRAW)
glGenBuffers(1, @this.vboindexID)	
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER , this.vboindexID)
glBufferData(GL_ELEMENT_ARRAY_BUFFER , sizeof(UInteger)*UBound(this.index), @this.index(0), GL_STATIC_DRAW)
glBindBuffer(GL_ARRAY_BUFFER, 0)
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0)

End Sub

Sub _M_Mesh._Draw()
    ''this.material._MaterialUse()
    glGetFloatv( GL_MODELVIEW_MATRIX, @matrixview(0) )
    glGetFloatv( GL_PROJECTION_MATRIX, @matrixpoj(0) )
    glPushMatrix
    glTranslatef(this.position.x,this.position.y,this.position.z)
    glRotatef(this.rotation.x,1,0,0)
    glRotatef(this.rotation.y,0,1,0)
    glRotatef(this.rotation.z,0,0,1)
	 glUseProgram(this.shader.prog)
	glBindBuffer(GL_ARRAY_BUFFER, this.vboId)
	glVertexAttribPointer(this.attrib_pos, 3, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(0))
	glEnableVertexAttribArray(this.attrib_pos)
	glVertexAttribPointer(this.attrib_norm, 3, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(3 * SizeOf(GLfloat)))
	glEnableVertexAttribArray(this.attrib_norm)
	glVertexAttribPointer(this.attrib_tex, 2, GL_FLOAT, GL_FALSE, SizeOf(Single)*8, BUFFER_OFFSET(6 * SizeOf(GLfloat)))
	glEnableVertexAttribArray(this.attrib_tex)
	glGetFloatv( GL_MODELVIEW_MATRIX, @matrixmodel(0) )
	glUniformMatrix4fv(this.uniform_proj, 1, GL_FALSE, @matrixpoj(0))
	glUniformMatrix4fv(this.uniform_view, 1, GL_FALSE, @matrixview(0))
	glUniformMatrix4fv(this.uniform_model, 1, GL_FALSE, @matrixmodel(0))
	glActiveTexture(GL_TEXTURE0)
	this.material._setTexture()
	glUniform1i(this.uniform_tex, 0)
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this.vboindexID)
	glDrawElements(GL_TRIANGLES, UBound(this.index), GL_UNSIGNED_INT, 0)
	glBindBuffer(GL_ARRAY_BUFFER, 0)
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0)
	glUseProgram(0)
	glDisableVertexAttribArray(this.attrib_pos)
	glDisableVertexAttribArray(this.attrib_tex)
	 glPopMatrix
End Sub

Sub _M_Mesh._Rotation(x As Single, y As Single, z As Single)
	this.rotation.x=x
	this.rotation.y=y
	this.rotation.z=z
End Sub

Sub _M_Mesh._Position(x As Single, y As Single, z As Single)
	this.position.x=x
	this.position.y=y
	this.position.z=z
End Sub





