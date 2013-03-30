//
//  LSMasterViewController.h
//  TutorialExamples
//
//  Created by Lingostar on 13. 3. 30..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSDetailViewController;

@interface LSMasterViewController : UITableViewController

@property (strong, nonatomic) LSDetailViewController *detailViewController;

@end
