//
//  LSAppDelegate.h
//  TutorialExamples
//
//  Created by Lingostar on 13. 3. 30..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (readonly) NSMutableArray *exampleArray;

@end
