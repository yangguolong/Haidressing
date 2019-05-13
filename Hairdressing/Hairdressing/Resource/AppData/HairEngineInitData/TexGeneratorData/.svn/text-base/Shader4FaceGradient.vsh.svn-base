//
//  Shader.vsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//


attribute vec4 position;
attribute vec3 normalIn;

uniform mat4 modelViewProjectionMatrix;

varying lowp vec3 normalOut;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    normalOut = normalize(normalIn);
}
