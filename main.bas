Dim shared test As _M_Mesh
Dim shared test2 As _M_Mesh
Dim Shared xag As Integer

sub start()
	Setup_Widow(1024, 512)
	test._LoadMesh("2")
	test._Position(0,-1,-5)
	test2._LoadMesh("house")
	test2._Position(0,-2,-5)
End Sub
 
Sub Update()
		test._rotation(0,xag,0)
		test2._rotation(0,-xag,0)
		test._Draw()
		test2._Draw()
		xag+=1
End Sub

Sub GUI(ByRef image As Any Ptr)
	   Draw string image,(20,20),"OpenGL Привет ",RGBA(255,100,0,255),, Trans
      Draw String image,(30,50),"Frames per second  = " &fps,RGBA(255,255,255,255),, Trans
End Sub
