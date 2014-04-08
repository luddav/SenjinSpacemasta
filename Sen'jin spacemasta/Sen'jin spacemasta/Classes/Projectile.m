//
//  Pojectile.m
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "Projectile.h"
#import "cocos2d.h"
#import "BackgroundLight.h"
#import "GameScene.h"
#import "HeatEffect.h"

@implementation Projectile
{
    BackgroundLight* _projectileLight;
    HeatEffect* _heatEffect;
    CCSprite* _flame;
}

- (instancetype)initWithPosition:(CGPoint)position andBackgroundTexture:(CCTexture*)backgroundTexture
{
    self = [super initWithImageNamed:@"missile.png"];
    if (self) {
        self.position = position;
        
        self.scale = 0.33;
        
        _flame = [CCSprite spriteWithImageNamed:@"thrusterFlame.png"];
        _flame.anchorPoint = ccp(0.5, 1);
        _flame.position = ccp(self.contentSize.width/2, 0);
        _flame.scale = 0.5;
        _flame.opacity = 0.9;

        ccBlendFunc additiveBlending;
        additiveBlending.src = GL_SRC_ALPHA;
        additiveBlending.dst = GL_ONE;
        [_flame setBlendFunc:additiveBlending];
        [self addChild:_flame];
        
        _projectileLight = [[BackgroundLight alloc] init];
        [_projectileLight setLightPosition:ccp(self.position.x, self.position.y-30)];
        [[GameScene scene] addBackgroundLight:_projectileLight];
        
        _heatEffect = [[HeatEffect alloc] initWithBackgroundTexture:backgroundTexture];
        [_heatEffect setWarpPosition:ccp(self.position.x, self.position.y-20)];
        [[GameScene scene] addHeatEffect:_heatEffect];
    }
    return self;
}

-(void) update:(CCTime)delta
{
    if( self.position.y > 800 ) {
        [_projectileLight removeFromParentAndCleanup:YES];
        [_heatEffect removeFromParentAndCleanup:YES];
        [self removeFromParentAndCleanup:YES];
    
    }
    else {
        [_projectileLight setLightPosition:ccp(self.position.x, self.position.y-30)];
        [_heatEffect setWarpPosition:ccp(self.position.x, self.position.y-20)];
    }
}

@end
