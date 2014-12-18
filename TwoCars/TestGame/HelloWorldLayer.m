//
//  HelloWorldLayer.m
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "IntroLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "InAppPurchaseManager.h"


#pragma mark - HelloWorldLayer

#define index1 0
#define index2 1
#define index3 2
#define index4 3

@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene * scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    HelloWorldLayer * layer = [HelloWorldLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super's" return value
    if((self=[super init])) {
        [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:0];
        winSize= [[CCDirector sharedDirector] winSize];
        spritesArray=[[NSMutableArray alloc] init];
        [self LoadGame];
        [self schedule:@selector(addEnemyAndCoins) interval:1];
        [self schedule:@selector(collisionDetection)];
        isGameOver=NO;
        score=0;
    }
    
    return self;
}


-(void) onEnter
{
    [super onEnter];
    ccColor4B color = {BackgroundR,BackgroundG,BackgroundB,255};
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:color];
    [self addChild:colorLayer z:-1];
}


-(void)LoadGame
{
    CCSprite * spLeft=[CCSprite spriteWithFile:@"pixel.png"];
    CCSprite * spRight=[CCSprite spriteWithFile:@"pixel.png"];
    CCSprite * spCenter=[CCSprite spriteWithFile:@"pixel.png"];
    
    spLeft.position=ccp((winSize.width/4), 0);
    spCenter.position=ccp((winSize.width/2), 0);
    spRight.position=ccp(((winSize.width/4)*3), 0);
    
    spLeft.anchorPoint=ccp(0.5, 0);
    spRight.anchorPoint=ccp(0.5, 0);
    spCenter.anchorPoint=ccp(0.5, 0);
    
    spLeft.scaleX=2;
    spRight.scaleX=2;
    spCenter.scaleX=4;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        spCenter.scaleY=2*winSize.height;
        spLeft.scaleY=2*winSize.height;
        spRight.scaleY=2*winSize.height;
    }
    else {
        spCenter.scaleY=winSize.height;
        spLeft.scaleY=winSize.height;
        spRight.scaleY=winSize.height;
    }

    [self addChild:spLeft];
    [self addChild:spRight];
    [self addChild:spCenter];
    
    car1Sp=[CCSprite spriteWithFile:@"car1.png"];
    car2Sp=[CCSprite spriteWithFile:@"car2.png"];
    
    car1Sp.position=ccp((winSize.width/4)-(winSize.width/8), 100);
    car2Sp.position=ccp(winSize.width-(winSize.width/8), 100);
    
    car1Sp.anchorPoint=ccp(0.5, 0.3);
    car2Sp.anchorPoint=ccp(0.5, 0.3);
    
    [self addChild:car1Sp];
    [self addChild:car2Sp];
    
    car1Index=index1;
    car2Index=index4;
    
    particle = [CCParticleSystemQuad particleWithFile:@"particle-car-red.plist"]; //alt plist working with rainbow.plist
    particle.position = ccp((winSize.width/4)-(winSize.width/8), 140-car1Sp.boundingBox.size.height/2);
    [self addChild:particle z:20];
    particle.anchorPoint=ccp(0.5, 1);
    particle.autoRemoveOnFinish = YES;
    
    particle2 = [CCParticleSystemQuad particleWithFile:@"particle-car-green.plist"]; //alt plist working with rainbow.plist
    particle2.position = ccp(winSize.width-(winSize.width/8), 140-car2Sp.boundingBox.size.height/2);
    [self addChild:particle2 z:20];
    particle2.anchorPoint=ccp(0.5, 1);
    particle2.autoRemoveOnFinish = YES;
    
    scoreLabel=[CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:30];
    scoreLabel.position=ccp(winSize.width - scoreLabel.dimensions.width - 40, winSize.height * 0.9);
    [self addChild:scoreLabel];
}


