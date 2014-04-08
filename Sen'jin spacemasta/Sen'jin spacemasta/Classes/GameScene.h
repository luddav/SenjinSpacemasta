//
//  GameScene.h
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "CCScene.h"

@class BackgroundLight;
@class HeatEffect;
@class Background;

@interface GameScene : CCScene

+ (GameScene *)scene;

-(void) addBackgroundLight:(BackgroundLight*)light;
-(void) addHeatEffect:(HeatEffect*)light;

-(Background*) getBackground;
@end
