vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec3 random3( vec3 p ) {
    return fract(sin(vec3(dot(p,vec3(127.1, 311.7, 191.999)),
                          dot(p,vec3(269.5, 183.3, 765.54)),
                          dot(p, vec3(420.69, 631.2,109.21))))
                 *43758.5453);
}

vec2 interpNoise2D(vec2 p) {
    p *= 10;
    float intX = floor(p.x);
    float fractX = fract(p.x);
    
    float intY = floor(p.y);
    float fractY = fract(p.y);
    
    float v1 = random2(vec2(intX,intY)).x;
    float v2 = random2(vec2(intX + 1,intY)).x;
    float v3 = random2(vec2(intX,intY + 1)).x;
    float v4 = random2(vec2(intX + 1,intY + 1)).x;
    
    
    float v5 = random2(vec2(intX,intY)).y;
    float v6 = random2(vec2(intX + 1,intY)).y;
    float v7 = random2(vec2(intX,intY + 1)).y;
    float v8 = random2(vec2(intX + 1,intY + 1)).y;
    
    
    float i1 = mix(v1, v2, fractX);
    float i2 = mix(v3, v4, fractX);
    float i3 = mix(v5, v7, fractY);
    float i4 = mix(v6, v8, fractY);
    return vec2(mix(i1, i2, fractY), mix(i3, i4, fractX));
}

vec2 fbm(vec2 p) {
    float octaves = 8;
    vec2 total = vec2(0);
    float pers = 0.6;
    float freq = 2.f;
    for (int i = 0; i < octaves; i++) {
        float amp = pow(pers, i);
        float f = pow(freq, i);
        total += amp * interpNoise2D(p * f);
    }
    
    return clamp(total, 0, 1);
}

vec2 sphereToUV(vec3 p) {
    const float PI = 3.14159265359;
    const float TWO_PI = 6.28318530718;
    
    float phi = atan(p.z, p.x);
    if(phi < 0) {
        //make sure phi is in range of 0 to 2pi since atan can be negative
        phi += TWO_PI;
    }
    //gives the vertical component of the ray along the viewing frustum
    float theta = acos(p.y);
    
    //return the uv coord of the fragment in uv range
    return vec2(1 - phi / TWO_PI, 1 - theta / PI);
    
}

float greyScale(vec3 col) {
    return 0.19 * col.r + 0.72 * col.g + 0.08 * col.b;
}

vec3 hueSlider(float val, float min, float max) {
    
    if(val <= 0.16) {
        float varied = mix(min, max, val / 0.16);
        return vec3(max, min, varied);
    } else if (val <= 0.32) {
        float varied = mix(max, min, (val - 0.16) / 0.16);
        
        return vec3(varied, 0.43, 1);
        
    } else if (val <= 0.48) {
        float varied = mix(min, max, (val - 0.32) / 0.16);
        
        return vec3(min, varied, max);
        
    } else if (val <= 0.64) {
        float varied = mix(max, min, (val - 0.48) / 0.16);
        
        return vec3(min, max, varied);
    } else if (val <= 0.8) {
        float varied = mix(min, max, (val - 0.64) / 0.16);
        
        return vec3(varied, max, 0.43);
    } else {
        float varied = mix(max, min, (val - 0.8) / 0.2);
        
        return vec3(max, varied, min);
    }
}
void main()
{
    
    
    
    const float PI = 3.14159265359;
    
    
    
    vec3 camPos = vec3(0, 0, 0);
    
    float disp = sin(u_time * 0.05) * 0.17;
    float dispx = cos(u_time * 0.05) * 0.17;
    vec2 dim = normalize(u_Dimensions);
    //give the position of the center of the sun
    vec3 sunDir = normalize(vec3(disp, dispx, 0.5));
    float sunSize = 10;
    float sunHeight = (sunDir.y + 0.17) / 0.34;
    vec2 ndc = (v_tex_coord.xy) * 2.0 - 1.0; // -1 to 1 NDC
    // ndc.x *= aspect;
    vec4 p = vec4(ndc.xy, 1, 1); // Pixel at the far clip plane
    p *= 1000.0; // Times far clip plane value
    
    p = u_ViewProjInv * p;
    
    
    vec2 uv = v_tex_coord;
    
    uv.x += sin(u_time * 0.005);
    if(uv.x > 1) {
        uv.x -= 1;
    }
    
    if(uv.y > 1) {
        uv.y -= 1;
    }
    
    vec4 diffuseColor = texture2D(u_texture, uv);
    diffuseColor.r *= sin(u_time);
    
    vec3 dayCol = vec3(176, 255, 254);
    vec3 nightCol = vec3(176, 255, 254);
    
    vec3 rayDir = normalize(p.xyz - camPos);
    float lightness = greyScale(diffuseColor.rgb);
    
    lightness = mix(lightness - 0.3, lightness + 0.3, (sunDir.y + 0.17) / 0.34);
    //vec2 randRG = normalize(fbm(vec2(sin(u_time), cos(u_time)))) * lightness;
    
    float colTime = sin(u_time * 0.013);
    diffuseColor.rgb = vec3(sin(u_time * 0.064), sin(u_time * 0.013), sin(u_time * 0.005)) * lightness;
    
    
    diffuseColor.rgb = hueSlider(colTime, 0.43, 1) * lightness;
    
    diffuseColor.rgb *= lightness;
    
    if(sunHeight < 0.5) {
        vec2 floorpos = floor(uv.xy * 1000) / 1000;
        if(random2(floorpos).x > 0.995) {
            diffuseColor.rgb = mix(mix(diffuseColor.rgb, vec3(1), uv.y), diffuseColor.rgb, sunHeight * 2);
            
        }
    }
    
    
    float angle = acos(dot(rayDir, sunDir)) * 360.0 / PI;
    float glowRad = sunSize * 5;
    if(angle < sunSize) {
        diffuseColor = vec4(1,1,1,1);
    } else if (angle < glowRad) {
        diffuseColor.rgb = mix(vec3(1,1,1), diffuseColor.rgb, angle / glowRad);
    }
    gl_FragColor = diffuseColor;
}
