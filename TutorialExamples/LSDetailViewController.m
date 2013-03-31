//
//  LSDetailViewController.m
//  TutorialExamples
//
//  Created by Lingostar on 13. 3. 30..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSDetailViewController.h"
#import "TouchXML.h"

#define VMargin 20
#define VSmallMargin 5

#define ImageViewSize 180
#define LabelHeight 30
#define ScrollViewHeight 396
#define PageControlHeight 20

#define PageWidth 220
#define PageHeight 323
#define PageSpace 50

#define PageContentWidth 205
#define PageContentHeight 309

@interface LSDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    UILabel *_titleLabel;
	UIImageView *_iconImageView;
	UITableView *_descriptionTableView;
	UIImageView *_screenShotBG;
	UIScrollView *_screenShotPageView;
	UIPageControl *_screenShotPageControl;
	
	float _yPosition;
	float _descriptionTableViewHeight;
}

@end

@implementation LSDetailViewController

#pragma mark - View LifeCycle

- (void)loadView {
	UIScrollView *detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	UIColor *bkgColor = [UIColor colorWithRed:0.90 green:0.89 blue:0.86 alpha:1.0];
	detailScrollView.backgroundColor = bkgColor;
	
	_yPosition = VMargin;
	_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-ImageViewSize)/2, _yPosition, ImageViewSize, ImageViewSize)];
	[detailScrollView addSubview:_iconImageView];
	
	_yPosition = _yPosition + ImageViewSize + VMargin;
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _yPosition, 320, LabelHeight)];
	_titleLabel.font = [UIFont boldSystemFontOfSize:28];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.text = self.selectedExample.titleOfExample;
	_titleLabel.backgroundColor = [UIColor clearColor];
	[detailScrollView addSubview:_titleLabel];
	
	_yPosition = _yPosition + LabelHeight + VMargin;
	_descriptionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _yPosition, 320, 300) style:UITableViewStyleGrouped];
	_descriptionTableView.scrollEnabled = NO;
	_descriptionTableView.dataSource = self;
	_descriptionTableView.delegate = self;
    _descriptionTableView.backgroundView = nil;

	[detailScrollView addSubview:_descriptionTableView];
	
	_screenShotBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, _yPosition + 300, 320, ScrollViewHeight)];
	_screenShotBG.image = [UIImage imageNamed:@"scrollviewBG"];
	[detailScrollView addSubview:_screenShotBG];
	
	_screenShotPageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _yPosition + 300, 320, ScrollViewHeight)];
	_screenShotPageView.backgroundColor = [UIColor clearColor];
	_screenShotPageView.pagingEnabled = YES;
	_screenShotPageView.delegate = self;
	[detailScrollView addSubview:_screenShotPageView];
    
	_screenShotPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _yPosition + 300, 320, PageControlHeight)];
	_screenShotPageControl.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1.0];
	[detailScrollView addSubview:_screenShotPageControl];
	
	self.view = detailScrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    self.title = self.selectedExample.titleOfExample;
    
    UIBarButtonItem *goURLBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(goURL:)];
    self.navigationItem.rightBarButtonItem = goURLBarButton;
    
	int exampleId = self.selectedExample.idOfExample;
	NSString *request = [NSString stringWithFormat:
						 @"http://lingostar.co.kr/xml/index.php?param=item&no=%d", exampleId];
	NSURL *xmlURL = [NSURL URLWithString:request];
	NSString *xmlString = [NSString stringWithContentsOfURL:xmlURL
												   encoding:NSUTF8StringEncoding
													  error:nil];
	NSString *tidyXMLString = [xmlString stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithXMLString:tidyXMLString
															options:CXMLDocumentTidyXML
															  error:nil];
	NSArray *itemArray = [xmlDoc nodesForXPath:@"//item" error:nil];
	CXMLElement *currElement = [itemArray lastObject];
	NSMutableArray *screenshots = [[NSMutableArray alloc] initWithCapacity:10];
	
	int counter;
	for (counter = 0; counter < [currElement childCount]; counter++) {
		NSString *objString = [[[currElement childAtIndex:counter] stringValue] copy];
		NSString *keyString = [[[currElement childAtIndex:counter] name] copy];
		
		if ([keyString isEqualToString:@"icon"]) {
			self.selectedExample.iconPath = objString;
		} else if ([keyString isEqualToString:@"screenshot"]) {
			[screenshots addObject:objString];
		} else if ([keyString isEqualToString:@"desc"]) {
			self.selectedExample.descriptionOfExample = objString;
		} else if ([keyString isEqualToString:@"purpose"]) {
			self.selectedExample.purposeOfExample = objString;
		} else if ([keyString isEqualToString:@"chapter"]) {
			self.selectedExample.chapterOfExample = objString;
		} else if ([keyString isEqualToString:@"classes"]) {
			self.selectedExample.classOfExample = objString;
		} else if ([keyString isEqualToString:@"urlscheme"]) {
			self.selectedExample.urlScheme = objString;
		}
	}
	self.selectedExample.screenShotPathArray = screenshots;
}

