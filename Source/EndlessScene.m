//
//  EndlessScene.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "EndlessScene.h"
#import "Bubble.h"
#import "Explosion.h"

@implementation EndlessScene {
    NSMutableArray *_bubbles;
    CCNode         *_gameLayer;
    Explosion      *_explosion;
    int            _bubbleCount;
}

static const CGFloat  MIN_ANGLE         = 0.0f;
static const CGFloat  MAX_ANGLE         = 360.0f * M_PI / 180.0f;
static const CGFloat  BUBBLE_SPEED      = 30.0f;
static const int      BUBBLES_ON_SCREEN = 20;

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
    return [[CCDirector sharedDirector] viewSize];
}

-(id)init {
    if (self = [super init]) {
        _bubbles = [NSMutableArray array];
        self.userInteractionEnabled = TRUE;
        _bubbleCount = 0;
    }
    return self;
}

-(void)cleanup
{
    for (Bubble *bubble in _bubbles) {
        if (bubble.dead && !bubble.exploding) {
            [bubble removeFromParent];
            [self restoreBubble:bubble];
        }
    }
}

-(void)setupBubbles
{
    while ([_bubbles count] < BUBBLES_ON_SCREEN) {
        [self addBubble];
    }
}

-(void)addBubble
{
    if ([_bubbles count] >= BUBBLES_ON_SCREEN) {
        return;
    }
    Bubble *bubble = (Bubble*)[CCBReader load:@"BetterBubble"];
    
    [_bubbles addObject:bubble];
    [self restoreBubble:bubble];
}

-(void)restoreBubble:(Bubble*)bubble
{
    CGFloat rx    = randomInRange(8, [self screenSize].width - 8);
    CGFloat ry    = randomInRange(8, [self screenSize].height - 8);
    CGPoint start = ccp(rx, ry);
    bubble.position = start;
    bubble.scale = 0.1f;
    CGVector direction = radiansToVector(randomInRange(MIN_ANGLE, MAX_ANGLE));
    bubble.velocity  = ccp(BUBBLE_SPEED * direction.dx, BUBBLE_SPEED * direction.dy);
    bubble.name      = [NSString stringWithFormat:@"bubble_%f", randomInRange(0, 99)];
    bubble.dead      = FALSE;
    bubble.exploding = FALSE;
    [_gameLayer addChild:bubble];
}

-(void)setupExplosion
{
    _explosion = (Explosion*)[CCBReader load:@"Explosion"];
}

-(void)onEnter
{
    [super onEnter];
    [self setupExplosion];
    [self setupBubbles];
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
    if ([self isCycleDone]) {
        [self cleanup];
    }
}

-(BOOL)isCycleDone
{
    if (_explosion.active) {
        return FALSE;
    }
    for (Bubble *bubble in _bubbles) {
        if (bubble.exploding) {
            return FALSE;
        }
    }
    return TRUE;
}

-(void)returnToTitle
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"TitleScreen"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
