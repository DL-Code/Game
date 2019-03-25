
Type _M_Mesh
	As UInteger _m_id
	As UInteger _t_tex
	As M_Material material
	As v3f position
	As v3f rotation
	As v3f scale
	Declare Sub _LoadMesh(st As String)
	Declare Sub _Draw()
	Declare Sub _Rotation(x As Single, y As Single, z As Single)
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
	_log("Loading "+model+" file...")
	vercout=1
	norcout=1
	texcout=1
	facecout=3
	file = FreeFile
	if (Open(model, For input, as #file)<>0) then   
		_log("Loading OBJ File error!")
	Else

	While Eof(file)=0
	Line input #file, oneline
	mtl = Left(oneline,6)
	tstr = Left(oneline,2)
	If mtl = "mtllib" Then 
		Dim As String sstr =  Mid(oneline,7)
		sscanf(strptr(sstr), "%s", mtlf)
		mtlf = ExePath+"\" + mtlf
		_log("MTL "+mtlf+" file...")
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
	If ubound(face)>0 And ubound(texturcoor)>0 And ubound(normal)>0 And ubound(vertex)>0 Then _log("Loading "+model+" comlite...")
	Close #file
		
	_log("Loading "+mtlf+" file...")
	This.material._LoadMtl(mtlf)
	Dim As UInteger fv = 0
	Dim As UInteger fn = 0
	Dim As UInteger ft = 0
	this._m_id=glGenLists(1)
	glNewList(this._m_id,GL_COMPILE)
	glBegin(GL_TRIANGLES)
	For  i As uInteger = 0 To facecout -3
	 fv = face(i,0)
	 fn = face(i,2)
	 ft = face(i,1)
	glNormal3f(normal(fn,0),normal(fn,1),normal(fn,2))
   glTexCoord2f( texturcoor(ft,0), texturcoor(ft,1))
	glVertex3f(vertex(fv,0), vertex(fv,1), vertex(fv,2))            ' Top right of the quad (right)
	Next
	glEnd()
	glEndList()
	EndIf
	_log("##################100%######################>>>>>")
End Sub

Sub _M_Mesh._Draw()
    this.material._setTexture()
    this.material._MaterialUse()
    glPushMatrix
    glTranslatef(0,-1,-5)
    glRotatef(this.rotation.x,1,0,0)
    glRotatef(this.rotation.y,0,1,0)
    glRotatef(this.rotation.z,0,0,1)
	 glCallList(This._m_id)
	 glPopMatrix
End Sub

Sub _M_Mesh._Rotation(x As Single, y As Single, z As Single)
	
	this.rotation.x=x
	this.rotation.y=y
	this.rotation.z=z
	
End Sub





