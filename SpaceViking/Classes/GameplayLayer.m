//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

-(void) dealloc{
  [leftJoystick release];
  [jumpButton release];
  [attackButton release];
  [super dealloc];
}


-(void) initJoystickAndButtons{
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  CGRect joystickBaseDimensions = CGRectMake(0, 0, 128.0f, 128.0f);
  CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
  CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
  CGPoint joystickBasePosition;
  CGPoint jumpButtonPosition;
  CGPoint attackButtonPosition;
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    // iPad running 3.2 or later
    CCLOG(@"Positioning joystick and buttons for iPad");
    joystickBasePosition = ccp(screenSize.width * 0.0625f, screenSize.height * 0.052f);
    jumpButtonPosition = ccp(screenSize.width * 0.946f, screenSize.height * 0.052f);
    attackButtonPosition = ccp(screenSize.width * 0.947f, screenSize.height * 0.169f);
  } else{
    // iPhone, iPod touch
    CCLOG(@"Positioning joystick and buttons for iPhone");
    joystickBasePosition = ccp(screenSize.width * 0.07f, screenSize.height * 0.11f);
    jumpButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.11f);
    attackButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.35f);
  }
  
  
  SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init ]autorelease];
  joystickBase.position = joystickBasePosition;
  joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
  joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
  joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
  leftJoystick = [joystickBase.joystick retain];
  [self addChild:joystickBase];
  
  SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
  jumpButtonBase.position = jumpButtonPosition;
  jumpButtonBase.defaultSprite = [CCSprite spriteWithFile:@"jumpUp.png"];
  jumpButtonBase.activatedSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
  jumpButtonBase.pressSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
  jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
  jumpButton = [jumpButtonBase.button retain];
  jumpButton.isToggleable = NO;
  [self addChild:jumpButtonBase];
  
  SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
  attackButtonBase.position = attackButtonPosition;
  attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];
  attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
  attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];
  attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
  attackButton = [attackButtonBase.button retain];
  attackButton.isToggleable = NO;
  [self addChild:attackButtonBase];
}

#pragma mark -
#pragma mark Update Method
-(void) update:(ccTime)deltaTime{
  CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
  for (GameCharacter *tempChar in listOfGameObjects){
    [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    if ([tempChar tag] == kRadarDishTagValue && [tempChar characterState] == kStateDead) {
      CCLOG(@"Radar dish destroyed. You win!");
    }
  }
}

#pragma mark -
-(void) createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocation withZValue:(int)ZValue{
  if (objectType == kEnemyTypeRadarDish) {
    CCLOG(@"Creating radar dish enemy");
    RadarDish *radarDish = [[RadarDish alloc] initWithSpriteFrameName:@"radar_1.png"];
    [radarDish setCharacterHealth:initialHealth];
    [radarDish setPosition:spawnLocation];
    [sceneSpriteBatchNode addChild:radarDish z:ZValue tag:kRadarDishTagValue];
    [radarDish release];
  }
}

-(void) createPhaserWithDirection:(PhaserDirection)phaserDirection andPosition:(CGPoint)spawnPosition{
  CCLOG(@"Placeholder for phaser");
  return;
}

-(id) init{
  self = [super init];
  if  (self != nil){
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.isTouchEnabled = YES;
    
    srandom(time(NULL)); // Seed random number generator
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
      [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlas.plist"];
      sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
    } else{
      [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];
      sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];
    }
    [self addChild:sceneSpriteBatchNode z:0];
    [self initJoystickAndButtons];
    Viking *viking = [[Viking alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_1.png"]];
    [viking setJoystick:leftJoystick];
    [viking setJumpButton:jumpButton];
    [viking setAttackButton:attackButton];
    [viking setPosition:ccp(screenSize.width * 0.35f, screenSize.height * 0.14f)];
    [viking setCharacterHealth:100];
    
    [sceneSpriteBatchNode addChild:viking z:kVikingSpriteZValue tag:kVikingSpriteTagValue];
    
    [self createObjectOfType:kEnemyTypeRadarDish withHealth:100 atLocation:ccp(screenSize.width * 0.878f, screenSize.height * 0.13f) withZValue:10];
    
    [self scheduleUpdate];
  }
  return self;
}

@end
