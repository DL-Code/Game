Dim shared test As _M_Mesh
Dim shared test2 As _M_Mesh
Dim Shared As _M_light l
Dim Shared xag As Integer

sub start()
	Setup_Widow(1024, 512)
	test._LoadMesh("2")
	test._Position(0,-1,-5)
	test2._LoadMesh("house")
	test2._Position(0,-2,-5)
	l._Point()
End Sub
 
Sub Update()
		test._rotation(0,xag,0)
		test2._rotation(0,-xag,0)
		l._Light_Render()
		test._Draw()
		test2._Draw()
		xag+=1
End Sub

Sub GUI()
	   Draw string (20,20),"OpenGL Привет ",rgb(255,100,0)
      draw String (30,50),"Frames per second  = " &fps,rgb(255,255,255)
End Sub
