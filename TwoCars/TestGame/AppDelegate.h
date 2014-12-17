//
//  AppDelegate.h
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <RevMobAds/RevMobAds.h>
#import <Chartboost/Chartboost.h>
#import <VungleSDK/VungleSDK.h>
#import <Foundation/Foundation.h> 

#define BackgroundR 33
#define BackgroundG 52
#define BackgroundB 123

#define REVMOB_ID @"5225791aad76267017000015"
#define ChartBoost_APPID @"526932e616ba47926f000010"
#define ChartBoost_Secret @"d3fa366b2389ce044f5fa7f25a77aba018dfcb5e"
#define VungleAppId @"53b6899f82cb511a550000b2"

#define LeaderboardID @"com.twocars.leaderboard"
#define RateURL @"http://www.google.com"

#define remove_ads @"com.king.yikyak"


@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
