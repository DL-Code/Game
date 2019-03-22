Sub _log(ByRef text As String = "")
	Dim As Integer fn = FreeFile
	Open Cons For Output As #fn
	Print #fn, text
	Close #fn
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

#Include "fbgfx.bi"
#Include "GL/glu.bi"
#include "GL/glext.bi"
#Include "M_Texture.bi"
#Include "M_Material.bi"
#Include "M_Mesh.bi
#Include "M_Light.bi"