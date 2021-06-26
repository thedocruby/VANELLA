#version 120

#include "/settings.glsl"

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 glcolor;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;

	color.rgb = clamp(COLOR_SHADOW_CONTRAST*(color.rgb - 0.5) + 0.5, 0.0, 1.0);

	float factor = 1.0 - abs(2.0 * color.a - 1.0);
	color.rgb = color.rgb * factor + (color.a >= 0.5 ? 0.0 : (1.0 - factor));

	gl_FragData[0] = color;
}
