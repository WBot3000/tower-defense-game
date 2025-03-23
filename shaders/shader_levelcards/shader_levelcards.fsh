//
// Grayscale shader from https://manual.gamemaker.io/monthly/en/Additional_Information/Guide_To_Using_Shaders.htm, but modified to make the sprite slightly darker
// Instead of vec3(0.299, 0.587, 0.114), uses vec3(0.199, 0.487, 0.014)
//
varying vec2 v_vTexcoord;

uniform vec3 cardColor; 

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(texColor.r * cardColor.r, texColor.g * cardColor.g, texColor.b * cardColor.b, texColor.a);
}