-(void)addEnemyAndCoins
{
    int car1hurdleRand=arc4random()%2;
    int car2hurdleRand=arc4random()%2;
    
    //TODO: update algorithm for generating objects + speed up game using time/distance params
    if(car1hurdleRand) {
        CCSprite * sp=[CCSprite spriteWithFile:@"square1.png"];
        if(arc4random()%2) {
            sp.position=ccp((winSize.width/8)*1, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=1;
        }
        else {
            sp.position=ccp((winSize.width/8)*3, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=3;
        }
        CCMoveBy * move=[CCMoveBy actionWithDuration:2.2 position:ccp(0, -(winSize.height+sp.boundingBox.size.height))];
        CCSequence * seq=[CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)], nil];
        [sp runAction:seq];
        [spritesArray addObject:sp];
    }
    else {
        CCSprite * sp=[CCSprite spriteWithFile:@"circle1.png"];
        if(arc4random()%2){
            sp.position=ccp((winSize.width/8)*1, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=2;
        }
        else {
            sp.position=ccp((winSize.width/8)*3, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=4;
        }
        CCMoveBy * move=[CCMoveBy actionWithDuration:2.2 position:ccp(0, -winSize.height)];
        CCSequence * seq=[CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(gameOverWithCircle:)], nil];
        [sp runAction:seq];
        [spritesArray addObject:sp];
    }
    if(car2hurdleRand) {
        CCSprite * sp=[CCSprite spriteWithFile:@"square2.png"];
        if (arc4random()%2){
            sp.position=ccp((winSize.width/8)*5, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=5;
        }
        else {
            sp.position=ccp((winSize.width/8)*7, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=7;
        }
        CCMoveBy * move=[CCMoveBy actionWithDuration:2.2 position:ccp(0, -(winSize.height+sp.boundingBox.size.height))];
        CCSequence * seq=[CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)], nil];
        [sp runAction:seq];
        [spritesArray addObject:sp];
    }
    else {
        CCSprite * sp=[CCSprite spriteWithFile:@"circle2.png"];
        if (arc4random()%2){
            sp.position=ccp((winSize.width/8)*5, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=6;
        }
        else {
            sp.position=ccp((winSize.width/8)*7, winSize.height);
            sp.anchorPoint=ccp(0.5, 0);
            [self addChild:sp];
            sp.tag=8;
        }
        CCMoveBy * move=[CCMoveBy actionWithDuration:2.2 position:ccp(0, -winSize.height)];
        CCSequence * seq=[CCSequence actions:move,[CCCallFuncN actionWithTarget:self selector:@selector(gameOverWithCircle:)], nil];
        [sp runAction:seq];
        [spritesArray addObject:sp];
    }
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    
    // don't forget to call "super dealloc"
    [super dealloc];
}


- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //TODO: update touch after game is ended, there's some kind of delay
    if (isGameOver) {
        return;
    }
    
    //TODO: utiilize code for rotation
    UITouch * touch=[touches anyObject];
    NSArray * objects=[touches allObjects];
    NSLog(@"%lu",(unsigned long)objects.count);
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if(touchLocation.x<winSize.width/2) {
        NSLog(@"Left");
        [car1Sp stopAllActions];
        if (car1Index==index1) {
            car1Index=index2;
            CCRotateTo * rotate=[CCRotateTo actionWithDuration:0.1 angle:30];
            CCMoveTo * move=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*3, 100)];
            CCMoveTo * move2=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*3, 140-car1Sp.boundingBox.size.height/2)];
            [particle runAction:move2];
            [car1Sp runAction:rotate];
            CCRotateTo * rotate2=[CCRotateTo actionWithDuration:0.1 angle:0];
            CCSequence * seq=[CCSequence actions:move,rotate2, nil];
            [car1Sp runAction:seq];
        }
        else{
            car1Index=index1;
            CCRotateTo * rotate=[CCRotateTo actionWithDuration:0.1 angle:-30];
            [car1Sp runAction:rotate];
            CCMoveTo * move=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*1, 100)];
            CCMoveTo * move2=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*1, 140-car1Sp.boundingBox.size.height/2)];
            [particle runAction:move2];
            CCRotateTo * rotate2=[CCRotateTo actionWithDuration:0.1 angle:0];
            CCSequence * seq=[CCSequence actions:move,rotate2, nil];
            [car1Sp runAction:seq];
        }
    }
    else {
        [car2Sp stopAllActions];
        NSLog(@"Right");
        if (car2Index==index3) {
            car2Index=index4;
            CCRotateTo * rotate=[CCRotateTo actionWithDuration:0.1 angle:30];
            [car2Sp runAction:rotate];
            CCMoveTo * move=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*7, 100)];
            CCMoveTo * move2=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*7, 140-car1Sp.boundingBox.size.height/2)];
            [particle2 runAction:move2];
            CCRotateTo * rotate2=[CCRotateTo actionWithDuration:0.1 angle:0];
            CCSequence * seq=[CCSequence actions:move,rotate2, nil];
            [car2Sp runAction:seq];
        }
        else {
            car2Index=index3;
            CCRotateTo * rotate=[CCRotateTo actionWithDuration:0.1 angle:-30];
            [car2Sp runAction:rotate];
            CCMoveTo * move=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*5, 100)];
            CCMoveTo * move2=[CCMoveTo actionWithDuration:0.2 position:ccp((winSize.width/8)*5, 140-car1Sp.boundingBox.size.height/2)];
            [particle2 runAction:move2];
            CCRotateTo * rotate2=[CCRotateTo actionWithDuration:0.1 angle:0];
            CCSequence * seq=[CCSequence actions:move,rotate2, nil];
            [car2Sp runAction:seq];
        }
    }
    return;
}


