//
//  Mallet.m
//  SpaceViking
//
//  Created by Quinn Stephens on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Mallet.h"

@implementation Mallet
@synthesize malletAnim;

-(void) dealloc {
  [malletAnim release];
  [super dealloc];
}

-(void) changeState:(CharacterStates)newState{
  if (newState == kStateSpawning) {
    id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:malletAnim restoreOriginalFrame:NO]];
    [self runAction:action];
  } else{
    [self setVisible:NO]; // Picked up
    [self removeFromParentAndCleanup:YES];
  }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects{
  float groundHeight = screenSize.height * 0.065f;
  if ([self position].y > groundHeight) {
    [self setPosition:ccp([self position].x, [self position].y - 5.0f)];
  }
}

-(void) initAnimations{
  [self setMalletAnim:[self loadPlistForAnimationWithName:@"malletAnim" andClassName:NSStringFromClass([self class])]];
}

-(id) init{
  if (self=[super init]) {
    screenSize = [CCDirector sharedDirector].winSize;
    gameObjectType = kPowerUpTypeMallet;
    [self initAnimations];
    [self changeState:kStateSpawning];
  }
  return self;
}

@end
