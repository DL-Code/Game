Type M_Material
	As _M_Texture tex
	As Single AMBIENT(3)
	As Single DIFFUSE(3)
	As Single SPECULAR(3)
	As Single EMISSION(3)
	As Single SHININESS(0)
	
	Declare Sub _LoadMtl(mtlname As string)
	Declare Sub _MaterialUse()
	Declare Sub _setTexture()
End Type

Sub M_Material._LoadMtl(mtlname As string)
	Dim As Integer file
	dim oneline as string * 256
	Dim tstr As String *2
	Dim texturefile As String *256
	Dim tstex As String *6
	file = FreeFile
	If (Open(mtlname, For input, as #file)<>0) then    
	_log("Loading MTL File error!")
	Else
	While Eof(file)=0
	Line input #file, oneline
	tstr = Left(oneline,2)
	tstex = Left(oneline,6)
	If tstex = "map_Kd" Then 
			Dim As String sstr =  Mid(oneline,7)
			sscanf(strptr(sstr), "%s", texturefile)
			texturefile = ExePath+"\" + texturefile
		_log("Texture "+texturefile+" file...")
	EndIf
	Select Case tstr
		Case "Ns"
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f", @this.SHININESS(0))
			If this.SHININESS(0) >128 Then this.SHININESS(0)=128
		Case "Ka"
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @this.AMBIENT(0),@this.AMBIENT(1),@this.AMBIENT(2)): this.AMBIENT(3)=1
		Case "Kd"
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @this.DIFFUSE(0),@this.DIFFUSE(1),@this.DIFFUSE(2)): this.DIFFUSE(3)=1
		Case "Ks"
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @this.SPECULAR(0),@this.SPECULAR(1),@this.SPECULAR(2)): this.SPECULAR(3)=1
			
		Case "Ke"
			Dim As String sstr =  Mid(oneline,3)
			sscanf(strptr(sstr), "%f %f %f", @this.EMISSION(0),@this.EMISSION(1),@this.EMISSION(2)): this.EMISSION(3)=1
	End Select	
	Wend
	If texturefile="" Then 
	_log("Texture not!")
	this.tex.t_id = -1
	Else
		_log("Loading texture "+texturefile)
		tex._LoadTextures(texturefile, 1)
	EndIf
	_log("Loading "+mtlname+" comlite...")
	End If
End Sub


Sub M_Material._MaterialUse()
	glMaterialfv(GL_FRONT, GL_AMBIENT, @this.AMBIENT(0)) 
	glMaterialfv(GL_FRONT, GL_DIFFUSE, @this.DIFFUSE(0)) 
	glMaterialfv(GL_FRONT, GL_SPECULAR, @this.SPECULAR(0))
	glMaterialfv(GL_FRONT, GL_EMISSION, @this.EMISSION(0))  
	glMaterialfv(GL_FRONT, GL_SHININESS, @this.SHININESS(0))
End Sub


Sub M_Material._setTexture()
	glBindTexture GL_TEXTURE_2D, this.tex.t_id
End Sub





