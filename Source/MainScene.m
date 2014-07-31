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
    CCNode         *_gameLayer;
    CCPhysicsNode  *_physicsNode;
}

static const CGFloat  MIN_ANGLE        = 0.0f;
static const CGFloat  MAX_ANGLE        = 360.0f * M_PI / 180.0f;
static const CGFloat  BUBBLE_SPEED     = 50.0f;
static const int      STARTING_BUBBLES = 10;

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
        _physicsNode.debugDraw = TRUE;
    }
    return self;
}

-(void)setupBubbles
{
    for (int i = 0; i < STARTING_BUBBLES; i++) {
        Bubble *bubble = (Bubble*)[CCBReader load:@"Bubble"];
        CGVector direction = radiansToVector(randomInRange(MIN_ANGLE, MAX_ANGLE));
        bubble.physicsBody.velocity = ccp(BUBBLE_SPEED * direction.dx, BUBBLE_SPEED * direction.dy);
        bubble.position = ccp([self screenSize].width / 2, [self screenSize].height / 2);
        bubble.physicsBody.collisionType = @"bubble";
        bubble.physicsBody.collisionMask = @[@"edge", @"explosion"];
        [_bubbles addObject:bubble];
        [_gameLayer addChild:bubble];
    }
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
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    Explosion *explosion = (Explosion*)[CCBReader load:@"Explosion"];
    explosion.scale = 0.2f;
    explosion.position = touchLocation;
//    explosion.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:explosion.contentSize.width/2 andCenter:ccp(explosion.contentSize.width/2, explosion.contentSize.height/2)];
//    explosion.physicsBody.collisionMask = @[@"bubble"];
//    explosion.physicsBody.collisionType = @"explosion";
//    explosion.physicsBody.affectedByGravity = FALSE;
    CCActionScaleBy  *expand   = [CCActionScaleBy actionWithDuration:1.7f scale:10.0f];
    CCActionDelay    *delay    = [CCActionDelay actionWithDuration:0.7f];
    CCActionScaleBy  *shrink   = [CCActionScaleBy actionWithDuration:0.7f scale:0.0f];
    CCActionRemove   *remove   = [CCActionRemove action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand, delay, shrink, remove]];
    [explosion runAction:sequence];
    [_gameLayer addChild:explosion];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair explosion:(Explosion*)nodeA bubble:(Bubble*)nodeB
{
    CCLOG(@"collision");
    return FALSE;
}


@end
