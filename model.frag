#version 140
uniform sampler2D textures;
in vec2  ex_texcoord;
in vec3 N;
in vec3 vecCam;
out vec4 out_colour;
const vec3 vLightDirection=vec3(0.0, 0.0, -1.0);
const vec3 LightColour=vec3(1.0,1.0,1.0);
const float shineDamper=10.0;
const float reflectivity=1.0;
void main(void)
{
   vec3 L=normalize(vLightDirection);
   float lambertComponent=max(dot(N,-L),0.1);
   vec4 diffuseLight=vec4(lambertComponent,lambertComponent,lambertComponent,1.0);
   vec3 uvCam=normalize(vecCam);
   vec3 iL=L;
   vec3 rL=reflect(iL,N);
   float specFactor=dot(rL,uvCam);
   specFactor=max(specFactor,0.0);
   float specDamped=pow(specFactor,shineDamper);
   vec3 specFinal=specDamped*LightColour;
   vec4 texcolour = texture(textures,ex_texcoord);
   if (texcolour.a<0.5){
   discard;
   }
	out_colour=texcolour*diffuseLight+vec4(specFinal,1.0);
}