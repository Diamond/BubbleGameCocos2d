//
//  TransitionScene.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 8/5/14.
//  Copyright (c) 2014 Sagadev/Brandon Richey. All rights reserved.
//

#import "TransitionScene.h"
#import "MainScene.h"
#import "TitleScreen.h"

@implementation TransitionScene {
    CCLabelTTF *_levelDisplay;
    CCLabelTTF *_scoreDisplay;
    int        _level;
    int        _totalScore;
}

-(id)init
{
    if (self = [super init]) {
        _level      = 0;
        _totalScore = 0;
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self loadDetails];
    [self updateDisplay];
}

-(void)loadDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _level      = [defaults integerForKey:@"currentLevel"];
    _totalScore = [defaults integerForKey:@"currentScore"];
}

-(void)updateDisplay
{
    _levelDisplay.string = [NSString stringWithFormat:@"Current Level: %d", _level];
    _scoreDisplay.string = [NSString stringWithFormat:@"Current Score: %d", _totalScore];
}

-(void)playNextLevel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"resumeLevel"];
    [defaults synchronize];
    
    MainScene *gameplayScene = (MainScene*)[CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)quitGame
{
    int currentTopScore = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:FALSE forKey:@"resumeLevel"];
    currentTopScore = [defaults integerForKey:@"topScore"];
    if (_totalScore > currentTopScore) {
        [defaults setInteger:_totalScore forKey:@"topScore"];
    }
    [defaults synchronize];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"TitleScreen"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
