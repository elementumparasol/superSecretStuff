

#import "cocos2d.h"

#import "IntroLayer.h"
#import "AppManager.h"
#import "AppDelegate.h"

@implementation MyNavigationController

-(NSUInteger)supportedInterfaceOrientations
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
	return UIInterfaceOrientationMaskPortrait;
}


//iOS < 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }

	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [IntroLayer scene]];
	}
}

@end


@implementation AppController

@synthesize window=window_,
            director=director_,
            navController=navController_;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //add ads stuff
    [RevMobAds startSessionWithAppID:REVMOB_ID];
    [Chartboost startWithAppId:ChartBoost_APPID appSignature:ChartBoost_Secret delegate:nil];
    
//    NSString* appID = VungleAppId;
//    VungleSDK* sdk = [VungleSDK sharedSDK];
//    [sdk startWithAppId:appID];
    
    if([[AppManager AppManagerSharedInstance] IsAppRunningFirstTime]){
    
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"removeads"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"soundBg"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
    }

    
	CCGLView * glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS *) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
    
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	[[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    
	return YES;
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}


// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    //TODO: detect when show app if it's active
//    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"removeads"]) {
//        if(arc4random()%2==0) {
//            [Chartboost showInterstitial:CBLocationHomeScreen];
//            [[RevMobAds session] showFullscreen];
//        }
//        else{
//            
//            VungleSDK* sdk = [VungleSDK sharedSDK];
//            [sdk playAd:self.window.rootViewController];
//        }
//    }

	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];	
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}


-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}


-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}


// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}


// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}


// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}
@end