-(void)collisionDetection
{
    //TODO: add checking for lifes
    //TODO: utilize removing during collision
    
    for(CCSprite * sp in spritesArray) {
        if(sp.position.y>100 && sp.position.y<150) {
            if(sp.tag==1 && car1Index==index1) {
                [self GameOverWithSquareCollision:sp];
                break;
            }
            else if(sp.tag==2 && car1Index==index1) {
                [self removeCircleSpriteOnCollision:sp];
                break;
            }
            else if(sp.tag==3 && car1Index==index2) {
                [self GameOverWithSquareCollision:sp];
                break;
            }
            else if(sp.tag==4 && car1Index==index2) {
                [self removeCircleSpriteOnCollision:sp];
                break;
            }
            else if(sp.tag==5 && car2Index==index3) {
                [self GameOverWithSquareCollision:sp];
                break;
            }
            else if(sp.tag==6 && car2Index==index3) {
                [self removeCircleSpriteOnCollision:sp];
                break;
            }
            else if(sp.tag==7 && car2Index==index4) {
                [self GameOverWithSquareCollision:sp];
                break;
            }
            else if(sp.tag==8 && car2Index==index4) {
                [self removeCircleSpriteOnCollision:sp];
                break;
            }
        }
    }
}


-(void)removeCircleSpriteOnCollision:(CCSprite*)sp
{
    //TODO: update score stuff, more elegant way
    score++;
    scoreLabel.string=[NSString stringWithFormat:@"%d",score];
    [self removeSprite:sp];
}


-(void)removeSprite:(CCSprite*)sp
{
    [self removeChild:sp cleanup:YES];
    [spritesArray removeObject:sp];
}


-(void)gameOverWithCircle:(CCSprite*)sp
{
    //TODO add sound + change action
    
    for (CCSprite *sp in spritesArray) {
        [sp stopAllActions];
    }
    id action1=[CCFadeOut actionWithDuration:0.1];
    id action2=[CCDelayTime actionWithDuration:0.1];
    id action3=[CCFadeIn actionWithDuration:0.1];
    id action4=[CCDelayTime actionWithDuration:0.1];
    id action5=[CCFadeOut actionWithDuration:0.1];
    id action6=[CCDelayTime actionWithDuration:0.1];
    id action7=[CCFadeIn actionWithDuration:0.1];
    CCSequence * seq=[CCSequence actions:action1,action2,action3,action4,action5,action6,action7,[CCCallFunc actionWithTarget:self selector:@selector(GameOver)], nil];
    [sp runAction:seq];
}


