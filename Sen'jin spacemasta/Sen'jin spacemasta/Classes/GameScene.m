//
//  GameScene.m
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "GameScene.h"
#import "cocos2d.h"
#import "Ship.h"
#import "Projectile.h"
#import "Background.h"
#import "BackgroundLight.h"
#import "HeatEffect.h"

enum
{
    ShipMotionNone,
    ShipMotionLeft,
    ShipMotionRight
};

@implementation GameScene
{
    CCRenderTexture* _renderTexture;
    CCSprite* _renderedBackground;
    
    Background* _background;
    CCNode* _lightsNode;
    CCNode* _heatEffectNode;

    Ship* _ship;
    int _shipMotionState;

    
}

+ (GameScene *)scene
{
    static GameScene* sharedGameScene;

    @synchronized(self)
    {
        if(!sharedGameScene)
        {
            sharedGameScene = [[self alloc] init];
        }
    }

    return sharedGameScene;
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    self.userInteractionEnabled = YES;
    
    _background = [[Background alloc] init];
    
    _lightsNode = [[CCNode alloc] init];
    _lightsNode.position = ccp(0, 0);
    _lightsNode.anchorPoint = ccp(0, 0);
    _lightsNode.scale = 1.0;
    
    _renderTexture = [CCRenderTexture renderTextureWithWidth:self.contentSize.width height:self.contentSize.height pixelFormat:CCTexturePixelFormat_RGBA8888];
    _renderedBackground = [CCSprite spriteWithTexture:_renderTexture.sprite.texture];
    _renderedBackground.position = ccp(0, 0);
    _renderedBackground.anchorPoint = ccp(0, 0);
    _renderedBackground.flipY = YES;
    [self addChild:_renderedBackground];
    
    _heatEffectNode = [[CCNode alloc] init];
    _heatEffectNode.position = ccp(0, 0);
    _heatEffectNode.anchorPoint = ccp(0, 0);
    _heatEffectNode.scale = 1.0;
    [self addChild:_heatEffectNode];


    _ship = [[Ship alloc] init];
    _ship.position = ccp(self.contentSize.width/2, 100);
    _ship.scale = 0.25;
    [self addChild:_ship];
    
    
    id fireProjectileAction = [CCActionCallFunc actionWithTarget:self selector:@selector(fireProjectile)];
    id fireSequence = [CCActionSequence actions:[CCActionDelay actionWithDuration:2.0], fireProjectileAction,nil];
    
    [self runAction:[CCActionRepeatForever actionWithAction:fireSequence]];
    

	return self;
}


-(void) fireProjectile
{
    Projectile* projectile = [[Projectile alloc] initWithPosition:_ship.position andBackgroundTexture:_renderTexture.sprite.texture];
    
    id moveAction = [CCActionMoveBy actionWithDuration:10.0 position:ccp(0, 800)];
    [projectile runAction:moveAction];
    [self addChild:projectile];
}

-(Background*) getBackground
{
    return _background;
}

-(void) addBackgroundLight:(BackgroundLight*)light
{
    [_lightsNode addChild:light];

}

-(void) addHeatEffect:(HeatEffect *)heatEffect
{
    [_heatEffectNode addChild:heatEffect];
    
}

-(void) visit
{
       [super visit];
    
}

-(void) update:(CCTime)delta
{
    [_renderTexture beginWithClear:0 g:0 b:0 a:1.0 depth:0];
    
    [_background update:delta];
    [_background visit];
    
    for (BackgroundLight* light in _lightsNode.children) {
        [light update:delta];
    }
    [_lightsNode visit];
    
    [_renderTexture end];
    
    

    switch (_shipMotionState) {
        case ShipMotionLeft:
            _ship.position = ccp(_ship.position.x - 100*delta, _ship.position.y );
            if( _ship.position.x < 0 ) {
                _ship.position = ccp(0, _ship.position.y);
            }
            break;
        case ShipMotionRight:
            _ship.position = ccp(_ship.position.x + 100*delta, _ship.position.y);
            if( _ship.position.x > 320 ) {
                _ship.position = ccp(320, _ship.position.y);
            }
            break;
            
        default:
            break;
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if( touchLoc.x < 160 ) {
        _shipMotionState = ShipMotionLeft;
    } else {
        _shipMotionState = ShipMotionRight;
    }
}


-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _shipMotionState = ShipMotionNone;
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLoc = [touch locationInNode:self];
    
    if( touchLoc.x < 160 ) {
        _shipMotionState = ShipMotionLeft;
    } else {
        _shipMotionState = ShipMotionRight;
    }

}
@end

