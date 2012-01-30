//
//  EnemyRobot.m
//  SpaceViking
//
//  Created by Quinn Stephens on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnemyRobot.h"

@implementation EnemyRobot

@synthesize delegate;
@synthesize robotWalkingAnim;
@synthesize raisePhaserAnim;
@synthesize shootPhaserAnim;
@synthesize lowerPhaserAnim;
@synthesize torsoHitAnim;
@synthesize headHitAnim;
@synthesize robotDeathAnim;

-(void) dealloc{
  delegate = nil;
  [robotWalkingAnim release];
  [raisePhaserAnim release];
  [shootPhaserAnim release];
  [lowerPhaserAnim release];
  [torsoHitAnim release];
  [headHitAnim release];
  [robotDeathAnim release];
  [super dealloc];
}

-(void) shootPhaser{
  CGPoint phaserFiringPosition;
  PhaserDirection phaserDir;
  CGRect boundingBox = [self boundingBox];
  CGPoint position = [self position];
  float xPostion = position.x + boundingBox.size.width * 0.542f;
  float yPosition = position.y + boundingBox.size.height * 0.25f;
  
  if ([self flipX]) {
    CCLOG(@"Facing right, firing to the right");
    phaserDir = kDirectionRight;
  } else{
    CCLOG(@"Facing left, firing to the left");
    xPostion = position.x - boundingBox.size.width * 0.542f;
    phaserDir = kDirectionLeft;
  }
  phaserFiringPosition = ccp(xPostion, yPosition);
  [delegate createPhaserWithDirection:phaserDir andPosition:phaserFiringPosition];
}

-(CGRect) eyesightBoundingBox{
  // 3 robot widths in direction robot is facing
  CGRect robotSightBoundingBox;
  CGRect robotBoundingBox = [self adjustedBoundingBox];
  if([self flipX]){
    robotSightBoundingBox = CGRectMake(robotBoundingBox.origin.x, robotBoundingBox.origin.y, robotBoundingBox.size.width * 3.0f, robotBoundingBox.size.height);
  } else {
    robotSightBoundingBox = CGRectMake(robotBoundingBox.origin.x - robotBoundingBox.size.width*2.0f, robotBoundingBox.origin.y, robotBoundingBox.size.width*3, robotBoundingBox.size.height);
  }
  return robotSightBoundingBox;
}

-(void) changeState:(CharacterStates)newState{
  if (characterState == kStateDead) {
    return;
  }
  [self stopAllActions];
  id action = nil;
  characterState = newState;
  switch (newState) {
    case kStateSpawning:
      [self runAction:[CCFadeOut actionWithDuration:0.0f]];
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"teleport.png"]];
      action = [CCSpawn actions:[CCRotateBy actionWithDuration:1.5f angle:360], [CCFadeIn actionWithDuration:1.5f], nil];
      break;
      
    case kStateIdle:
      CCLOG(@"EnemyRobot->Changing State to Idle");
      [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"an1_anim1.png"]];
      break;
      
    case kStateWalking:
      CCLOG(@"EnemyRobot->Changing State to Walking");
      if (isVikingWithinBoundingBox) {
        break;
      }
      float xPositionOffset = 150.0f;
      if (isVikingWithinSight) {
        if ([vikingCharacter position].x < [self position].x)
          xPositionOffset *= -1;
      } else{
        if (CCRANDOM_0_1() > 0.5f)
          xPositionOffset *= -1;
        if (xPositionOffset > 0.0f) {
          [self setFlipX:YES];
        } else{
          [self setFlipX:NO];
        }
      }
      action = [CCSpawn actions:[CCAnimate actionWithAnimation:robotWalkingAnim restoreOriginalFrame:NO], [CCMoveTo actionWithDuration:2.4f position:ccp([self position].x + xPositionOffset, [self position].y)], nil];
      break;
      
    case kStateAttacking:
      CCLOG(@"EnemyRobot->Changing State to Attacking");
      action = [CCSequence actions:
                [CCAnimate actionWithAnimation:raisePhaserAnim restoreOriginalFrame:NO],
                [CCDelayTime actionWithDuration:1.0f],
                [CCAnimate actionWithAnimation:shootPhaserAnim restoreOriginalFrame:NO],
                [CCCallFunc actionWithTarget:self selector:@selector(shootPhaser)],
                [CCAnimate actionWithAnimation:lowerPhaserAnim restoreOriginalFrame:NO],
                [CCDelayTime actionWithDuration:2.0f],
                nil];
      break;
      
    case kStateTakingDamage:
      CCLOG(@"EnemyRobot->Changing State to TakingDamage");
      if ([vikingCharacter getWeaponDamage] > kVikingFistDamage) {
        action = [CCAnimate actionWithAnimation:headHitAnim restoreOriginalFrame:YES];
      } else{
        action = [CCAnimate actionWithAnimation:torsoHitAnim restoreOriginalFrame:YES];
      }
      break;
      
    case kStateDead:
      CCLOG(@"EnemyRobot->Changing State to Dead");
      action = [CCSequence actions:
                [CCAnimate actionWithAnimation:robotDeathAnim restoreOriginalFrame:NO],
                [CCDelayTime actionWithDuration:2.0f],
                [CCFadeOut actionWithDuration:2.0f],
                nil];
      break;
      
    default:
      CCLOG(@"EnemyRobot->Unknown CharState %d", characterState);
      break;
  }
  if (action != nil) {
    [self runAction:action];
  }
}

