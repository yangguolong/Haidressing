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

void main()
{
//    texCoord = vec2(position.x / imageWidth, position.y / imageHeight);
//    gl_Position = modelViewProjectionMatrix * position;
    
    texCoord = vec2(position.x / imageWidth, position.y / imageHeight);
    
    lowp vec4 finalPosition = position;
    float xPos = position.x - (imageWidth / 2.0);
    if(xPos >= 0.0)
        finalPosition.x = xPos;
    gl_Position = modelViewProjectionMatrix * finalPosition;
}