-(void)GameOverWithSquareCollision:(CCSprite*)sp
{
    //TODO: update sound + change action
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"sound"])
        [[SimpleAudioEngine sharedEngine] playEffect:@"colide.caf"];
    
    if (sp.tag<5) {
        CCParticleSystemQuad * particleExplode = [CCParticleSystemQuad particleWithFile:@"particle-car-red-explode.plist"]; //alt plist working with rainbow.plist
        particleExplode.position = sp.position;
        [self addChild:particleExplode z:20];
        particleExplode.autoRemoveOnFinish = YES;
    }
    else {
        CCParticleSystemQuad * particleExplode = [CCParticleSystemQuad particleWithFile:@"particle-car-green-explode.plist"]; //alt plist working with rainbow.plist
        particleExplode.position = sp.position;
        [self addChild:particleExplode z:20];
        particleExplode.autoRemoveOnFinish = YES;
    }
    
    [self removeSprite:sp];
    
    for(CCSprite *sp in spritesArray) {
        [sp stopAllActions];
    }
    
    [self GameOver];
}


-(void)GameOver
{
    isGameOver=YES;
    [self stopAllActions];
    [self unscheduleAllSelectors];
    [self LoadMenu];
}


-(void)LoadMenu
{
    //TODO: add ads logic here
//    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"removeads"]) {
//        if (arc4random()%2==0) {
//            [Chartboost showInterstitial:CBLocationHomeScreen];
//            [[RevMobAds session] showFullscreen];
//        }
//        else{
//            AppController *appdelegate=[UIApplication sharedApplication].delegate;
//            VungleSDK* sdk = [VungleSDK sharedSDK];
//            [sdk playAd:appdelegate.window.rootViewController];
//        }
//    }

    int best= (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"best"];
    
    if (best<score) {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"best"];
        best=score;
    }
    
    ccColor4B color = {0,0,0,155};
    CCLayerColor * colorLayer = [CCLayerColor layerWithColor:color];
    [self addChild:colorLayer];
    
    scoreLabel.visible = NO;
    
    CCLabelTTF * gameOverLabel=[CCLabelTTF labelWithString:@"Game Over" fontName:@"Helvetica" fontSize:50];
    gameOverLabel.position=ccp(winSize.width/2, winSize.height*0.9);
    [self addChild:gameOverLabel];
    
    CCLabelTTF * scoreLabel1=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score   %d\nBest   %d",score,best] fontName:@"Helvetica" fontSize:40];
    scoreLabel1.position=ccp(winSize.width/2, winSize.height*0.7);
    [self addChild:scoreLabel1];
    
    BOOL soundBg = [[NSUserDefaults standardUserDefaults] boolForKey:@"soundBg"];
    
    CCMenuItemImage * replayButton = [CCMenuItemImage itemWithNormalImage:@"replay.png" selectedImage:@"replay.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    }];
    
    CCMenuItemImage * homeButton =[CCMenuItemImage itemWithNormalImage:@"home.png" selectedImage:@"home.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] ]];
            }];
    
    CCMenuItemImage * gameCenterButton =[CCMenuItemImage itemWithNormalImage:@"gc.png" selectedImage:@"gc.png" block:^(id sender) {
        GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
        gkHelper.delegate = self;
        [gkHelper authenticateLocalPlayer];
        [gkHelper submitScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"best"] category:LeaderboardID];
        [gkHelper showAchievements];
    }];
    
    CCMenuItemImage * shareButton =[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"share.png"] selectedImage:[NSString stringWithFormat:@"share.png"] block:^(id sender) {
        [self screenshotWithStartNode:self];
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"Image.jpg"];
        NSData *imageData = UIImageJPEGRepresentation(screenImage, 0.8);
        [imageData writeToFile:savedImagePath atomically:YES];
        NSURL *imageUrl = [NSURL fileURLWithPath:savedImagePath];
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[RateURL, imageUrl]
                                          applicationActivities:nil];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [popup presentPopoverFromRect:CGRectMake([[CCDirector sharedDirector] navigationController].view.frame.size.width/2-50, [[CCDirector sharedDirector] navigationController].view.frame.size.height/2+150, 100, 100) inView:[[CCDirector sharedDirector] navigationController].view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        else
            [[[CCDirector sharedDirector] navigationController] presentViewController:activityViewController
                                                                             animated:YES
                                                                           completion:^{}];
    }];
    
    CCMenuItemImage * removeAdsButton =[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"removeads.png"] selectedImage:[NSString stringWithFormat:@"removeads%i.png",soundBg] block:^(id sender) {
        [[InAppPurchaseManager InAppPurchaseManagerSharedInstance] PurchaseProductWithNumber:1 Delegate:nil WithSelector:nil WithErrorSelector:nil];
    }];
    
    [replayButton retain];
    [homeButton retain];
    [gameCenterButton retain];
    [shareButton retain];
    [removeAdsButton retain];

    replayButton.position=ccp(winSize.width*0.5, winSize.height*0.5);
    homeButton.position=ccp(winSize.width*0.2, winSize.height*0.3);
    gameCenterButton.position=ccp(winSize.width*0.4, winSize.height*0.3);
    shareButton.position=ccp(winSize.width*0.6, winSize.height*0.3);
    removeAdsButton.position=ccp(winSize.width*0.8, winSize.height*0.3);
    
    CCMenu *menu=[CCMenu menuWithItems:replayButton,homeButton,gameCenterButton,shareButton,removeAdsButton, nil];
    menu.position=ccp(0, 0);
    menu.anchorPoint=ccp(0, 0);
    [self addChild:menu];
}


