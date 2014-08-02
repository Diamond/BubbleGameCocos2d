//
//  Bubble.h
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Explosion.h"

@interface Bubble : CCNode

-(BOOL)checkCollisionWithExplosion:(Explosion*)explosion;

@end
