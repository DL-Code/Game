#version 140
uniform sampler2D textures;
in  vec2  ex_texcoord;
out vec4 out_colour;
void main(void)
{
	vec4 texcolour = texture(textures,ex_texcoord);
   if (texcolour.a<0.5){
   discard;
   }
	out_colour = texcolour;
}