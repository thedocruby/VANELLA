#version 120

#include "/functions.glsl"

uniform sampler2D lightmap;

varying vec2 lmcoord;
varying vec4 glcolor;

void main() {
	vec4 color = glcolor;
	color.rgb *= mapLight(lmcoord).rgb;

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
