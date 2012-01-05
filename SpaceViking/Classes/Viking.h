//
//  Viking.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GameCharacter.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"

typedef enum {
  kLeftHook,
  kRightHook
} LastPunchType;

@interface Viking : GameCharacter{
  LastPunchType myLastPunch;
  BOOL isCarryingMallet;
  CCSpriteFrame *standingFrame;
  
  // Standing, breathing, walking
  CCAnimation *breathingAnim;
  CCAnimation *breathingMalletAnim;
  CCAnimation *walkingAnim;
  CCAnimation *walkingMalletAnim;
  
  // Crouching, standing up, jumping
  CCAnimation *crouchingAnim;
  CCAnimation *crouchingMalletAnim;
  CCAnimation *standingUpAnim;
  CCAnimation *standingUpMalletAnim;
  CCAnimation *jumpingAnim;
  CCAnimation *afterJumpingAnim;
  CCAnimation *afterJumpingMalletAnim;
  
  // Punching
  CCAnimation *rightPunchAnim;
  CCAnimation *leftPunchAnim;
  CCAnimation *malletPunchAnim;
  
  // Taking damage, death
  CCAnimation *phaserShockAnim;
  CCAnimation *deathAnim;
  
  SneakyJoystick *joystick;
  SneakyButton *jumpButton;
  SneakyButton *attackButton;
  
  float millisecondsStayingIdle;
}
// Standing, breath, walking
@property (nonatomic, retain) CCAnimation *breathingAnim;
@property (nonatomic, retain) CCAnimation *breathingMalletAnim; 
@property (nonatomic, retain) CCAnimation *walkingAnim; 
@property (nonatomic, retain) CCAnimation *walkingMalletAnim; 
// Crouching, Standing Up, Jumping 
@property (nonatomic, retain) CCAnimation *crouchingAnim; 
@property (nonatomic, retain) CCAnimation *crouchingMalletAnim; 
@property (nonatomic, retain) CCAnimation *standingUpAnim; 
@property (nonatomic, retain) CCAnimation *standingUpMalletAnim; 
@property (nonatomic, retain) CCAnimation *jumpingAnim; 
@property (nonatomic, retain) CCAnimation *jumpingMalletAnim; 
@property (nonatomic, retain) CCAnimation *afterJumpingAnim; 
@property (nonatomic, retain) CCAnimation *afterJumpingMalletAnim; 
// Punching 
@property (nonatomic, retain) CCAnimation *rightPunchAnim; 
@property (nonatomic, retain) CCAnimation *leftPunchAnim; 
@property (nonatomic, retain) CCAnimation *malletPunchAnim;
//Taking Damage and Death 
@property (nonatomic, retain) CCAnimation *phaserShockAnim; 
@property (nonatomic, retain) CCAnimation *deathAnim; 
@property (nonatomic,assign) SneakyJoystick *joystick; 
@property (nonatomic,assign) SneakyButton *jumpButton; 
@property (nonatomic,assign) SneakyButton *attackButton;


@end
