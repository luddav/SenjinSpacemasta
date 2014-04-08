attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_backgroundTexCoord;
varying mediump vec2 v_warpTexCoord;
varying mediump vec2 v_warpMaskTexCoord;


uniform vec2 u_texOffset;
uniform vec3 u_lightPosition;

void main()
{
    gl_Position = CC_MVPMatrix * a_position;
    
    v_backgroundTexCoord =  vec2( a_position.x * (1.0 / 320.0), (a_position.y)  * (1.0 / (568.0)) );
    v_warpTexCoord = vec2(a_position.xy)*0.004 + u_texOffset;
    v_warpMaskTexCoord = a_texCoord;
}