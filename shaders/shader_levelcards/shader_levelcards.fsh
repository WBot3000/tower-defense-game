//
// Used to color level cards based on provided color data
//
varying vec2 v_vTexcoord;

uniform vec3 cardColor; 

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(texColor.r * cardColor.r, texColor.g * cardColor.g, texColor.b * cardColor.b, texColor.a);
}