- (void)goURL:(id)sender
{
    NSString *exampleURLString = [NSString stringWithFormat:@"%@://", self.selectedExample.urlScheme];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:exampleURLString]];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    dispatch_queue_t image_queue = dispatch_queue_create("image_queue", NULL);

	dispatch_async(image_queue, ^{
        NSData *iconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.selectedExample.iconPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _iconImageView.image = [UIImage imageWithData:iconData];
        });
    });
    
	CGSize tableViewSize = _descriptionTableView.contentSize;
	_descriptionTableView.frame = CGRectMake(0, _yPosition, tableViewSize.width, tableViewSize.height);
	_descriptionTableViewHeight = tableViewSize.height;
	
	_yPosition = _yPosition + _descriptionTableViewHeight + VMargin;
	_screenShotPageView.frame = CGRectMake(0, _yPosition, 320, ScrollViewHeight);
	_screenShotBG.frame = CGRectMake(0, _yPosition, 320, ScrollViewHeight);
	
	NSArray *screenShotArray = self.selectedExample.screenShotPathArray;
	int i, leftOrigin;
	for (i=0; i<[screenShotArray count]; i++) {
		leftOrigin = i*(PageWidth+PageSpace*2) + PageSpace;
		CGRect rect = CGRectMake(leftOrigin, 37, PageWidth, PageHeight);
		UIImageView *screenShotContentFrame = [[UIImageView alloc] initWithFrame:rect];
		screenShotContentFrame.image = [UIImage imageNamed:@"scrollviewFrame"];
		[_screenShotPageView addSubview:screenShotContentFrame];
		
		rect = CGRectMake(leftOrigin+6, 37+5, PageContentWidth, PageContentHeight);
		UIImageView *screenShotContentPage = [[UIImageView alloc] initWithFrame:rect];
		NSString *screenShotImagePath = [screenShotArray objectAtIndex:i];
		dispatch_async(image_queue, ^{
            NSData *screenshotData = [NSData dataWithContentsOfURL:[NSURL URLWithString:screenShotImagePath]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *screenshotImage = [UIImage imageWithData:screenshotData];
                screenShotContentPage.image = screenshotImage;
            });
        });
		[_screenShotPageView addSubview:screenShotContentPage];
	}
	_screenShotPageView.contentSize = CGSizeMake(leftOrigin + PageWidth+PageSpace, PageHeight);
    
	_yPosition = _yPosition + ScrollViewHeight;
	_screenShotPageControl.frame = CGRectMake(0, _yPosition, 320, PageControlHeight);
	_screenShotPageControl.numberOfPages = [screenShotArray count];
	_screenShotPageControl.currentPage = 0;
    
	float scrollViewHeight = _yPosition + PageControlHeight;
	[(UIScrollView *)self.view setContentSize:CGSizeMake(320, scrollViewHeight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	NSString *cellString;
	switch (indexPath.section) {
		case 0:
			cellString = self.selectedExample.descriptionOfExample;
			break;
		case 1:
			cellString = self.selectedExample.purposeOfExample;
			break;
		case 2:
			cellString = self.selectedExample.chapterOfExample;
			break;
		case 3:
			cellString = self.selectedExample.classOfExample;
			break;
	}
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
	cell.textLabel.numberOfLines = NSIntegerMax;
	cell.textLabel.text = cellString;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *sectionHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	NSString *sectionHeaderFileName = [NSString stringWithFormat:@"detailviewTitle%d", section];
	UIImage *sectionHeaderImage = [UIImage imageNamed:sectionHeaderFileName];
	sectionHeaderView.image = sectionHeaderImage;
	
	return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellString;
	switch (indexPath.section) {
		case 0:
			cellString = self.selectedExample.descriptionOfExample;
			break;
		case 1:
			cellString = self.selectedExample.purposeOfExample;
			break;
		case 2:
			cellString = self.selectedExample.chapterOfExample;
			break;
		case 3:
			cellString = self.selectedExample.classOfExample;
			break;
	}
	
	CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
	CGSize requiredSize = [cellString sizeWithFont:[UIFont systemFontOfSize:16]
                                 constrainedToSize:boundingSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat requiredHeight = requiredSize.height;
	
	return requiredHeight + 15;
}


#pragma mark -
#pragma mark ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	int pageNumber = _screenShotPageView.contentOffset.x / (PageWidth + PageSpace);
	_screenShotPageControl.currentPage = pageNumber;
}
							
@end
