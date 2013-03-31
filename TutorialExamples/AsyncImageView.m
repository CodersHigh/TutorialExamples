//
//  AsyncImageView.m
//  TutorialExamples
//
//  Created by JokerPortable on 11. 5. 10..
//  Copyright 2011 LingoStar. All rights reserved.
//

#import "AsyncImageView.h"


@implementation AsyncImageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadImageFromURL:(NSURL *)url
{
	_fileName = [[[url path] lastPathComponent] copy];
	NSString *savePath = [[self applicationDocumentDirectory] 
						  stringByAppendingPathComponent:_fileName];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		UIImageView *imageView = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"loading.png"]];
		[self addSubview:imageView];
		imageView.frame = self.bounds;
		[imageView setNeedsLayout];
		[self setNeedsLayout];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
		_asynConnection = [[NSURLConnection alloc] initWithRequest:request 
                                                          delegate:self];
	} else {
		NSData *imageData = [NSData dataWithContentsOfFile:savePath];
		[self updateImageViewWithData:imageData];
	}
}

- (NSString *)applicationDocumentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES);
	return [paths lastObject];
}


#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_receivedData == nil) _receivedData = [[NSMutableData alloc] initWithCapacity:2048];
	[_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	_asynConnection = nil;
	if ([self.subviews count] > 0){
		[[self.subviews lastObject] removeFromSuperview];
	}
	[self updateImageViewWithData:_receivedData];
	[self saveImage:_receivedData];
}

- (void)updateImageViewWithData:(NSData *)imageData
{
	UIImageView *imageView = [[UIImageView alloc] initWithImage:
							   [UIImage imageWithData:imageData]];
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(updateAsyncImageView:)])
		[_delegate updateAsyncImageView:self];
}

- (UIImage *)image
{
	UIImageView *imageView = [self.subviews lastObject];
	return imageView.image;
}

- (void)saveImage:(NSData *)imageData
{
	NSString *savePath = [[self applicationDocumentDirectory] 
						  stringByAppendingPathComponent:_fileName];
	
	BOOL result = [imageData writeToFile:savePath atomically:NO];
}

@end
