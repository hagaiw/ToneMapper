//
//  TMOpenGLHandler.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGLHandler.h"


@interface TMGLHandler ()

@property (readwrite, strong, nonatomic) EAGLContext *context;

@property (readwrite, strong, nonatomic) TMImageProgram *imageProgram;

@property (nonatomic) CGRect viewFrame;

@property (nonatomic) GLuint projectionUniform;
@property (nonatomic) GLuint textureUniform;

@property (nonatomic) GLfloat counter; // TODO delete

@end

@implementation TMGLHandler

typedef struct {
  float Position[3];
  float TexCoord[2];
} Vertex;

static const Vertex Vertices[] = {
  {{1, -1, -1}, {1, 0}},
  {{1, 1, -1}, {1, 1}},
  {{-1, 1, -1}, {0, 1}},
  {{-1, -1, -1}, {0, 0}}
};

static const GLubyte Indices[] = {
  0, 1, 2,
  2, 3, 0
};

- (instancetype)init{
  self.counter = 0.1; // TODO delete
  if (self = [super init]) {
    [self initContext];
  }
  return self;
}

- (void)setViewFrame:(CGRect)viewFrame {
  _viewFrame = viewFrame;
}

- (void)initContext {
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
}

- (void)setProgram:(TMImageProgram *)imageProgram {
  self.imageProgram = imageProgram;
  [self setupGL];
  glUseProgram(self.imageProgram.program);
}

- (void)setupGL {
  [self setAttributes];
  [self initVBOs];
}

- (void)setAttributes {
  glEnableVertexAttribArray(self.imageProgram.positionSlot);
  glEnableVertexAttribArray(self.imageProgram.textureSlot);
  glVertexAttribPointer(self.imageProgram.positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
  glVertexAttribPointer(self.imageProgram.textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
}

- (void)initVBOs {
  
  GLuint vertexBuffer;
  GLuint indexBuffer;
  
  glGenBuffers(1, &vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
  
  glGenBuffers(1, &indexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
  
  glVertexAttribPointer(self.imageProgram.positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
  glVertexAttribPointer(self.imageProgram.textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
}

- (void)drawInRect:(CGRect)rect {

  // DEBUG TODO:delete
  self.counter = self.counter + 0.1;
  if (self.counter >= 1.0) {
    self.counter = 0.0;
  }
  // DEBUG
  
  // BG Color
  glClearColor(self.counter, 0.0, 0.5, 1.0);

  glClear(GL_COLOR_BUFFER_BIT);
  
  // Projection matrix:
  float h = 4.0f * rect.size.height / rect.size.width;
  GLKMatrix4 projectionMatrix = GLKMatrix4MakeFrustum(-2, 2, h/2, -h/2, 1, 1);
  glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.m);
  
  // Draw
  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)saveImage {
  
  GLuint width = self.viewFrame.size.width;
  GLuint height = self.viewFrame.size.height;
  
  //create new offscreen frame buffer:
  
  // create and bind:
  GLuint framebuffer;
  glGenFramebuffers(1, &framebuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
  
  GLuint depthRenderbuffer;
  glGenRenderbuffers(1, &depthRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
  
  GLuint colorRenderbuffer;
  glGenRenderbuffers(1, &colorRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
  glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA4, width, height);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
  
  GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
  if(status != GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"failed to make complete framebuffer object %x", status);
  }
  
  glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
  
  
  // Draw
  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
  
  
//  GLubyte* pixels = (GLubyte*) malloc(width * height * sizeof(GLubyte) * 4);
//  glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
//  
//  
  
  ////////
  int s = 1;
  
  const int w = width/2;
  const int h = height/2;
  const NSInteger myDataLength = w * h * 4 * s * s;
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, w*s, h*s, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  // gl renders "upside down" so swap top to bottom into new array.
  // there's gotta be a better way, but this works.
  GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
  for(int y = 0; y < h*s; y++)
  {
    memcpy( buffer2 + (h*s - 1 - y) * w * 4 * s, buffer + (y * 4 * w * s), w * 4 * s );
  }
  free(buffer); // work with the flipped buffer, so get rid of the original one.
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * w * s;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(w*s, h*s, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  // then make the uiimage from that
  UIImage *myImage = [ UIImage imageWithCGImage:imageRef scale:s orientation:UIImageOrientationUp ];
  UIImageWriteToSavedPhotosAlbum( myImage, nil, nil, nil );
  CGImageRelease( imageRef );
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpaceRef);
  free(buffer2);
}





@end
