

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameKitHelper.h"

@interface IntroLayer : CCLayer <GameKitHelperProtocol> {
    CGSize winSize;
    
    CCSprite *car1Sp;
    CCSprite *car2Sp;

}

+(CCScene *) scene;

@end
