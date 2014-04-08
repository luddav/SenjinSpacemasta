
varying vec3 v_lightVector;
varying vec2 v_texCoord1;

uniform sampler2D u_normalMap;
uniform sampler2D u_albedoMap;

void main()
{
    vec3 surfaceNormal = (texture2D(u_normalMap, v_texCoord1).rgb - vec3(0.5,0.5,0.5)) * 2.0;
    vec4 albedo = texture2D(u_albedoMap, v_texCoord1).rgba * 0.8;
    
    mediump float d = length(v_lightVector);
    mediump float attenuation = (1.0 / ((2.0 * d) )) * 64.0;

    mediump float diffuse = attenuation * dot( surfaceNormal, normalize(v_lightVector));
    
    gl_FragColor = vec4(albedo.rgb*diffuse,diffuse );
}
