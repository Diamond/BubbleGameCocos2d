//
//  Bubble.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

-(void)didLoadFromCCB
{
    self.exploding = FALSE;
    self.dead      = FALSE;
    [self setRandomColor];
}


-(BOOL)checkCollisionWithExplosion:(Explosion *)explosion
{
    if (self.dead || !explosion.active) {
        return FALSE;
    }
    CGFloat explodeRadius = explosion.contentSize.width * 0.5f * explosion.scale;
    CGFloat selfRadius   = self.contentSize.width * 0.5f * self.scale;
    if ([self circlesIntersectAt:self.position withRadius:selfRadius withPoint:explosion.position withRadius:explodeRadius]) {
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
        if ([self circlesIntersectAt:self.position withRadius:selfRadius withPoint:bubble.position withRadius:bubbleRadius]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL)circlesIntersectAt:(CGPoint)p1 withRadius:(CGFloat)r1 withPoint:(CGPoint)p2 withRadius:(CGFloat)r2
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    CGFloat magnitudeSquared = (dx * dx) + (dy * dy);
    return magnitudeSquared < (r1 + r2) * (r1 + r2);
}

-(void)explode
{
    if (self.exploding) {
        return;
    }
    self.velocity              = CGPointZero;
    self.exploding             = TRUE;
    self.anchorPoint           = ccp(0.5, 0.5);
    CCActionScaleBy  *expand   = [CCActionScaleBy actionWithDuration:1.8f scale:11.0f];
    CCActionDelay    *delay    = [CCActionDelay actionWithDuration:0.9f];
    CCActionScaleBy  *shrink   = [CCActionScaleBy actionWithDuration:0.7f scale:0.0f];
    CCActionCallBlock *betterRemove = [CCActionCallBlock actionWithBlock:^{
        self.dead = TRUE;
        [self removeFromParentAndCleanup:TRUE];
        self.exploding = FALSE;
    }];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand, delay, shrink, betterRemove]];
    [self runAction:sequence];
}

-(void)update:(CCTime)delta
{
    CGPoint newPos = self.position;
    if (self.position.x <= [self radius]) {
        self.velocity = ccp(self.velocity.x * -1, self.velocity.y);
    } else if (self.position.x >= [self screenSize].width - [self radius]) {
        self.velocity = ccp(self.velocity.x * -1, self.velocity.y);
    } else if (self.position.y <= [self radius]) {
        self.velocity = ccp(self.velocity.x, self.velocity.y * -1);
    } else if (self.position.y >= [self screenSize].height - [self radius]) {
        self.velocity = ccp(self.velocity.x, self.velocity.y * -1);
    }
    newPos.x += (delta * self.velocity.x);
    newPos.y += (delta * self.velocity.y);
    self.position = newPos;
}

-(CGFloat)radius
{
    return self.contentSize.width * 0.5 * self.scale;
}

-(CGSize)screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

@end
