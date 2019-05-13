//
//  Shader.vsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

attribute vec4 position;
uniform mat4 modelViewProjectionMatrix;
uniform int flag; //0: head 1:hair surface
uniform float imageWidth;
uniform float imageHeight;

void main()
{
    lowp vec4 finalPosition = position;
    if(flag == 1)
    {
        float xPos = position.x - (imageWidth / 2.0);
        if(xPos >= 0.0)
            finalPosition.x = xPos;
    }
    
    gl_Position = modelViewProjectionMatrix * finalPosition;
}
