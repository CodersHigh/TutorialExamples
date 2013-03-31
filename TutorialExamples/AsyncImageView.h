//
//  AsyncImageView.h
//  TutorialExamples
//
//  Created by JokerPortable on 11. 5. 10..
//  Copyright 2011 LingoStar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
    NSURLConnection *_asynConnection;
	NSMutableData *_receivedData;
	NSString *_fileName;
	
	id _delegate;
}

- (void)loadImageFromURL:(NSURL *)url;
- (UIImage *)image;
- (void)saveImage:(NSData *)imageData;
- (void)updateImageViewWithData:(NSData *)imageData;
- (NSString *)applicationDocumentDirectory;

@property (assign) id delegate;
@end

@protocol AsyncImageViewDelegate
@required
- (void)updateAsyncImageView:(AsyncImageView *)asyncImageView;
@end
