
varying vec2 v_backgroundTexCoord;
varying vec2 v_warpTexCoord;
varying vec2 v_warpMaskTexCoord;

uniform sampler2D u_background;
uniform sampler2D u_warpTexture;
uniform sampler2D u_warpMaskTexture;

void main()
{
    mediump float warpMask = texture2D(u_warpMaskTexture, v_warpMaskTexCoord).r;
    vec2 warp = (texture2D(u_warpTexture, v_warpTexCoord).rg - vec2(0.5,0.5)) *  warpMask;
    vec2 warpedCoord = v_backgroundTexCoord + warp*0.04 ;
    
    vec3 background = texture2D(u_background, warpedCoord).rgb;
    gl_FragColor = vec4(background,1.0 );
}
