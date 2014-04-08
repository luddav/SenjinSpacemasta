//
//  HeatEffect.m
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-06.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "HeatEffect.h"
#import "cocos2d.h"
#import "CCTexture_Private.h"
#import "GameScene.h"
#import "Background.h"

@implementation HeatEffect
{
    CCTexture* _background;
    CCTexture* _warpTexture;
    CCTexture* _warpMaskTexture;

    
    GLint _uniformSamplerBackground;
    GLint _uniformSamplerWarpTexture;
    GLint _uniformSamplerWarpMaskTexture;

    GLint _uniformTexOffset;
    
    CGPoint _warpPosition;

    float _warpOffset;
}

enum {
	kVertexAttrib_Position,
	kVertexAttrib_Color,
	kVertexAttrib_TexCoords,
	kVertexAttrib_MAX,
};

- (instancetype)initWithBackgroundTexture:(CCTexture*)background;
{
    self = [super init];
    if (self) {
        _background = background;
        
        _warpTexture = [CCTexture textureWithFile:@"noise.pvr"];
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [_warpTexture setTexParameters:&params];
        
        _warpMaskTexture = [CCTexture textureWithFile:@"flameMask.png"];

        
        _shaderProgram = [self getShader];
        self.anchorPoint = ccp(0, 0);
        
        self.position = ccp(0, 0);
        
        _warpOffset = 0;
    }
    return self;
}

-(void) setWarpPosition:(CGPoint)warpPosition
{
    _warpPosition = warpPosition;
}

-(void) update:(CCTime)delta
{
    _warpOffset += delta * 1.0;
    if( _warpOffset > 1.0 ) {
        _warpOffset -= 1.0;
    }

    
    float halfWidth = 25;
    float height = 100;
    
    _quad.tl.vertices.x = _warpPosition.x-halfWidth;
    _quad.tl.vertices.y = _warpPosition.y;
    _quad.tl.texCoords.u = 0;
    _quad.tl.texCoords.v = 0;
    
    _quad.tr.vertices.x = _warpPosition.x+halfWidth;
    _quad.tr.vertices.y = _warpPosition.y;
    _quad.tr.texCoords.u = 1;
    _quad.tr.texCoords.v = 0;
    
    _quad.bl.vertices.x = _warpPosition.x-halfWidth;
    _quad.bl.vertices.y = _warpPosition.y-height;
    _quad.bl.texCoords.u = 0;
    _quad.bl.texCoords.v = 1;
    
    _quad.br.vertices.x = _warpPosition.x+halfWidth;
    _quad.br.vertices.y = _warpPosition.y-height;
    _quad.br.texCoords.u = 1;
    _quad.br.texCoords.v = 1;

}

-(void) draw
{
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];
    
	ccGLBlendFunc( _blendFunc.src, _blendFunc.dst );
    
    glUniform2f(_uniformTexOffset, 0, _warpOffset);
    
    glActiveTexture(GL_TEXTURE0);
    glUniform1i(_uniformSamplerBackground, 0);
    glBindTexture(GL_TEXTURE_2D, _background.name);
    
    glActiveTexture(GL_TEXTURE1);
    glUniform1i(_uniformSamplerWarpTexture, 1);
    glBindTexture(GL_TEXTURE_2D, _warpTexture.name);

    glActiveTexture(GL_TEXTURE2);
    glUniform1i(_uniformSamplerWarpMaskTexture, 2);
    glBindTexture(GL_TEXTURE_2D, _warpMaskTexture.name);

	//
	// Attributes
	//
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );
    
#define kQuadSize sizeof(_quad.bl)
	long offset = (long)&_quad;
    
	// vertex
	NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
	CHECK_GL_ERROR_DEBUG();
    
 	CC_INCREMENT_GL_DRAWS(1);
    
	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"CCSprite - draw");
}


-(CCGLProgram*) getShader
{
    NSString* fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"WarpShader" ofType:@"fsh"];
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    NSString* vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"WarpShader" ofType:@"vsh"];
    const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    
    CCGLProgram *shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:vertexSource
                                                            fragmentShaderByteArray:fragmentSource];
    
    [shaderProgram addAttribute:@"a_position" index:kVertexAttrib_Position];
    [shaderProgram addAttribute:@"a_texCoord" index:kVertexAttrib_TexCoords];
    [shaderProgram link];
    [shaderProgram updateUniforms];
    
    _uniformSamplerBackground = glGetUniformLocation(shaderProgram->_program, "u_background");
    _uniformSamplerWarpTexture = glGetUniformLocation(shaderProgram->_program, "u_warpTexture");
    _uniformSamplerWarpMaskTexture = glGetUniformLocation(shaderProgram->_program, "u_warpMaskTexture");

    
    _uniformTexOffset = glGetUniformLocation(shaderProgram->_program, "u_texOffset");
    
    return shaderProgram;
}

@end
