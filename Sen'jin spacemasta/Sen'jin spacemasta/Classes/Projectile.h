//
//  Pojectile.h
//  Sen'jin spacemasta
//
//  Created by Ludvig Davidsson on 2014-04-05.
//  Copyright (c) 2014 MAG. All rights reserved.
//

#import "CCSprite.h"

@interface Projectile : CCSprite

- (instancetype)initWithPosition:(CGPoint)position andBackgroundTexture:(CCTexture*)backgroundTexture;
@end
