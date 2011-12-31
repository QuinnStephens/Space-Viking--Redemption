//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by Quinn Stephens on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer


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
  jumpButtonBase.pressSprite = [CCSprite spriteWithFile:@"jumpDwon.png"];
  jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
  jumpButton = [jumpButtonBase.button retain];
  jumpButton.isToggleable = NO;
  [self addChild:jumpButtonBase];
  
  SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
  attackButtonBase.position = attackButtonPosition;
  attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];
  attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
  attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDwon.png"];
  attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
  attackButton = [attackButtonBase.button retain];
  attackButton.isToggleable = NO;
  [self addChild:attackButtonBase];
}

-(void) applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime{
  CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0f);
  CGPoint newPosition = ccp(tempNode.position.x + scaledVelocity.x * deltaTime, tempNode.position.y);
  CGSize screenSize = [[CCDirector sharedDirector] winSize];
  if(newPosition.x > screenSize.width || newPosition.x < [tempNode boundingBox].size.width/2)
    newPosition.x = tempNode.position.x;
  [tempNode setPosition:newPosition];
  
  if(jumpButton.active == YES){
    CCLOG(@"Jump button pressed");
  }
  if(attackButton.active == YES){
    CCLOG(@"Attack button pressed");
  }
}

#pragma mark - 
#pragma mark Update Method
-(void) update:(ccTime)deltaTime{
  [self applyJoystick:leftJoystick toNode:vikingSprite forTimeDelta:deltaTime];
}

-(id) init{
  self = [super init];
  if(self != nil){
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    self.isTouchEnabled = YES;
    
    //vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
    CCSpriteBatchNode *chapter2SpriteBatchNode;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlas.plist"];
      chapter2SpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
    } else{
      [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];
      chapter2SpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];
    }
    vikingSprite = [CCSprite spriteWithSpriteFrameName:@"sv_anim_1.png"];
    [chapter2SpriteBatchNode addChild:vikingSprite];
    [self addChild:chapter2SpriteBatchNode];
    [vikingSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
    //[self addChild:vikingSprite];
    /* Animation tests
    CCSprite *animatingRobot = [CCSprite spriteWithFile:@"an1_anim1.png"];
    [animatingRobot setPosition:ccp([vikingSprite position].x + 50.0f, [vikingSprite position].y)];
    [self addChild:animatingRobot];
    
    CCAnimation *robotAnim = [CCAnimation animation];
    [robotAnim addFrameWithFilename:@"an1_anim2.png"];
    [robotAnim addFrameWithFilename:@"an1_anim3.png"];
    [robotAnim addFrameWithFilename:@"an1_anim4.png"];
    
    id robotAnimationAction = [CCAnimate actionWithDuration:0.5f animation:robotAnim restoreOriginalFrame:YES];
    id repeatRobotAnimation = [CCRepeatForever actionWithAction:robotAnimationAction];
    [animatingRobot runAction:repeatRobotAnimation];
    */
    CCAnimation *exampleAnim = [CCAnimation animation];
    for(int i=1; i <= 4; i++){
      [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"sv_anim_%d.png", i]]];
    }
    id animateAction = [CCAnimate actionWithDuration:0.5f animation:exampleAnim restoreOriginalFrame:NO];
    id repeatAction = [CCRepeatForever actionWithAction:animateAction];
    [vikingSprite runAction:repeatAction];
     
    
    [self initJoystickAndButtons];
    [self scheduleUpdate];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
      // scale down Ole if not on iPad
      [vikingSprite setScaleX:screenSize.width/1024.0f];
      [vikingSprite setScaleY:screenSize.height/768.0f];
    }
    return self;
  }
}

@end
