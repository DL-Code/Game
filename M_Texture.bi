#Include "bmpload.bi"

Type _M_Texture
	As UInteger t_id
	Declare function _LoadTextures( FileName As string,  flag As Byte =0) as UInteger
End Type



function _M_texture._LoadTextures(FileName As string,  flag As Byte =0) as uinteger
  dim Status as integer = false                     '' Status Indicator
  dim TextureImage(0) as BITMAP_RGBImageRec ptr     '' Create Storage Space For The Texture

  ' Load The Bitmap, Check For Errors, If Bitmap's Not Found Quit
TextureImage(0) = LoadBMP(FileName)
If TextureImage(0) then
    _log("Loading texture comlite...")
    Status = true                                   '' Set The Status To TRUE
    glGenTextures 1, @this.t_id                    '' Create The Texture

    ' Create Nearest Filtered Texture
    If flag=0 Then
    glBindTexture GL_TEXTURE_2D, this.t_id
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST
    glTexImage2D GL_TEXTURE_2D, 0, 3, TextureImage(0)->sizeX, TextureImage(0)->sizeY, 0, GL_RGB, GL_UNSIGNED_BYTE, TextureImage(0)->buffer
    EndIf
    ' Create Linear Filtered Texture
    If flag=1 Then
    glBindTexture GL_TEXTURE_2D, this.t_id
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR
    glTexImage2D GL_TEXTURE_2D, 0, 3, TextureImage(0)->sizeX, TextureImage(0)->sizeY, 0, GL_RGB, GL_UNSIGNED_BYTE, TextureImage(0)->buffer
    EndIf
    ' Create MipMapped Texture
    If flag=2 Then
    glBindTexture GL_TEXTURE_2D, this.t_id
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR
    glTexParameteri GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST
    gluBuild2DMipmaps GL_TEXTURE_2D, 3, TextureImage(0)->sizeX, TextureImage(0)->sizeY, GL_RGB, GL_UNSIGNED_BYTE, TextureImage(0)->buffer
    EndIf
End if

  if TextureImage(0) then                           '' If Texture Exists
    if TextureImage(0)->buffer then                 '' If Texture Image Exist
      deallocate(TextureImage(0)->buffer)           '' Free The Texture Image Memory
    end if
    deallocate(TextureImage(0))                     '' Free The Image Structure
  end if

  return this.t_id                                     '' Return The Status
end Function