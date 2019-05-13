//
//  Shader.vsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//


attribute vec4 position;
attribute vec2 texCoordIn;

uniform mat4 modelViewProjectionMatrix;

varying lowp vec2 texCoordOut;
//varying lowp float depth;

void main()
{
    gl_Position = vec4((texCoordIn.x * 2.0 - 1.0), (texCoordIn.y * 2.0 - 1.0), 0.0, 1.0);
    lowp vec4 newPosition = modelViewProjectionMatrix * position;
    newPosition = newPosition / 2.0 + 0.5; //规约到0.0-1.0
    texCoordOut = newPosition.xy;
//    depth = newPosition.z;
}
