//
//  AppDelegate.h
//  TestGame
//
//  Created by Johnylaughingcor on 4/12/2014.
//  Copyright Johnylaughingcor 2014. All rights reserved.
//

#import "cocos2d.h"

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <VungleSDK/VungleSDK.h>
#import <Chartboost/Chartboost.h>
#import <Foundation/Foundation.h> 

#define BackgroundR 33
#define BackgroundG 52
#define BackgroundB 123

#define REVMOB_ID @"5491c9f0a9214f33166dcdc3"
#define ChartBoost_APPID @"5491cb6f0d6025764b70b1cf"
#define ChartBoost_Secret @"25e7ebaeaa7b9923dc7086af9a706e317ff623dc"
//#define VungleAppId @"53b6899f82cb511a550000b2"

#define RateURL @"http://www.google.com" // TODO: update in future
#define LeaderboardID @"com.twocars.leaderboard" // TODO: register for leaderbords

#define remove_ads @"com.king.yikyak" // ?


@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;

@end
