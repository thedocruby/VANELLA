#version 120

#include "/functions.glsl"
#include "/settings.glsl"

uniform sampler2D lightmap;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec4 shadowPos;

const int shadowMapResolution = 1024; //Resolution of the shadow map. Higher numbers mean more accurate shadows. [128 256 512 1024 2048 4096 8192]

//fix artifacts when colored shadows are enabled
const bool shadowcolor0Nearest = true;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	vec2 lm = lmcoord;
	if (shadowPos.w > 0.0) {
		//surface is facing towards shadowLightPosition
		#if COLORED_SHADOWS == 0
			//for normal shadows, only consider the closest thing to the sun,
			//regardless of whether or not it's opaque.
			if (texture2D(shadowtex0, shadowPos.xy).r < shadowPos.z) {
		#else
			//for invisible and colored shadows, first check the closest OPAQUE thing to the sun.
			if (texture2D(shadowtex1, shadowPos.xy).r < shadowPos.z) {
		#endif
			//surface is in shadows. reduce light level.
			lm.y *= SHADOW_BRIGHTNESS;

			color.rgb *= mapLight(lm).rgb;
		}
		else {
			#if COLORED_SHADOWS == 1
				//when colored shadows are enabled and there's nothing OPAQUE between us and the sun,
				//perform a 2nd check to see if there's anything translucent between us and the sun.
				if (texture2D(shadowtex0, shadowPos.xy).r < shadowPos.z) {
					//surface has translucent object between it and the sun. modify its color.
					vec4 shadowLightColor = texture2D(shadowcolor0, shadowPos.xy);
					//also make colors less intense when the block light level is high.
					shadowLightColor.rgb = mix(shadowLightColor.rgb, vec3(1.0), lm.x);
					//apply the color.
					color.rgb *= mix(mapLight(vec2(lm.x, lm.y * SHADOW_BRIGHTNESS)).rgb, mapLight(vec2(lm.x, lm.y * mix(SHADOW_BRIGHTNESS, 1.0, shadowPos.w))).rgb, shadowLightColor.rgb);
				}
				else{
					//reduce light level based on direction (directional lighting)
					lm.y *= mix(SHADOW_BRIGHTNESS, 1.0, shadowPos.w);
					color.rgb *= mapLight(lm).rgb;
				}
			#else
				//reduce light level based on direction (directional lighting)
				lm.y *= mix(SHADOW_BRIGHTNESS, 1.0, shadowPos.w);
				color.rgb *= mapLight(lm).rgb;
			#endif
		}
	}
	else{
		color.rgb *= mapLight(lm).rgb;
	}

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}
