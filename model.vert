#version 140
uniform mat4 projection;
uniform mat4 modelview;
uniform mat4 model;
in  vec3 position;
in  vec3 normal;
in  vec2 texcoord;
out vec2 ex_texcoord;
out vec3 N;
out vec3 vecCam;

void main()
{
		mat3 nv=mat3(model);
		N = normalize(nv*normal);
		vec4 WP=model*vec4(position,1.0);
		vecCam=(inverse(modelview)*vec4(0.0,0.0,0.0,1.0)).xyz-WP.xyz;
		gl_Position=projection*modelview*WP; 
		ex_texcoord=texcoord;
}