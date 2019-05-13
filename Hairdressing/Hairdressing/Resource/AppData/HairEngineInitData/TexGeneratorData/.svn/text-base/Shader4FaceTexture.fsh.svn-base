//
//  Shader.fsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

varying lowp vec2 texCoordOut;
//varying lowp float depth;
uniform sampler2D samplerFace;
//uniform sampler2D samplerDepth;

void main()
{
//    lowp vec4 threshold = texture2D(samplerDepth,texCoordOut);
//    if(depth <= (threshold.x + 0.01))
        gl_FragColor = texture2D(samplerFace,texCoordOut);
//    else
//        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}
