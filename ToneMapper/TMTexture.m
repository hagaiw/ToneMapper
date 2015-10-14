//
//  TMTexture.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTexture.h"

@implementation TMTexture

@synthesize handle = _handle;
@synthesize target = _target;
@synthesize size = _size;

- (instancetype)initWithImage:(UIImage *)image {
  if (self = [super init]) {
    glActiveTexture(GL_TEXTURE0);
    NSError *textureLoaderError;

    NSLog(@"Error pre-loading = %u", glGetError()); // Fixes an issue where GLKTextureLoader returns nil
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[image CGImage] options:nil error:&textureLoaderError];
    self = [self initWithHandle:info.name target:info.target height:info.height width:info.width];
  }
  return self;
}

- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target height:(GLuint)height
                         width:(GLuint)width {
  if (self = [super init]) {
    _handle = handle;
    _target = target;
    _size = CGSizeMake(width, height);
  }
  return self;
}

- (void)bind {
  glBindTexture(self.target, self.handle);
}


- (void)dealloc {
  GLuint textureHandle = self.handle;
  glDeleteTextures(1, &textureHandle);
}

@end
