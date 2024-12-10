//
// Grayscale shader from https://manual.gamemaker.io/monthly/en/Additional_Information/Guide_To_Using_Shaders.htm, but modified to make the sprite slightly darker
// Instead of vec3(0.299, 0.587, 0.114), uses vec3(0.199, 0.487, 0.014)
//
varying vec2 v_vTexcoord;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    float gray = dot(texColor.rgb, vec3(0.199, 0.487, 0.014));
    gl_FragColor = vec4(gray, gray, gray, texColor.a);
}
