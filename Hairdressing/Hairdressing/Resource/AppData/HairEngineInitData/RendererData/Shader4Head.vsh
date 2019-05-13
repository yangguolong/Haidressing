//
//  Shader.vsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoordIn;
//attribute vec3 normalIn;

varying lowp vec2 texCoordOut;
//varying lowp float aoWeight;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    
    texCoordOut = texCoordIn;
    
    //aoWeight = normalIn[0];
}
