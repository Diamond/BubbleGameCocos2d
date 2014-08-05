//
//  Explosion.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

-(void)didLoadFromCCB
{
    self.active = FALSE;
}

-(void)startAt:(CGPoint)location
{
    self.active = TRUE;
    self.position              = location;
    self.anchorPoint           = ccp(0.5, 0.5);
    self.scale                 = 0.1f;
    CCActionScaleBy  *expand   = [CCActionScaleBy actionWithDuration:1.7f scale:10.0f];
    CCActionDelay    *delay    = [CCActionDelay actionWithDuration:0.7f];
    CCActionScaleBy  *shrink   = [CCActionScaleBy actionWithDuration:0.7f scale:0.0f];
    CCActionCallBlock *remove  = [CCActionCallBlock actionWithBlock:^{
        self.active = FALSE;
        [self removeFromParentAndCleanup:TRUE];
    }];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand, delay, shrink, remove]];
    [self runAction:sequence];
}

@end
