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
        self.exploding = FALSE;
        self.dead      = FALSE;
        [self setRandomColor];
    }
    return self;
}

-(void)didLoadFromCCB
{
    self.exploding = FALSE;
    self.dead      = FALSE;
    [self setRandomColor];
}


-(BOOL)checkCollisionWithExplosion:(Explosion *)explosion
{
    if (self.dead) {
        return FALSE;
    }
    CGFloat explodeRadius = explosion.contentSize.width * 0.5f * explosion.scale;
    if ([self circlesIntersectAt:self.position withRadius:self.contentSize.width*0.5f withPoint:explosion.position withRadius:explodeRadius]) {
        return TRUE;
    }
    return FALSE;
}

-(void)setRandomColor
{
    CGFloat red   = (arc4random() % 255) / 255.0f;
    CGFloat blue  = (arc4random() % 255) / 255.0f;
    CGFloat green = (arc4random() % 255) / 255.0f;
    
    self.colorRGBA = [CCColor colorWithRed:red green:green blue:blue alpha:0.9f];
}


-(BOOL)checkCollisionWithBubble:(Bubble *)bubble
{
    if (self.dead || bubble.dead) {
        return FALSE;
    }
    if (bubble.exploding) {
        CGFloat bubbleRadius = bubble.contentSize.width * 0.5f * bubble.scale;
        CGFloat selfRadius   = self.contentSize.width * 0.5f * self.scale;
        if ([self circlesIntersectAt:self.position withRadius:selfRadius withPoint:bubble.position withRadius:bubbleRadius andDebug:TRUE]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL)circlesIntersectAt:(CGPoint)p1 withRadius:(CGFloat)r1 withPoint:(CGPoint)p2 withRadius:(CGFloat)r2
{
    return [self circlesIntersectAt:p1 withRadius:r1 withPoint:p2 withRadius:r2 andDebug:FALSE];
}

-(BOOL)circlesIntersectAt:(CGPoint)p1 withRadius:(CGFloat)r1 withPoint:(CGPoint)p2 withRadius:(CGFloat)r2 andDebug:(BOOL)debug
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    CGFloat magnitudeSquared = (dx * dx) + (dy * dy);
    return magnitudeSquared < (r1 + r2) * (r1 + r2);
}

-(void)removeMe
{
    self.dead = TRUE;
    [self removeFromParentAndCleanup:TRUE];
}

-(void)explode
{
    if (self.exploding) {
        return;
    }
    self.physicsBody.velocity  = CGPointZero;
    self.exploding             = TRUE;
    self.anchorPoint           = ccp(0.5, 0.5);
    CCActionScaleBy  *expand   = [CCActionScaleBy actionWithDuration:1.7f scale:9.0f];
    CCActionDelay    *delay    = [CCActionDelay actionWithDuration:0.7f];
    CCActionScaleBy  *shrink   = [CCActionScaleBy actionWithDuration:0.7f scale:0.0f];
    CCActionCallFunc *betterRemove = [CCActionCallFunc actionWithTarget:self selector:@selector(removeMe)];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand, delay, shrink, betterRemove]];
    [self runAction:sequence];
}

@end
