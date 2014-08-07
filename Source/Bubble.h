//
//  Bubble.h
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/29/14.
//  Copyright (c) 2014 Sagadev/Brandon Richey. All rights reserved.
//

#import "CCNode.h"
#import "Explosion.h"

@interface Bubble : CCSprite

@property (nonatomic) BOOL    exploding;
@property (nonatomic) BOOL    dead;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) int     difficulty;

-(BOOL)checkCollisionWithExplosion:(Explosion*)explosion;
-(BOOL)checkCollisionWithBubble:(Bubble *)bubble;
-(void)explode;
-(CGFloat) radius;

@end
