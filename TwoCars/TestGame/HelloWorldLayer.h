//
//  HelloWorldLayer.h
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//

#import "cocos2d.h"

#import <GameKit/GameKit.h>
//#import "AppDelegate.h"2
// When you import this file, you import all the cocos2d classes
#import "GameKitHelper.h"
#import <RevMobAds/RevMobAds.h>
#import <VungleSDK/VungleSDK.h>
#import <Chartboost/Chartboost.h>
#import <Foundation/Foundation.h> 


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, GameKitHelperProtocol>
{
    CGSize winSize;
    
    int car1Index;
    int car2Index;
    
    CCSprite *car1Sp;
    CCSprite *car2Sp;
    
    NSMutableArray *spritesArray;
    CCParticleSystemQuad *particle;
    CCParticleSystemQuad *particle2;
    
    CCLabelTTF *scoreLabel;
    
    BOOL isGameOver;
    UIImage *screenImage;
    UIPopoverController *popup;
    
    int score;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
