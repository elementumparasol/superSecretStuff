//
//  IntroLayer.m
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//


#import "IntroLayer.h"
#import "GameKitHelper.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "InAppPurchaseManager.h"

#pragma mark - IntroLayer

@implementation IntroLayer


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	IntroLayer *layer = [IntroLayer node];
	[scene addChild: layer];
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
        winSize= [[CCDirector sharedDirector] winSize];
        [self LoadGame];
        [self LoadMenu];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundBg"]) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.caf"];
        }
	}
	
	return self;
}


-(void)LoadMenu{

    BOOL soundBg=[[NSUserDefaults standardUserDefaults] boolForKey:@"soundBg"];
    
    CCMenuItemImage *item1=[CCMenuItemImage itemWithNormalImage:@"play.png" selectedImage:@"play.png" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
    }];
    
    CCMenuItemImage *item2=[CCMenuItemImage itemWithNormalImage:@"gc.png" selectedImage:@"gc.png" block:^(id sender) {
        GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
        gkHelper.delegate = self;
        [gkHelper authenticateLocalPlayer];
        [gkHelper submitScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"best"] category:LeaderboardID];
        [gkHelper showAchievements];
    }];
    
    CCMenuItemImage *item3=[CCMenuItemImage itemWithNormalImage:@"rate.png" selectedImage:@"rate.png" block:^(id sender) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:RateURL]];
    }];
    
    CCMenuItemImage *item4=[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"music%d.png",soundBg] selectedImage:[NSString stringWithFormat:@"music%d.png",soundBg] block:^(id sender) {
        BOOL soundBg=[[NSUserDefaults standardUserDefaults] boolForKey:@"soundBg"];
        [[NSUserDefaults standardUserDefaults] setBool:!soundBg forKey:@"soundBg"];
        [sender setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"music%d.png",soundBg]]];
        if (!soundBg) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.caf"];
        }
        else{
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
    }];
    CCMenuItemImage *item5=[CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"volume%d.png",soundBg] selectedImage:[NSString stringWithFormat:@"volume%d.png",soundBg] block:^(id sender) {
        BOOL soundBg=[[NSUserDefaults standardUserDefaults] boolForKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] setBool:!soundBg forKey:@"sound"];
        [sender setNormalImage:[CCSprite spriteWithFile:[NSString stringWithFormat:@"volume%d.png",soundBg]]];
    }];
    CCMenuItemImage *item6=[CCMenuItemImage itemWithNormalImage:@"restore.png" selectedImage:@"restore.png" block:^(id sender) {
        [[InAppPurchaseManager InAppPurchaseManagerSharedInstance] Restore_ProductsWithDelegate:nil WithSelector:nil WithErrorSelector:nil];
    }];
    
    [item1 retain];
    [item2 retain];
    [item3 retain];
    [item4 retain];
    [item5 retain];
    [item6 retain];
    

        item1.position=ccp(winSize.width*0.5, winSize.height*0.6);
        item2.position=ccp(winSize.width*0.1, winSize.height*0.4);
        item3.position=ccp(winSize.width*0.3, winSize.height*0.4);
        item4.position=ccp(winSize.width*0.5, winSize.height*0.4);
        item5.position=ccp(winSize.width*0.7, winSize.height*0.4);
        item6.position=ccp(winSize.width*0.9, winSize.height*0.4);
    
    CCMenu *menu=[CCMenu menuWithItems:item1,item2,item3,item4,item5,item6, nil];
    menu.position=ccp(0, 0);
    menu.anchorPoint=ccp(0, 0);
    [self addChild:menu];
    
    CCLabelTTF *gameOverLabel=[CCLabelTTF labelWithString:@"2 Cars" fontName:@"Helvetica" fontSize:50];
    gameOverLabel.position=ccp(winSize.width/2, winSize.height*0.9);
    [self addChild:gameOverLabel];
    
    
    
}
-(void)LoadGame{
    
    CCSprite *spCenter=[CCSprite spriteWithFile:@"pixel.png"];
    CCSprite *spLeft=[CCSprite spriteWithFile:@"pixel.png"];
    CCSprite *spRight=[CCSprite spriteWithFile:@"pixel.png"];
    
    
   
    
    spCenter.position=ccp((winSize.width/2), 0);
    spLeft.position=ccp((winSize.width/4), 0);
    spRight.position=ccp(((winSize.width/4)*3), 0);
    
    spCenter.anchorPoint=ccp(0.5, 0);
    spLeft.anchorPoint=ccp(0.5, 0);
    spRight.anchorPoint=ccp(0.5, 0);
    
    
    spCenter.scaleX=4;
    spLeft.scaleX=2;
    spRight.scaleX=2;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        spCenter.scaleY=2*winSize.height;
        spLeft.scaleY=2*winSize.height;
        spRight.scaleY=2*winSize.height;
    }else{
        spCenter.scaleY=winSize.height;
        spLeft.scaleY=winSize.height;
        spRight.scaleY=winSize.height;
    }
    
    
    
    [self addChild:spCenter];
    [self addChild:spLeft];
    [self addChild:spRight];
    
    car1Sp=[CCSprite spriteWithFile:@"car1.png"];
    car2Sp=[CCSprite spriteWithFile:@"car2.png"];
    
    car1Sp.position=ccp((winSize.width/4)-(winSize.width/8), 100);
    car2Sp.position=ccp(winSize.width-(winSize.width/8), 100);
    
    car1Sp.anchorPoint=ccp(0.5, 0.3);
    car2Sp.anchorPoint=ccp(0.5, 0.3);
    
    [self addChild:car1Sp];
    [self addChild:car2Sp];
    ccColor4B color = {0,0,0,155};
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:color];
    [self addChild:colorLayer];

    
}
-(UIImage*) screenshotWithStartNode:(CCNode*)stNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCRenderTexture* renTxture =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [renTxture begin];
    [stNode visit];
    [renTxture end];
    
    return [renTxture getUIImage];
}

-(void) onEnter
{
	[super onEnter];
    ccColor4B color = {BackgroundR,BackgroundG,BackgroundB,255};
    CCLayerColor *colorLayer = [CCLayerColor layerWithColor:color];
    [self addChild:colorLayer z:-1];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}

#pragma mark GameKit delegate
#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
    
    if (localPlayer.authenticated)
    {
        GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
        [gkHelper getLocalPlayerFriends];
        //[gkHelper resetAchievements];
    }
}
-(void) onFriendListReceived:(NSArray*)friends
{
    CCLOG(@"onFriendListReceived: %@", [friends description]);
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
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
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
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
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper retrieveTopTenAllTimeGlobalScores];
}
-(void) onAchievementsViewDismissed
{
    CCLOG(@"onAchievementsViewDismissed");
}
-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
    CCLOG(@"receivedMatchmakingActivity: %i", activity);
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


@end
