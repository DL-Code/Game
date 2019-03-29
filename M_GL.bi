#Include "GL/gl.bi"
#Include "GL/glu.bi"
#include "GL/glext.bi"

Type shader_prog
	As Uinteger prog ' Shader program
	As UInteger vert ' Vertex shader
	As UInteger frag ' Fragment shader
End Type



#Macro M_Shared( n )
Dim shared as PFN##n##PROC n
#endmacro
M_Shared( glGenVertexArrays )
M_Shared( glBindVertexArray )
M_Shared( glGenBuffers )
M_Shared( glBindBuffer )
M_Shared( glBufferData )
M_Shared( glEnableVertexAttribArray )
M_Shared( glDisableVertexAttribArray )
M_Shared( glVertexAttribPointer )
M_Shared( glCreateShader )
M_Shared( glShaderSource )
M_Shared( glCompileShader )
M_Shared( glGetShaderiv )
M_Shared( glGetShaderInfoLog )
M_Shared( glDeleteShader )
M_Shared( glCreateProgram )
M_Shared( glAttachShader )
M_Shared( glLinkProgram )
M_Shared( glDetachShader )
M_Shared( glGetProgramiv )
M_Shared( glGetProgramInfoLog )
M_Shared( glUseProgram )
M_Shared( glDeleteProgram )
M_Shared( glDeleteBuffers )
M_Shared( glDeleteVertexArrays )
M_Shared( glGetUniformLocation )
M_Shared( glUniform1f )
M_Shared( glUniform1i )
M_Shared( glUniform2f )
M_Shared( glUniform2fv )
M_Shared( glUniform3fv )
M_Shared( glActiveTexture )
M_Shared( glUniformMatrix3fv )
M_Shared( glDrawArraysInstanced )
M_Shared( glValidateProgram )
M_Shared( glGetAttribLocation )
M_Shared( glUniformMatrix4fv )


#Define BUFFER_OFFSET(value) Cast(GLvoid Ptr, (value))

#Define error_log make_log "Error in function " & __FUNCTION__ & ". " &
#Define error_alloc error_log "Failed to allocate memory"
Declare Sub make_log(ByRef text As String = "")
Declare Function load_shader_prog(ByRef shader As shader_prog, ByRef vert_filename As String, ByRef frag_filename As String) As Integer
Declare Function load_shader_prog_part1(ByRef shader As shader_prog, ByRef vert_filename As String, ByRef frag_filename As String) As Integer
Declare Function load_shader_prog_part2(ByRef shader As shader_prog) As Integer
Declare Sub unload_shader_prog(ByRef shader As shader_prog)

Declare Function load_text_tile(ByRef filename As String, ByRef zstring_ptr As ZString Ptr) As Integer


Sub make_log(ByRef text As String = "")
	Dim As Integer fn = FreeFile
	Open Cons For Output As #fn
	Print #fn, text
	Close #fn
End Sub

Function load_shader_prog(ByRef shader As shader_prog, ByRef vert_filename As String, ByRef frag_filename As String) As Integer
	If load_shader_prog_part1(shader, vert_filename, frag_filename) Then Return -1
	If load_shader_prog_part2(shader) Then Return -1
	Return 0
