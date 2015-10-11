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

- (instancetype)initWithSourceTexture:(TMTexture *)sourceTexture {
  if (self = [super init]) {
    glGenFramebuffers(1, &_handle);
    [self bind];
    
    GLuint bufferTextureHandle;
    glGenTextures(1, &bufferTextureHandle);
    
    self.texture = [[TMTexture alloc] initWithHandle:bufferTextureHandle
                                                         target:GL_TEXTURE_2D
                                                         height:sourceTexture.height
                                                          width:sourceTexture.width];
    
    glBindTexture(GL_TEXTURE_2D, self.texture.handle);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.texture.width, self.texture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.texture.handle, 0);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
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
}

- (void)destroy {
  glDeleteBuffers(1, &_handle);
}

- (GLuint)height {
  return self.texture.height;
}

- (GLuint)width {
  return self.texture.width;
}

@end
