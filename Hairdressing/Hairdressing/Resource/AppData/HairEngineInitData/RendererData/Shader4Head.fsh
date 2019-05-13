//
//  Shader.fsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

varying lowp vec2 texCoordOut;
//varying lowp float aoWeight;
uniform sampler2D sampler;

void main()
{
    //gl_FragColor = texture2D(sampler,texCoordOut) * aoWeight;
    gl_FragColor = texture2D(sampler,texCoordOut);
}
