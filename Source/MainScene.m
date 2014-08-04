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
static const CGFloat  BUBBLE_SPEED     = 50.0f;
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
        _physicsNode.debugDraw      = TRUE;
    }
    return self;
}

-(void)setupBubbles
{
    for (int i = 0; i < STARTING_BUBBLES; i++) {
        Bubble *bubble = (Bubble*)[CCBReader load:@"BetterBubble"];
        bubble.scale = 0.25f;
        CGVector direction = radiansToVector(randomInRange(MIN_ANGLE, MAX_ANGLE));
        bubble.physicsBody.velocity = ccp(BUBBLE_SPEED * direction.dx, BUBBLE_SPEED * direction.dy);
        bubble.physicsBody.collisionCategories = @[@"bubble"];
        bubble.physicsBody.collisionType = @"bubble";
        bubble.physicsBody.collisionMask = @[@"edge", @"explosion"];
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

-(void)setupEdges
{
    CCNode *leftEdge = [[CCNode alloc] init];
    leftEdge.contentSize = CGSizeMake(0.1f, _gameLayer.contentSize.height);
    leftEdge.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, 0.1, [self screenSize].height) cornerRadius:0.0];
    leftEdge.position = CGPointZero;
    leftEdge.physicsBody.type = CCPhysicsBodyTypeStatic;
    leftEdge.physicsBody.elasticity = 1.0f;
    leftEdge.physicsBody.collisionType = @"edge";
    [_gameLayer addChild:leftEdge];
    
    CCNode *rightEdge = [[CCNode alloc] init];
    rightEdge.contentSize = CGSizeMake(0.1f, _gameLayer.contentSize.height);
    rightEdge.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, 0.1, [self screenSize].height) cornerRadius:0.0];
    rightEdge.position = ccp([self screenSize].width, 0);
    rightEdge.physicsBody.type = CCPhysicsBodyTypeStatic;
    rightEdge.physicsBody.elasticity = 1.0f;
    rightEdge.physicsBody.collisionType = @"edge";
    [_gameLayer addChild:rightEdge];

    CCNode *topEdge = [[CCNode alloc] init];
    topEdge.contentSize = CGSizeMake(_gameLayer.contentSize.width, 0.1f);
    topEdge.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, [self screenSize].width, 0.1) cornerRadius:0.0];
    topEdge.position = ccp(0, [self screenSize].height);
    topEdge.physicsBody.type = CCPhysicsBodyTypeStatic;
    topEdge.physicsBody.elasticity = 1.0f;
    topEdge.physicsBody.collisionType = @"edge";
    [_gameLayer addChild:topEdge];
    
    CCNode *bottomEdge = [[CCNode alloc] init];
    bottomEdge.contentSize = CGSizeMake(_gameLayer.contentSize.width, 0.1f);
    bottomEdge.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, [self screenSize].width, 0.1) cornerRadius:0.0];
    bottomEdge.position = ccp(0, 0);
    bottomEdge.physicsBody.type = CCPhysicsBodyTypeStatic;
    bottomEdge.physicsBody.elasticity = 1.0f;
    bottomEdge.physicsBody.collisionType = @"edge";
    bottomEdge.physicsBody.collisionMask = @[@"bubble"];
    [_gameLayer addChild:bottomEdge];
}

-(void)setupExplosion
{
    _explosion = (Explosion*)[CCBReader load:@"Explosion"];
}

-(void)didLoadFromCCB
{
    CCLOG(@"didLoadFromCCB");
}

-(void)onEnter
{
    [super onEnter];
    _physicsNode.collisionDelegate = self;
    [self setupBubbles];
    [self setupEdges];
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

//-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair explosion:(Explosion*)nodeA bubble:(Bubble*)nodeB
//{
//    Explosion *explosion = (Explosion*)[CCBReader load:@"Explosion"];
//    explosion.position = nodeB.position;
//    [_gameLayer addChild:explosion];
//    if ([_gameLayer.children containsObject:nodeB]) {
//        [nodeB removeFromParent];
//    }
//}

@end
