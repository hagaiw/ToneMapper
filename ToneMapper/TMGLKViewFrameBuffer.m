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

@end

@implementation TMGLKViewFrameBuffer

- (instancetype)initWithGLKView:(GLKView *)glkView {
  if (self = [super init]) {
    self.glkView = glkView;
  }
  return self;
}

- (void)bind {
  [self.glkView bindDrawable];
}

- (GLuint)height {
  return self.glkView.frame.size.height*2;  // TODO: why multiply by 2?
}

- (GLuint)width {
  return self.glkView.frame.size.width*2;
}

@end