-(void) updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects{
  [self checkAndClampSpritePosition];
  if (characterState != kStateDead && characterHealth <= 0) {
    [self changeState:kStateDead];
    return;
  }
  
  vikingCharacter = (GameCharacter*)[[self parent] getChildByTag:kVikingSpriteTagValue];
  CGRect vikingBoundingBox = [vikingCharacter adjustedBoundingBox];
  CGRect robotBoundingBox = [self adjustedBoundingBox];
  CGRect robotSightBoundingBox = [self eyesightBoundingBox];
  
  isVikingWithinBoundingBox = CGRectIntersectsRect(vikingBoundingBox, robotBoundingBox) ? YES : NO;
  isVikingWithinSight = CGRectIntersectsRect(vikingBoundingBox, robotSightBoundingBox) ? YES : NO;
  
  if (isVikingWithinBoundingBox && [vikingCharacter characterState] == kStateAttacking) {
    // Viking is attacking this robot
    if (characterState != kStateTakingDamage && characterState != kStateDead){
      [self setCharacterHealth:[self characterHealth] - [vikingCharacter getWeaponDamage]];
      if (characterHealth > 0) {
        [self changeState:kStateTakingDamage];
      } else{
        [self changeState:kStateDead];
      }
      return;
    }
  }
  
  if ([self numberOfRunningActions] == 0) {
    if (characterState == kStateDead) { // This robot is dead
      [self setVisible:NO];
      [self removeFromParentAndCleanup:YES];
    } else if ([vikingCharacter characterState] == kStateDead){ // The viking is dead
      [self changeState:kStateWalking];
    } else if (isVikingWithinSight){ // Viking is within sight
      [self changeState:kStateAttacking];
    } else { // Viking is alive and out of sight
      [self changeState:kStateWalking];
    }
  }
}

-(CGRect) adjustedBoundingBox{
  CGRect enemyRobotBoundingBox = [self boundingBox];
  float xOffsetAmount = enemyRobotBoundingBox.size.width * 0.18f;
  float yCropAmount = enemyRobotBoundingBox.size.height * 0.05f;
  enemyRobotBoundingBox = CGRectMake(enemyRobotBoundingBox.origin.x + xOffsetAmount, enemyRobotBoundingBox.origin.y, enemyRobotBoundingBox.size.width - xOffsetAmount, enemyRobotBoundingBox.size.height - yCropAmount);
  return enemyRobotBoundingBox;
}

#pragma mark - initAnimations
-(void) initAnimations{
  [self setRobotWalkingAnim:[self loadPlistForAnimationWithName:@"robotWalkingAnim" andClassName:NSStringFromClass([self class])]];
  [self setRaisePhaserAnim:[self loadPlistForAnimationWithName:@"raisePhaserAnim" andClassName:NSStringFromClass([self class])]];
  [self setShootPhaserAnim:[self loadPlistForAnimationWithName:@"shootPhaserAnim" andClassName:NSStringFromClass([self class])]];
  [self setLowerPhaserAnim:[self loadPlistForAnimationWithName:@"lowerPhaserAnim" andClassName:NSStringFromClass([self class])]];
  [self setTorsoHitAnim:[self loadPlistForAnimationWithName:@"torsoHitAnim" andClassName:NSStringFromClass([self class])]];
  [self setHeadHitAnim:[self loadPlistForAnimationWithName:@"headHitAnim" andClassName:NSStringFromClass([self class])]];
  [self setRobotDeathAnim:[self loadPlistForAnimationWithName:@"robotDeathAnim" andClassName:NSStringFromClass([self class])]];
}

-(id) init{
  if(self = [super init]){
    isVikingWithinBoundingBox = NO;
    isVikingWithinSight = NO;
    gameObjectType = kEnemyTypeAlienRobot;
    [self initAnimations];
    srandom(time(NULL));
  }
  return self;
}

@end
