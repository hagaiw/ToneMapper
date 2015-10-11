//
//  TMViewController.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <GLKit/GLKit.h>

#import <UIKit/UIKit.h>

@interface TMViewController : UIViewController <GLKViewDelegate>

- (void)switchImage;
- (void)saveImage;
- (void)moveImageByX:(GLfloat)x y:(GLfloat)y movementEnded:(BOOL)movementEnded;
- (void)zoomImageToScale:(GLfloat)scale zoomEnded:(BOOL)zoomEnded;

@end
