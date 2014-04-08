//
//  HeatEffect.h
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-06.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "CCSprite.h"

@interface HeatEffect : CCSprite

- (instancetype)initWithBackgroundTexture:(CCTexture*)background;

-(void) setWarpPosition:(CGPoint)warpPosition;


@end
