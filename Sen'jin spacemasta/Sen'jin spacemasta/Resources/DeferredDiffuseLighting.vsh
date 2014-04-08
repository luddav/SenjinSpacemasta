attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

varying mediump vec2 v_texCoord1;
varying mediump vec3 v_lightVector;

uniform vec2 u_texOffset;
uniform vec3 u_lightPosition;

void main()
{
    gl_Position = CC_MVPMatrix * a_position;
    v_lightVector = u_lightPosition - vec3(a_position.xy, 0.0);
    
    v_texCoord1 =  vec2( a_position.x * (1.0 / 320.0), (a_position.y)  * (-1.0 / (640.0)) + u_texOffset.y );
}