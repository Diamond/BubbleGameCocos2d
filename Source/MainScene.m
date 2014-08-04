//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Bubble.h"
#import "Explosion.h"

@implementation MainScene {
    NSMutableArray *_bubbles;
    NSMutableArray *_bubbleExplosions;
    CCNode         *_gameLayer;
    CCPhysicsNode  *_physicsNode;
    Explosion      *_explosion;
}

static const CGFloat  MIN_ANGLE        = 0.0f;
static const CGFloat  MAX_ANGLE        = 360.0f * M_PI / 180.0f;
static const CGFloat  BUBBLE_SPEED     = 30.0f;
static const int      STARTING_BUBBLES = 30;

static inline CGVector radiansToVector(CGFloat radians)
{
    CGVector vector;
    vector.dx = cosf(radians);
    vector.dy = sinf(radians);
    return vector;
}

static inline CGFloat randomInRange(CGFloat low, CGFloat high)
{
    CGFloat value = arc4random_uniform(UINT32_MAX) / (CGFloat)UINT32_MAX;
    return value * (high - low) + low;
}

-(CGSize)screenSize {
    return [[UIScreen mainScreen] bounds].size;
}

-(id)init {
    if (self = [super init]) {
        _bubbles = [NSMutableArray array];
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

-(void)setupBubbles
{
    for (int i = 0; i < STARTING_BUBBLES; i++) {
        Bubble *bubble = (Bubble*)[CCBReader load:@"BetterBubble"];
        bubble.scale = 0.25f;
        CGVector direction = radiansToVector(randomInRange(MIN_ANGLE, MAX_ANGLE));
        bubble.velocity = ccp(BUBBLE_SPEED * direction.dx, BUBBLE_SPEED * direction.dy);
        bubble.name = [NSString stringWithFormat:@"bubble_%d", i];
        [_bubbles addObject:bubble];
        [self restoreBubble:bubble];
    }
}

-(void)restoreBubble:(Bubble*)bubble
{
    CGFloat rx    = randomInRange(8, [self screenSize].width - 8);
    CGFloat ry    = randomInRange(8, [self screenSize].height - 8);
    CGPoint start = ccp(rx, ry);
    bubble.position = start;
    [_gameLayer addChild:bubble];
}

-(void)setupExplosion
{
    _explosion = (Explosion*)[CCBReader load:@"Explosion"];
}

-(void)onEnter
{
    [super onEnter];
    _physicsNode.collisionDelegate = self;
    [self setupBubbles];
    [self setupExplosion];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![_gameLayer.children containsObject:_explosion]) {
        CGPoint touchLocation = [touch locationInNode:self];
        [_explosion startAt:touchLocation];
        [_gameLayer addChild:_explosion];
    }
}

-(void)update:(CCTime)delta
{
    for (Bubble *bubble in _bubbles) {
        if ([_gameLayer.children containsObject:bubble]) {
            if ([bubble checkCollisionWithExplosion:_explosion]) {
                [bubble explode];
            }
            for (Bubble *otherBubble in _bubbles) {
                if (otherBubble.name == bubble.name) {
                    continue;
                }
                if ([bubble checkCollisionWithBubble:otherBubble]) {
                    [bubble explode];
                }
            }
        }
    }
}

@end
