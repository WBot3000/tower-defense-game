//
// Used to create a basic highlighting effect by making the whole sprite slightly brighter
//
varying vec2 v_vTexcoord;

void main()
{
    vec4 texColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(texColor.r + 0.1, texColor.g + 0.1, texColor.b + 0.1, texColor.a);
}
