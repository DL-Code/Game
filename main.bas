Dim shared test As _M_Mesh

sub start()
	test._LoadMesh("monstr")
End Sub
 
Sub Update()
	test._Draw()
End Sub
