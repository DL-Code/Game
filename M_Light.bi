Type _M_Light
	
	 as single LightPos(0 to 3) => {1.0, 1.0, 1.0, 0.0}     '' Light Position
	 as single LightAmb(0 to 3) => {0.01, 0.01, 0.01, 0.01}      '' Ambient Light Values
	 as single LightDif(0 to 3) => {1, 1, 1, 1}      '' Diffuse Light Values
	 as single LightSpc(0 to 3) => {1, 1, 1, 1}   '' Specular Light Values
	
	Declare Sub _Point()
	Declare Sub _Light_Render()

End Type

Sub _M_Light._Point()
	glLightfv(GL_LIGHT0, GL_POSITION, @this.LightPos(0))       '' Set Light1 Position
	glLightfv(GL_LIGHT0, GL_AMBIENT, @this.LightAmb(0))        '' Set Light1 Ambience
	glLightfv(GL_LIGHT0, GL_DIFFUSE, @this.LightDif(0))        '' Set Light1 Diffuse
	glLightfv(GL_LIGHT0, GL_SPECULAR, @this.LightSpc(0))       '' Set Light1 Specular
	glEnable(GL_LIGHT0)                                   '' Enable Light1
End Sub

Sub _M_Light._Light_Render()
	glEnable(GL_LIGHTING)
End Sub


