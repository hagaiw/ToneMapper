 //
//  TMTextureFrameBuffer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureFrameBuffer.h"

@interface TMTextureFrameBuffer ()

@property (nonatomic) GLuint handle;
@property (readwrite, strong, nonatomic) TMTexture *texture;

@end

@implementation TMTextureFrameBuffer

- (instancetype)initWithSize:(CGSize)size {
  if (self = [super init]) {
    glGenFramebuffers(1, &_handle);
    NSLog(@"GL Error = %u", glGetError());
    [self bind];
    NSLog(@"GL Error = %u", glGetError());
    
    GLuint bufferTextureHandle;
    glGenTextures(1, &bufferTextureHandle);
    NSLog(@"GL Error = %u", glGetError());
    
    self.texture = [[TMTexture alloc] initWithHandle:bufferTextureHandle
                                                         target:GL_TEXTURE_2D
                                                         height:size.height
                                                          width:size.width];
    
    glBindTexture(GL_TEXTURE_2D, self.texture.handle);
    NSLog(@"GL Error = %u", glGetError());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    NSLog(@"GL Error = %u", glGetError());
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.texture.size.width, self.texture.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    NSLog(@"GL Error = %u", glGetError());
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.texture.handle, 0);
    NSLog(@"GL Error = %u", glGetError());
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    NSLog(@"GL Error = %u", glGetError());
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    NSLog(@"GL Error = %u", glGetError());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    NSLog(@"GL Error = %u", glGetError());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    NSLog(@"GL Error = %u", glGetError());
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
      NSLog(@"failed to make complete framebuffer object %x", status);
    }

  }
  return self;
}
- (void)bind {
  glBindFramebuffer(GL_FRAMEBUFFER, self.handle);
  NSLog(@"Framebuffer Bind = %u", glGetError());
}

- (void)dealloc {
  GLuint handle = self.handle;
  glDeleteFramebuffers(1, &handle);
  NSLog(@"Framebuffer Delete Error = %u", glGetError());
}

- (CGSize)size {
  return self.texture.size;
}

@end
