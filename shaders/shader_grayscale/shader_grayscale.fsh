//
// Grayscale shader from https://manual.gamemaker.io/monthly/en/Additional_Information/Guide_To_Using_Shaders.htm
//
varying vec2 v_vTexcoord;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
    gl_FragColor = vec4(gray, gray, gray, texColor.a);
}
