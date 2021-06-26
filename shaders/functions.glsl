#include "/settings.glsl"

uniform int worldTime;
uniform int moonPhase;

vec3 mapLight(vec2 coords){
  float fullness = 1 - (cos(moonPhase * 3.14159 / 4.0)/2.0 + 0.5);
  vec3 blcolor = vec3(BLOCK_LIGHT_RED, BLOCK_LIGHT_GREEN, BLOCK_LIGHT_BLUE);
  vec3 nooncolor = vec3(NOON_LIGHT_RED, NOON_LIGHT_GREEN, NOON_LIGHT_BLUE);
  vec3 twcolor = vec3(TWILIGHT_RED, TWILIGHT_GREEN, TWILIGHT_BLUE) * TWILIGHT_BRIGHTNESS;
  vec3 mooncolor = vec3(MOON_LIGHT_RED, MOON_LIGHT_GREEN, MOON_LIGHT_BLUE) * mix(MOON_LIGHT_BRIGHTNESS, STAR_LIGHT_BRIGHTNESS, fullness);
  vec3 slcolor;

  if(worldTime >= 0.0 && worldTime < 2000){
    float mixer = pow(1.0 - worldTime/2000.0, 3.0);
    slcolor = mix(nooncolor, twcolor, mixer);
  }
  else if(worldTime >= 2000 && worldTime < 10000){
    slcolor = nooncolor;
  }
  else if(worldTime >= 10000 && worldTime < 12000){
    float mixer = pow((worldTime - 10000.0)/2000.0, 3.0);
    slcolor = mix(nooncolor, twcolor, mixer);
  }
  else if(worldTime >= 12000 && worldTime < 14000){
    float mixer = pow(1.0 - (worldTime - 12000.0)/2000.0, 2.0);
    slcolor = mix(mooncolor, twcolor, mixer);
  }
  else if(worldTime >= 14000 && worldTime < 22000){
    slcolor = mooncolor;
  }
  else if(worldTime >= 22000 && worldTime < 24000){
    float mixer = pow((worldTime - 22000.0)/2000.0, 2.0);
    slcolor = mix(mooncolor, twcolor, mixer);
  }

  return clamp(max(slcolor.rgb * coords.y, blcolor.rgb * coords.x), vec3(MINIMUM_LIGHT), vec3(1.0));
}
