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
    Explosion      *_explosion;
    BOOL           _ranOnce;
    int            _score;
    CCLabelTTF     *_scoreDisplay;
    int            _level;
    int            _bubbleMax;
    int            _loadBubbles;
    int            _totalScore;
}

static const CGFloat  MIN_ANGLE        = 0.0f;
static const CGFloat  MAX_ANGLE        = 360.0f * M_PI / 180.0f;
static const CGFloat  BUBBLE_SPEED     = 30.0f;

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
        _ranOnce     = FALSE;
        _score       = 0;
        _level       = 0;
        _totalScore  = 0;
    }
    return self;
}

-(void)resetStage
{
    for (Bubble *bubble in _bubbles) {
        [bubble removeFromParentAndCleanup:TRUE];
    }
    [_bubbles removeAllObjects];
    _ranOnce = FALSE;
    _score = 0;
}

-(void)loadStage
{
    switch (_level) {
        case 19:
            [self buildStage:40 andNextLevelAt:38];
            break;
        case 18:
            [self buildStage:40 andNextLevelAt:37];
            break;
        case 17:
            [self buildStage:40 andNextLevelAt:35];
            break;
        case 16:
            [self buildStage:35 andNextLevelAt:32];
            break;
        case 15:
            [self buildStage:35 andNextLevelAt:31];
            break;
        case 14:
            [self buildStage:35 andNextLevelAt:30];
            break;
        case 13:
            [self buildStage:35 andNextLevelAt:28];
            break;
        case 12:
            [self buildStage:30 andNextLevelAt:26];
            break;
        case 11:
            [self buildStage:30 andNextLevelAt:24];
            break;
        case 10:
            [self buildStage:25 andNextLevelAt:22];
            break;
        case 9:
            [self buildStage:25 andNextLevelAt:19];
            break;
        case 8:
            [self buildStage:25 andNextLevelAt:17];
            break;
        case 7:
            [self buildStage:20 andNextLevelAt:15];
            break;
        case 6:
            [self buildStage:20 andNextLevelAt:13];
            break;
        case 5:
            [self buildStage:15 andNextLevelAt:10];
            break;
        case 4:
            [self buildStage:12 andNextLevelAt:7];
            break;
        case 3:
            [self buildStage:10 andNextLevelAt:5];
            break;
        case 2:
            [self buildStage:7 andNextLevelAt:3];
            break;
        case 1:
            [self buildStage:5 andNextLevelAt:2];
            break;
        case 0:
        default:
            [self buildStage:5 andNextLevelAt:1];
            break;
    }
}

-(void)buildStage:(int)bubbleCount andNextLevelAt:(int)nextLevel
{
    [self resetStage];
    _loadBubbles = bubbleCount;
    _bubbleMax   = nextLevel;
    [self updateDisplay];
    [self setupBubbles];
}

-(void)setupBubbles
{
    for (int i = 0; i < _loadBubbles; i++) {
        Bubble *bubble = (Bubble*)[CCBReader load:@"BetterBubble"];
        bubble.scale = 0.1f;
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
    [self setupExplosion];
    [self loadProgress];
    [self loadStage];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_ranOnce) {
        return;
    }
    if (![_gameLayer.children containsObject:_explosion]) {
        CGPoint touchLocation = [touch locationInNode:self];
        [_explosion startAt:touchLocation];
        [_gameLayer addChild:_explosion];
        _ranOnce = TRUE;
    }
}

-(void)update:(CCTime)delta
{
    for (Bubble *bubble in _bubbles) {
        if ([_gameLayer.children containsObject:bubble]) {
            if ([bubble checkCollisionWithExplosion:_explosion]) {
                if (!bubble.exploding) {
                    [self addPoint];
                }
                [bubble explode];
            }
            for (Bubble *otherBubble in _bubbles) {
                if (otherBubble.name == bubble.name) {
                    continue;
                }
                if ([bubble checkCollisionWithBubble:otherBubble]) {
                    if (!bubble.exploding) {
                        [self addPoint];
                    }
                    [bubble explode];
                }
            }
        }
    }
    if ([self isCycleDone]) {
        if (_score >= _bubbleMax) {
            [self transitionToNextStage];
        } else {
            [self redoStage];
        }
    }
}

-(BOOL)isCycleDone
{
    if (!_ranOnce || _explosion.active) {
        return FALSE;
    }
    for (Bubble *bubble in _bubbles) {
        if (bubble.exploding) {
            return FALSE;
        }
    }
    return TRUE;
}

-(void)addPoint
{
    _score++;
    [self updateDisplay];
}

-(void)updateDisplay
{
    _scoreDisplay.string = [NSString stringWithFormat:@"Level %d Score: %d / %d", _level+1, _score, _bubbleMax];
}

-(void)transitionToNextStage
{
    _level++;
    _totalScore += _score;
    [self saveProgress];
    [self loadStage];
}

-(void)redoStage
{
    [self loadStage];
}

-(void)returnToTitle
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"TitleScreen"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)saveProgress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:_level forKey:@"currentLevel"];
    [defaults setInteger:_totalScore forKey:@"currentScore"];
    [defaults synchronize];
}

-(void)loadProgress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"resumeLevel"]) {
        return;
    }

    _level      = [defaults integerForKey:@"currentLevel"];
    _totalScore = [defaults integerForKey:@"currentScore"];
}

@end
