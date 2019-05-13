//
//  Shader.fsh
//  Hair Preview
//
//  Created by charles wong on 13-3-8.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

varying lowp vec4 colorOut;

varying lowp vec2 texCoord;

uniform sampler2D sampler;

void main()
{
    highp vec4 color = texture2D(sampler,texCoord);
    highp float alpha = color[3];
    alpha *= color[3]; //2
    alpha *= color[3]; // 3
    alpha *= color[3]; // 4
    gl_FragColor = vec4(color[0], color[1], color[2], alpha);
}
