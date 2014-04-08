//
//  Background.m
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "Background.h"
#import "cocos2d.h"
#import "CCTexture_Private.h"


@implementation Background
{
    float _textureOffset;
}
- (instancetype)init
{
    
    self = [super initWithImageNamed:@"background_color.png"];
    if (self) {

        self.scale = 320.0 / 512.0;
        self.anchorPoint = ccp(0, 0);
        _textureOffset = 0;

        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        
        [self.texture setTexParameters:&params];
        

        
    }
    return self;
}

-(float) getTextureOffset
{
    return _textureOffset;
}

-(void) update:(CCTime)delta
{
    _textureOffset -= delta * 0.01;
    if( _textureOffset < -1.0 ) {
        _textureOffset += 1.0;
    }
    
    _quad.tr.texCoords.v = _textureOffset;
    _quad.tl.texCoords.v = _textureOffset;
    _quad.br.texCoords.v = 1.0 +_textureOffset;
    _quad.bl.texCoords.v = 1.0 + _textureOffset;
}
@end
