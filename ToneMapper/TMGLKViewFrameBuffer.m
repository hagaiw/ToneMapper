//
//  TMGLKViewFrameBuffer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGLKViewFrameBuffer.h"

@interface TMGLKViewFrameBuffer ()

@property (strong, nonatomic) GLKView *glkView;
@property (nonatomic) CGSize screenSize;

@end

@implementation TMGLKViewFrameBuffer

- (instancetype)initWithGLKView:(GLKView *)glkView {
  if (self = [super init]) {
    self.glkView = glkView;
    self.screenSize = CGSizeMake(self.glkView.frame.size.width*[UIScreen mainScreen].scale,
                           self.glkView.frame.size.height*[UIScreen mainScreen].scale);
  }
  return self;
}

- (void)bind {
  [self.glkView bindDrawable];
}

- (CGSize)size {
  return self.screenSize;
}

@end
