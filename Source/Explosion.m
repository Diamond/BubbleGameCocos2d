//
//  Explosion.m
//  BubbleGameCocos2d
//
//  Created by Brandon Richey on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

-(void)startAt:(CGPoint)location
{
    self.position              = location;
    self.anchorPoint           = ccp(0.5, 0.5);
    self.scale                 = 0.2f;
    CCActionScaleBy  *expand   = [CCActionScaleBy actionWithDuration:1.7f scale:10.0f];
    CCActionDelay    *delay    = [CCActionDelay actionWithDuration:0.7f];
    CCActionScaleBy  *shrink   = [CCActionScaleBy actionWithDuration:0.7f scale:0.0f];
    CCActionRemove   *remove   = [CCActionRemove action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[expand, delay, shrink, remove]];
    [self runAction:sequence];
}

@end