#pragma mark GameKit delegate
#pragma mark GameKitHelper delegate methods

-(void) onLocalPlayerAuthenticationChanged
{
    GKLocalPlayer * localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
    
    if (localPlayer.authenticated)
    {
        GameKitHelper * gkHelper = [GameKitHelper sharedGameKitHelper];
        [gkHelper getLocalPlayerFriends];
        //[gkHelper resetAchievements];
    }
}


-(void) onFriendListReceived:(NSArray*)friends
{
    CCLOG(@"onFriendListReceived: %@", [friends description]);
    GameKitHelper * gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper getPlayerInfo:friends];
}


-(void) onPlayerInfoReceived:(NSArray*)players
{
    CCLOG(@"onPlayerInfoReceived: %@", [players description]);
}


-(void) onScoresSubmitted:(bool)success
{
    CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}


-(void) onScoresReceived:(NSArray*)scores
{
    CCLOG(@"onScoresReceived: %@", [scores description]);
    GameKitHelper * gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper showAchievements];
}


-(void) onAchievementReported:(GKAchievement*)achievement
{
    CCLOG(@"onAchievementReported: %@", achievement);
}


-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
    CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
}


-(void) onResetAchievements:(bool)success
{
    CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}


-(void) onLeaderboardViewDismissed
{
    CCLOG(@"onLeaderboardViewDismissed");
    
    GameKitHelper * gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper retrieveTopTenAllTimeGlobalScores];
}


-(void) onAchievementsViewDismissed
{
    CCLOG(@"onAchievementsViewDismissed");
}


-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
    CCLOG(@"receivedMatchmakingActivity: %i", (int)activity);
}


-(void) onMatchFound:(GKMatch*)match
{
    CCLOG(@"onMatchFound: %@", match);
}


-(void) onPlayersAddedToMatch:(bool)success
{
    CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}


-(void) onMatchmakingViewDismissed
{
    CCLOG(@"onMatchmakingViewDismissed");
}


-(void) onMatchmakingViewError
{
    CCLOG(@"onMatchmakingViewError");
}


-(void) onPlayerConnected:(NSString*)playerID
{
    CCLOG(@"onPlayerConnected: %@", playerID);
}


-(void) onPlayerDisconnected:(NSString*)playerID
{
    CCLOG(@"onPlayerDisconnected: %@", playerID);
}


-(void) onStartMatch
{
    CCLOG(@"onStartMatch");
}


-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
    CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}


-(void) screenshotWithStartNode:(CCNode*)stNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize windowsSize = [[CCDirector sharedDirector] winSize];
    CCRenderTexture * renTxture =
    [CCRenderTexture renderTextureWithWidth:windowsSize.width
                                     height:windowsSize.height];
    [renTxture begin];
    [stNode visit];
    [renTxture end];
    
    screenImage=[renTxture getUIImage];
}

@end
