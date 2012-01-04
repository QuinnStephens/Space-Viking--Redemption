//
//  CommonProtocols.h
//  SpaceViking
//
//  Created by Quinn Stephens on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef SpaceViking_CommonProtocols_h
#define SpaceViking_CommonProtocols_h

typedef enum{
  kDirectionLeft,
  kDirectionRight
} PhaserDirection;

typedef enum {
  kStateSpawning,
  kStateIdle,
  kStateCrouching,
  kStateStandingUp,
  kStateWalking,
  kStateAttacking,
  kStateJumping, 
  kStateBreathing, 
  kStateTakingDamage, 
  kStateDead, 
  kStateTraveling,
  kStateRotating, 
  kStateDrilling, 
  kStateAfterJumping
} CharacterStates;

typedef enum{
  kObjectTypeNone,
  kPowerUpTypeHealth,
  kEnemyTypeRadarDish, 
  kEnemyTypeSpaceCargoShip,
  kEnemyTypeAlienRobot,
  kEnemyTypePhaser, 
  kVikingType,
  kSkullType, 
  kRockType, 
  kMeteorType, 
  kFrozenVikingType, 
  kIceType, 
  kLongBlockType,
  kCartType, 
  kSpikesType, 
  kDiggerType, 
  kGroundType 
} GameObjectType;

@protocol GameplayLayerDelegate

-(void) createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocation withZValue:(int)ZValue;

-(void) createPhaserWithDirection:(PhaserDirection)phaserDirection andPosition:(CGPoint)spawnPosition;

@end

#endif
