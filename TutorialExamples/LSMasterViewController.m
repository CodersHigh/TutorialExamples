//
//  LSMasterViewController.m
//  TutorialExamples
//
//  Created by Lingostar on 13. 3. 30..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSMasterViewController.h"
#import "LSDetailViewController.h"
#import "LSAppDelegate.h"
#import "LSExample.h"

@interface LSMasterViewController ()
@end

@implementation LSMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Example List", @"Example List");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.rowHeight = 63;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.2 saturation:0.8 brightness:0.2 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LSAppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[self appDelegate].exampleArray count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *cellBkgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listFrame"]];
        [cell.contentView addSubview:cellBkgView];
    }
    
    LSExample *currExample = [[self appDelegate].exampleArray objectAtIndex:indexPath.row];
	
    UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:currExample.thumbnailPath]];
	UIImage *thumbImage = [UIImage imageWithData:imageData];
	thumbnailImageView.image = thumbImage;
	[cell.contentView addSubview:thumbnailImageView];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 200, 30)];
	titleLabel.font = [UIFont boldSystemFontOfSize:21];
	titleLabel.textColor = [UIColor darkGrayColor];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = currExample.titleOfExample;
	[cell.contentView addSubview:titleLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[LSDetailViewController alloc] initWithNibName:@"LSDetailViewController" bundle:nil];
    }
    //NSDate *object = _objects[indexPath.row];
    //self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
