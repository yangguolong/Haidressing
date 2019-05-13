//
//  Shader.vsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

attribute vec4 position;

varying lowp vec2 texCoord;

uniform mat4 modelViewProjectionMatrix;
uniform float imageWidth;
uniform float imageHeight;

//attribute vec4 color;
//varying lowp vec4 colorOut;

void main()
{
    //colorOut = color;
    texCoord = vec2(position.x / imageWidth, position.y / imageHeight);
    gl_Position = modelViewProjectionMatrix * position;
}
