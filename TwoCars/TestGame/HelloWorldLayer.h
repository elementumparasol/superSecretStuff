//
//  HelloWorldLayer.h
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//


#import <GameKit/GameKit.h>
//#import "AppDelegate.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <RevMobAds/RevMobAds.h>
#import <Chartboost/Chartboost.h>
#import <VungleSDK/VungleSDK.h>
#import <Foundation/Foundation.h> 


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CGSize winSize;
    
    CCSprite *car1Sp;
    CCSprite *car2Sp;
    int car1Index;
    int car2Index;
    
    NSMutableArray *spritesArray;
    CCParticleSystemQuad *particle;
    CCParticleSystemQuad *particle2;
    
    CCLabelTTF *scoreLabel;
    
    UIPopoverController *popup;
    UIImage *screenImage;
    BOOL isGameOver;
    
    int score;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
