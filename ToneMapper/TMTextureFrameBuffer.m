 //
//  TMTextureFrameBuffer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureFrameBuffer ()

/// The \c GLuint handle of the frame buffer.
@property (nonatomic) GLuint handle;

/// The texture the frame buffer is backed on.
@property (readwrite, strong, nonatomic) TMTexture *texture;

@end

@implementation TMTextureFrameBuffer

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithSize:(CGSize)size {
  if (self = [super init]) {
    glGenFramebuffers(1, &_handle);
    [self bind];
    GLuint bufferTextureHandle;
    glGenTextures(1, &bufferTextureHandle);
    self.texture = [[TMTexture alloc] initWithHandle:bufferTextureHandle target:GL_TEXTURE_2D
                                                size:size];
    glBindTexture(GL_TEXTURE_2D, self.texture.handle);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.texture.size.width, self.texture.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.texture.handle,
                              0);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
      NSLog(@"Failed to make complete framebuffer object %x", status);
    }

  }
  return self;
}

#pragma mark -
#pragma mark TMFrameBuffer
#pragma mark -

- (void)bind {
  glBindFramebuffer(GL_FRAMEBUFFER, self.handle);
}

- (CGSize)size {
  return self.texture.size;
}

#pragma mark -
#pragma mark Destruction
#pragma mark -

- (void)dealloc {
  GLuint handle = self.handle;
  glDeleteFramebuffers(1, &handle);
}

@end

NS_ASSUME_NONNULL_END
