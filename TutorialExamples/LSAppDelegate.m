//
//  LSAppDelegate.m
//  TutorialExamples
//
//  Created by Lingostar on 13. 3. 30..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSMasterViewController.h"
#import "LSExample.h"

@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _exampleArray = [[NSMutableArray alloc] initWithArray:[self createDummy]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    LSMasterViewController *masterViewController = [[LSMasterViewController alloc] initWithNibName:@"LSMasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray *)createDummy
{
    LSExample *dummyExample = [[LSExample alloc] init];
	
    dummyExample.titleOfExample = @"LightTheCandle";
    dummyExample.descriptionOfExample = @"스위치를 켜고 끄면 이미지 뷰의 촛불 그림과 레이블의 문자가 변하는 기본적인 예제";
    dummyExample.purposeOfExample = @"Xcode와 InterfaceBuilder의 사용법에 친숙해지고 Obj-C의 기본 문법과 메세징 방식을 익힌다";
    dummyExample.chapterOfExample = @"Ch3, Ch4, Ch5";
    dummyExample.classOfExample = @"NSObject, UILabel, UIImageView, UISwitch";
    NSString *thumbnailPath = [[NSBundle mainBundle] pathForResource:@"LightTheCandle_Thumb" ofType:@"png"];
    dummyExample.thumbnailPath = thumbnailPath;
	
    NSString *iconPath = [[NSBundle mainBundle] pathForResource:@"LightTheCandle_Icon" ofType:@"png"];
    dummyExample.iconPath = iconPath;
	
    NSString *screenShot1 = [[NSBundle mainBundle] pathForResource:@"LightTheCandleScreenShot_1" ofType:@"png"];
    NSString *screenShot2 = [[NSBundle mainBundle] pathForResource:@"LightTheCandleScreenShot_2" ofType:@"png"];
    dummyExample.screenShotPathArray = [NSArray arrayWithObjects:screenShot1, screenShot2, nil];
	
    return [NSArray arrayWithObject:dummyExample];
}

@end
