#version 120

attribute vec4 mc_Entity;

varying vec2 texcoord;
varying vec4 glcolor;

#include "/distort.glsl"

void main() {
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	if (mc_Entity.x == 10101.0){
		glcolor = gl_Color;
	}
	else{
		glcolor = vec4(1.0);
	}

	#ifdef EXCLUDE_FOLIAGE
		if (mc_Entity.x == 10000.0) {
			gl_Position = vec4(10.0);
		}
		else {
	#endif
		gl_Position = ftransform();
		gl_Position.xyz = distort(gl_Position.xyz);
	#ifdef EXCLUDE_FOLIAGE
		}
	#endif
}
