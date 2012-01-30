//
//  PhaserBullet.m
//  SpaceViking
//
//  Created by Quinn Stephens on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhaserBullet.h"

@implementation PhaserBullet

@synthesize myDirection;
@synthesize travelingAnim;
@synthesize firingAnim;

-(void) dealloc{
  [travelingAnim release];
  [firingAnim release];
  
  [super dealloc];
}

-(void) changeState:(CharacterStates)newState{
  [self stopAllActions];
  id action = nil;
  characterState = newState;
  switch (newState) {
    case kStateSpawning:
      CCLOG(@"Phaser->Changed state to Spawning");
      action = [CCAnimate actionWithAnimation:firingAnim restoreOriginalFrame:NO];
      break;
      
    case kStateTraveling:
      CCLOG(@"Phaser->Changed state to Traveling");
      CGPoint endLocation;
      if (myDirection == kDirectionLeft) {
        CCLOG(@"Phaser direction left");
        endLocation = ccp(-10.0f, [self position].y);
      } else{
        CCLOG(@"Phaser direction right");
        endLocation = ccp(screenSize.width + 24.0f, [self position].y);
      }
      [self runAction:[CCMoveTo actionWithDuration:2.0f position:endLocation]];
      action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:travelingAnim restoreOriginalFrame:NO]];
      break;
    
    case kStateDead:
      CCLOG(@"Phaser->Changed state to Dead");
      [self setVisible:NO];
      [self removeFromParentAndCleanup:YES];
      break;
                                                
    default:
      break;
  }
  if (action != nil) {
    [self runAction:action];
  }
}

-(BOOL) isOutsideOfScreen{
  CGPoint currentSpritePosition = [self position];
  if (currentSpritePosition.x < 0.0f || currentSpritePosition.x > screenSize.width) {
    [self changeState:kStateDead];
    return YES;
  }
  return NO;
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects{
  if ([self isOutsideOfScreen])
    return;
  if([self numberOfRunningActions] == 0){
    if (characterState == kStateSpawning) {
      [self changeState:kStateTraveling]; 
      return;
    } else{
      [self changeState:kStateDead];
      return;
    }
  }
}

-(void) initAnimations{
  [self setFiringAnim:[self loadPlistForAnimationWithName:@"firingAnim" andClassName:NSStringFromClass([self class])]];
  [self setTravelingAnim:[self loadPlistForAnimationWithName:@"travelingAnim" andClassName:NSStringFromClass([self class])]];
}

-(id) init{
  if (self = [super init]) {
    CCLOG(@"### PhaserBullet initialized");
    [self initAnimations];
    gameObjectType = kEnemyTypePhaser;
  }
  return self;
}

@end
