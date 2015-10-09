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
@synthesize height = _height;
@synthesize width = _width;

- (instancetype)initWithImagePath:(NSString *)imagePath {
  if (self = [super init]) {
    glActiveTexture(GL_TEXTURE0);
    NSError *textureLoaderError;

    NSLog(@"GL Error = %u", glGetError()); // Fixes an issue where GLKTextureLoader returns nil
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:imagePath options:nil error:&textureLoaderError];
    self = [self initWithHandle:info.name target:info.target height:info.height width:info.width];
  }
  return self;
}

- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target height:(GLuint)height
                         width:(GLuint)width {
  if (self = [super init]) {
    _handle = handle;
    _target = target;
    _height = height;
    _width = width;
  }
  return self;
}

- (void)bind {
  glBindTexture(self.target, self.handle);
}


- (void)destroy {
  GLuint textureHandle = self.handle;
  glDeleteTextures(1, &textureHandle);
}

@end
