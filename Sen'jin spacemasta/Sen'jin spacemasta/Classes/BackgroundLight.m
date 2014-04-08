//
//  BackgroundLight.m
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "BackgroundLight.h"
#import "cocos2d.h"
#import "CCTexture_Private.h"
#import "GameScene.h"
#import "Background.h"

enum {
	kVertexAttrib_Position,
	kVertexAttrib_Color,
	kVertexAttrib_TexCoords,
	kVertexAttrib_MAX,
};

@implementation BackgroundLight
{
    CCTexture* _normalMap;
    CCTexture* _albedo;
    
    GLint _uniformSamplerNormalmap;
    GLint _uniformSamplerAlbedo;
    
    GLint _uniformTexOffset;
    
    GLint _uniformLightPosition;

    CGPoint _lightPosition;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _normalMap = [CCTexture textureWithFile:@"background_normal.png"];
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        
        [_normalMap setTexParameters:&params];

        _albedo = [CCTexture textureWithFile:@"background_albedo.png"];
        [_albedo setTexParameters:&params];
    
        _shaderProgram = [self getShader];
        self.anchorPoint = ccp(0, 0);
        
        self.position = ccp(0, 0);
        
        _blendFunc.src = GL_SRC_ALPHA;
        _blendFunc.dst = GL_ONE;
    }
    return self;
}

-(void) setLightPosition:(CGPoint)lightPosition
{
    _lightPosition = lightPosition;
}

-(void) update:(CCTime)delta
{

    
    float r = 120;
    
    _quad.tl.vertices.x = _lightPosition.x-r;
    _quad.tl.vertices.y = _lightPosition.y+r;
    
    _quad.tr.vertices.x = _lightPosition.x+r;
    _quad.tr.vertices.y = _lightPosition.y+r;
    
    _quad.bl.vertices.x = _lightPosition.x-r;
    _quad.bl.vertices.y = _lightPosition.y-r;
    
    _quad.br.vertices.x = _lightPosition.x+r;
    _quad.br.vertices.y = _lightPosition.y-r;
    
}

-(void) draw
{
    [_shaderProgram use];
	[_shaderProgram setUniformsForBuiltins];

	ccGLBlendFunc( _blendFunc.src, _blendFunc.dst );
    
    float textureOffset = [[[GameScene scene] getBackground] getTextureOffset];
    
    glUniform2f(_uniformTexOffset, 0, textureOffset);
    glUniform3f(_uniformLightPosition, _lightPosition.x, _lightPosition.y,  32.0);

    glActiveTexture(GL_TEXTURE0);
    glUniform1i(_uniformSamplerNormalmap, 0);
    glBindTexture(GL_TEXTURE_2D, _normalMap.name);
    
    
    glActiveTexture(GL_TEXTURE1);
    glUniform1i(_uniformSamplerAlbedo, 1);
    glBindTexture(GL_TEXTURE_2D, _albedo.name);
    
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
    NSString* fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"DeferredDiffuseLighting" ofType:@"fsh"];
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    NSString* vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"DeferredDiffuseLighting" ofType:@"vsh"];
    const GLchar * vertexSource = (GLchar*) [[NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    

    CCGLProgram *shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:vertexSource
                                                            fragmentShaderByteArray:fragmentSource];
    
    [shaderProgram addAttribute:@"a_position" index:kVertexAttrib_Position];
    [shaderProgram addAttribute:@"a_texCoord" index:kVertexAttrib_TexCoords];
    [shaderProgram link];
    [shaderProgram updateUniforms];
    
    _uniformSamplerNormalmap = glGetUniformLocation(shaderProgram->_program, "u_normalMap");
    _uniformSamplerAlbedo = glGetUniformLocation(shaderProgram->_program, "u_albedoMap");

    _uniformTexOffset = glGetUniformLocation(shaderProgram->_program, "u_texOffset");
    _uniformLightPosition = glGetUniformLocation(shaderProgram->_program, "u_lightPosition");
    
    return shaderProgram;
}

@end
