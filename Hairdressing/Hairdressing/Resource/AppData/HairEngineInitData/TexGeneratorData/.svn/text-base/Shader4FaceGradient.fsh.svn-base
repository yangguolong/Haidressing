//
//  Shader.fsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

varying lowp vec3 normalOut;

void main()
{
    lowp vec3 light = vec3(0.0, 0.0, 1.0);
    //lowp vec3 light = vec3(0.0, -0.5, 0.866025);
    lowp vec3 normal = normalize(normalOut);
    lowp float dotV = max(dot(normal, light), 0.0);
    lowp vec3 color = dotV * vec3(0.8, 0.8, 0.8) + vec3(0.2, 0.2, 0.2);
    gl_FragColor = vec4(color, 1.0);

}
