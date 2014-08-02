//
//  Bubble.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(BOOL)checkCollisionWithExplosion:(Explosion *)explosion
{
    CGFloat explodeRadius = explosion.contentSize.width * 0.5f * explosion.scale;
    if ([self circlesIntersectAt:self.position withRadius:self.contentSize.width*0.5f withPoint:explosion.position withRadius:explodeRadius]) {
        return TRUE;
    }
    return FALSE;
}

-(BOOL)circlesIntersectAt:(CGPoint)p1 withRadius:(CGFloat)r1 withPoint:(CGPoint)p2 withRadius:(CGFloat)r2
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    CGFloat magnitudeSquared = dx * dx + dy * dy;
    return magnitudeSquared < (r1 + r2) * (r1 + r2);
}

@end
