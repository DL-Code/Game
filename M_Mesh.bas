
Type M_Mesh
	As UInteger m_id
	As UInteger t_tex
	Declare Sub LoadMesh(st As String)

End Type

Sub M_Mesh.LoadMesh(st As String)
	Dim As Integer file, vercout=1, norcout=1, texcout=1, facecout=3
	'Dim As mesh tmodel

	Dim vertex() As Single
	Dim normal() As Single
	Dim texturcoor() As Single
	Dim face() As UInteger
	Dim tstr As String *2
	dim oneline as string * 256
	Dim As String model = exepath + st
	'Dim As String textur = exepath + "/res/image/"+st+".bmp"
	'Dim d As String = Dir(model+"*.obj",32)
	'this.collisions.M_LoadColider(st)

	vercout=1
	norcout=1
	texcout=1
	facecout=3

	file = FreeFile
	if (Open(model, For input, as #file)<>0) then   End If 
	While Eof(file)=0
	line input #file, oneline
	tstr = Left(oneline,2)
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
	Close #file
	
	
	this.m_id=glGenLists(1)
	glNewList(this.m_id,GL_COMPILE)
	glBegin(GL_TRIANGLES)
	For Integer i = 1 To facecout -3
	Dim UInteger fv = face(i,0)
	Dim UInteger fn = face(i,1)
	Dim UInteger ft = face(i,2)
	glVertex3f(vertex(fv,0), vertex(fv,1), vertex(fv,2))            ' Top right of the quad (right)
   glNormal3f(normal(fn,0),normal(fnt,1),normal(fn,2))
   glTexCoord2f( texturcoor(ft,0), texturcoor(ft,1))
	Next
	glEnd()
	glEndList()
End Sub

Sub M_Mesh.Draw()
	
	glCallList(This.m_id)
	
End Sub
