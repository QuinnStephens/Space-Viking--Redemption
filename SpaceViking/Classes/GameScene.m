//
//  GameScene.m
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id) init{
  self = [super init];
  if(self!=nil){
    BackgroundLayer *backgroundLayer = [BackgroundLayer node]; //node is alloc init together
    [self addChild:backgroundLayer z:0];
    
    GameplayLayer *gameplayLayer = [GameplayLayer node];
    [self addChild:gameplayLayer z:5];
  }
  return self;
}

@end
