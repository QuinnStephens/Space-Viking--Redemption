//
//  Viking.m
//  SpaceViking
//
//  Created by Quinn Stephens on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Viking.h"

@implementation Viking

@synthesize joystick;
@synthesize jumpButton;
@synthesize attackButton;

//Standing, Breathing, Walking 
@synthesize breathingAnim; 
@synthesize breathingMalletAnim; 
@synthesize walkingAnim; 
@synthesize walkingMalletAnim; 
// Crouching, Standing Up, Jumping 
@synthesize crouchingAnim;
@synthesize crouchingMalletAnim; 
@synthesize standingUpAnim;
@synthesize standingUpMalletAnim;
@synthesize jumpingAnim; 
@synthesize jumpingMalletAnim; 
@synthesize afterJumpingAnim; 
@synthesize afterJumpingMalletAnim; 
// Punching 
@synthesize rightPunchAnim; 
@synthesize leftPunchAnim; 
@synthesize malletPunchAnim; 
// Taking Damage and Death 
@synthesize phaserShockAnim; 
@synthesize deathAnim;

-(void) dealloc{
  joystick = nil;
  jumpButton = nil;
  attackButton = nil;
  [breathingAnim release];
  [breathingMalletAnim release];
  [walkingAnim release];
  [walkingMalletAnim release];
  [crouchingAnim release];
  [crouchingMalletAnim release];
  [standingUpAnim release];
  [standingUpMalletAnim release];
  [jumpingAnim release];
  [jumpingMalletAnim release];
  [afterJumpingAnim release];
  [afterJumpingMalletAnim release];
  [rightPunchAnim release];
  [leftPunchAnim release];
  [malletPunchAnim release];
  [phaserShockAnim release];
  [deathAnim release];
  
  [super dealloc];
}

-(BOOL) isCarryingWeapon{
  return isCarryingMallet;
}

-(int)getWeaponDamage{
  if(isCarryingMallet){
    return kVikingMalletDamage;
  }
  return kVikingFistDamage;
}

-(void) applyJoystick:(SneakyJoystick *)aJoystick forTimeDelta:(float)deltaTime{
  CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 128.0f);
  CGPoint oldPosition = [self position];
  CGPoint newPoistion = ccp(oldPosition.x + scaledVelocity.x * deltaTime, oldPosition.y);
  [self setPosition:newPoistion];
  
  if(oldPosition.x > newPoistion.x){
    self.flipX = YES;
  } else{
    self.flipX = NO;
  }
}

-(void) checkAndClampSpritePosition{
  if(self.characterState != kStateJumping){
    if([self position].y > 110.0f)
      [self setPosition:ccp([self position].x, 110.0f)];
  }
  [super checkAndClampSpritePosition];
}

#pragma mark -
-(void) changeState:(CharacterStates)newState{
  [self stopAllActions];
  id action = nil;
  id movementAction = nil;
  CGPoint newPosition;
  [self setCharacterState:newState];
  
  switch (newState) {
    case kStateIdle:
      if(isCarryingMallet){
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_mallet_1.png"]];
      } else{
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_1.png"]];
      }
      break;
    
    case kStateWalking:
      if(isCarryingMallet){
        action = [CCAnimate actionWithAnimation:walkingMalletAnim restoreOriginalFrame:NO];
      } else{
        action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
      }
      break;
    
    case kStateCrouching:
      if(isCarryingMallet){
        action = [CCAnimate actionWithAnimation:crouchingMalletAnim restoreOriginalFrame:NO];
      } else{
        action = [CCAnimate actionWithAnimation:crouchingAnim restoreOriginalFrame:NO];
      }
      break;
    
    case kStateBreathing:
      if(isCarryingMallet){
        action = [CCAnimate actionWithAnimation:breathingMalletAnim restoreOriginalFrame:NO];
      } else{
        action = [CCAnimate actionWithAnimation:breathingAnim restoreOriginalFrame:NO];
      }
      break;
      
    case kStateJumping:
      newPosition = ccp(screenSize.width * 0.2f, 0.0f);
      if([self flipX] == YES){
        newPosition = ccp(newPosition.x * -1.0f, 0.0f);
      }
      movementAction = [CCJumpBy actionWithDuration:0.5f position:newPosition height:160.0f jumps:1];
      if(isCarryingMallet){
        action = [CCSequence actions: [CCAnimate actionWithAnimation:crouchingMalletAnim restoreOriginalFrame:NO], [CCSpawn actions:[CCAnimate actionWithAnimation:jumpingMalletAnim restoreOriginalFrame:YES], movementAction, nil], [CCAnimate actionWithAnimation:afterJumpingMalletAnim restoreOriginalFrame:NO], nil];
      } else{
         action = [CCSequence actions: [CCAnimate actionWithAnimation:crouchingAnim restoreOriginalFrame:NO], [CCSpawn actions:[CCAnimate actionWithAnimation:jumpingAnim restoreOriginalFrame:YES], movementAction, nil], [CCAnimate actionWithAnimation:afterJumpingAnim restoreOriginalFrame:NO], nil];
      }
      break;
      
    case kStateAttacking:
      if(isCarryingMallet == YES){
        action = [CCAnimate actionWithAnimation:malletPunchAnim restoreOriginalFrame:YES];
      } else{
        if (kLeftHook == myLastPunch) {
          myLastPunch = kRightHook;
          action = [CCAnimate actionWithAnimation:rightPunchAnim restoreOriginalFrame:NO];
        } else{
          myLastPunch = kLeftHook;
          action = [CCAnimate actionWithAnimation:leftPunchAnim restoreOriginalFrame:NO];
        }
      }
      break;
      
    case kStateTakingDamage:
      self.characterHealth = self.characterHealth - 10.0f;
      action = [CCAnimate actionWithAnimation:phaserShockAnim restoreOriginalFrame:YES];
      break;
      
    case kStateDead:
      action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
      break;
      
    default:
      break;
  }
  if(action != nil){
    [self runAction:action];
  }
}

@end