End Function
Function load_shader_prog_part1(ByRef shader As shader_prog, ByRef vert_filename As String, ByRef frag_filename As String) As Integer
	With shader

		' Define variables
		Dim As GLuint check_success
		Dim As String text
		Dim As ZString Ptr vert_src, frag_src
		Dim As UInteger i, fn

		' Load shader source code from file
		If load_text_tile(vert_filename, vert_src) OrElse _
			load_text_tile(frag_filename, frag_src) Then
			If vert_src Then DeAllocate vert_src
			If frag_src Then DeAllocate frag_src
			Return -1
		EndIf

		' Create shaders
		.prog = glCreateProgram()
		.vert = glCreateShader(GL_VERTEX_SHADER)
		.frag = glCreateShader(GL_FRAGMENT_SHADER)

		' Load shader source code into shader
		glShaderSource(.vert, 1, @vert_src, NULL)
		glShaderSource(.frag, 1, @frag_src, NULL)
		DeAllocate vert_src
		DeAllocate frag_src
		vert_src = 0
		frag_src = 0

		' Compile shaders
		glCompileShader(.vert)
		glCompileShader(.frag)

		' Check for errors
		glGetShaderiv(.vert, GL_COMPILE_STATUS, @check_success)
		If check_success = GL_FALSE Then

			' Get the length of the error message
			Dim As Gluint length
			glGetShaderiv(.vert, GL_INFO_LOG_LENGTH, @length)

			' Get the error message
			Dim As GlByte text(0 To length)
			glGetShaderInfoLog(.vert, length, 0, @text(0))

			' Display message
			error_log "Failed to setup vertex shader." & Chr(13, 10) & "File: " & vert_filename & Chr(13, 10) & *Cast(ZString Ptr, @text(0))

			' Clean up and return failure
			unload_shader_prog(shader)
			Return -1

		EndIf
		glGetShaderiv(.frag, GL_COMPILE_STATUS, @check_success)
		If check_success = GL_FALSE Then

			' Get the length of the error message
			Dim As Gluint length
			glGetShaderiv(.frag, GL_INFO_LOG_LENGTH, @length)

			' Get the error message
			Dim As GlByte text(0 To length)
			glGetShaderInfoLog(.frag, length, 0, @text(0))

			' Display message
			error_log "Failed to setup fragment shader." & Chr(13, 10) & "File: " & frag_filename & Chr(13, 10) & *Cast(ZString Ptr, @text(0))

			' Clean up and return failure
			unload_shader_prog(shader)
			Return -1

		EndIf

		' Attach shaders to shader program
		glAttachShader(.prog, .vert)
		glAttachShader(.prog, .frag)

		' Return success
		Return 0

	End With
End Function
Function load_shader_prog_part2(ByRef shader As shader_prog) As Integer
	With shader

		' Define variables
		Dim As GLuint check_success

		' Link shader program
		glLinkProgram(.prog)

		' Final error check
		glValidateProgram(.prog)
		glGetProgramiv(.prog, GL_VALIDATE_STATUS, @check_success)
		If check_success = GL_FALSE Then

			' Get the length of the error message
			Dim As Gluint length
			glGetProgramiv(.prog, GL_INFO_LOG_LENGTH, @length)

			make_log "length " & length

			' Get the error message
			Dim As GlByte text(0 To length)
			glGetProgramInfoLog(.prog, length, 0, @text(0))

			' Display message
			error_log "Failed to validate shader program:" & Chr(13, 10) & *Cast(ZString Ptr, @text(0))

			' Clean up and return failure
			unload_shader_prog(shader)
			Return -1

		EndIf

		' Return success
		Return 0

	End With
End Function
Sub unload_shader_prog(ByRef shader As shader_prog)
	With shader
		If .vert Then
			glDeleteShader(.vert)
			.vert = 0
		EndIf
		If .frag Then
			glDeleteShader(.frag)
			.frag = 0
		EndIf
		If .prog Then
			glDeleteProgram(.prog)
			.prog = 0
		EndIf
	End With
End Sub

' Load file to ZString Ptr
' Returns zero on success, -1 on failure
Function load_text_tile(ByRef filename As String, ByRef zstring_ptr As ZString Ptr) As Integer
	Dim As Integer fn
	Dim As UInteger i

	' Open File
	fn = FreeFile
	If Open(filename For Input As #fn) Then
		error_log "Failed to open file: " & filename
		Return -1
	EndIf

	' Get length of file
	i = Lof(fn)
	If i < 1 Then
		error_log "File is empty: " & filename
		Return -1
	EndIf

	' Allocate memory
	zstring_ptr = Callocate(i)
	If zstring_ptr = 0 Then
		error_alloc
		Return -1
	EndIf

	' Copy data from file
	If Get(#fn, 1, *Cast(UByte Ptr, zstring_ptr), i) Then
		error_log "Failed to copy data from: " & filename
		Return -1
	EndIf

	' Close file
	Close #fn

	' Check data
	If *zstring_ptr = "" Then
		error_log "File was empty: " & filename
		Return -1
	EndIf

	' Return success
	Return 0
End Function

