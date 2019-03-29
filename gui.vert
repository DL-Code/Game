#version 140
uniform mat4 projection;
uniform mat4 modelview;
in  vec3 position;
in  vec3 normal;
in  vec2 texcoord;
out vec2 ex_texcoord;
out vec4 vFinalColor;

void main()
{


		gl_Position =  projection * modelview *vec4(position, 1.0); 
		ex_texcoord = texcoord;
}