//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMViewController.h"
#import "TMProgram.h"
#import "TMTexturedGeometry.h"
#import "TMQuadTexturedVertices.h"
#import "TMTexture.h"
#import "TMTextureFrameBuffer.h"
#import "TMTextureDrawer.h"
#import "TMTextureProgram.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMProjectionFactory.h"
#import "TMProgramFactory.h"
#import "TMTextureProcessorFactory.h"
#import "TMTextureDisplay.h"
#import "TMPosition.h"


NS_ASSUME_NONNULL_BEGIN

@interface TMViewController ()

@property (strong, nonatomic) TMTextureProcessor *processor;
@property (strong, nonatomic) TMTextureDisplay *display;
@property (strong, nonatomic) TMTexture *inputTexture;
@property (strong, nonatomic) TMTexture *processedTexture;
@property (strong, nonatomic) TMPosition *texturePosition;
@property (strong, nonatomic) TMPosition *tempTexturePosition;
@property (strong, nonatomic) TMProgramFactory *programFactory;
@property (strong, nonatomic) GLKView *glkView;
@property (strong, nonatomic) EAGLContext *context;

@property (nonatomic) BOOL textureNeedsProcessing;

@end

@implementation TMViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  
  self.textureNeedsProcessing = false;
  
  self.texturePosition = [[TMPosition alloc] initWithTranslation:CGPointMake(0.0, 0.0) scale:1.0];
  self.tempTexturePosition = self.texturePosition;
  
  self.programFactory = [TMProgramFactory new];
  
  self.processor = [[TMTextureProcessorFactory new]
                    processorWithProgram:[self.programFactory textureProcessingProgram]];
  
  self.glkView = [GLKView new];
  self.glkView.delegate = self;
  self.glkView.context = self.context;
  self.glkView.opaque = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self initGLKView:self.glkView];
  self.display = [[TMTextureDisplay alloc]
                        initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc]
                                             initWithGLKView:self.glkView]
                                    program:[self.programFactory textureDisplayProgram]
                                   geometry:[[TMTexturedGeometry alloc]
                                             initWithTexturedVertices:
                                               [TMQuadTexturedVertices new]]];
}

- (void)initGLKView:(GLKView *)glkView {
  glkView.frame = self.view.frame;
  self.view = glkView;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.0, 0.8, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  if(self.textureNeedsProcessing) {
    self.processedTexture = [self.processor processAndFlipTexture:self.inputTexture];
    self.textureNeedsProcessing = false;
  }
  [self.display displayTexture:self.processedTexture displayData:self.texturePosition];
}

- (void)switchImage:(UIImage *)image {
  self.inputTexture = [[TMTexture alloc] initWithImage:image];
  self.textureNeedsProcessing = true;
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)moveImageByX:(GLfloat)x y:(GLfloat)y movementEnded:(BOOL)movementEnded {
  TMPosition *positionDelta = [[TMPosition alloc] initWithTranslation:CGPointMake(x, y) scale:1.0];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:movementEnded];
}

- (void)zoomImageByScale:(GLfloat)scale positionX:(GLfloat)positionX positionY:(GLfloat)positionY
               zoomEnded:(BOOL)zoomEnded {
  TMPosition *positionDelta = [[TMPosition alloc]
                               initWithTranslation:CGPointMake(0.0, 0.0)
                                             scale:scale];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:zoomEnded];
}

- (void)updateTexturePositionWithPosition:(TMPosition *)position gestureEnded:(BOOL)gestureEnded{
  self.texturePosition = [self.tempTexturePosition poistionByAddingPosition:position];
  if (gestureEnded) {
    self.tempTexturePosition = self.texturePosition;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

-(void)saveImage {
  UIImage *image = [self imageFromTexture:[self.processor processTexture:self.inputTexture]];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

// Taken from: http://www.bit-101.com/blog/?p=1861
-(UIImage *) imageFromTexture:(TMTexture *)texture {
  
  NSInteger myDataLength = texture.size.width * texture.size.height * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, texture.size.width, texture.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
  
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * texture.size.width;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(texture.size.width, texture.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  
  // then make the uiimage from that
  UIImage *myImage = [UIImage imageWithCGImage:imageRef];
  return myImage;
}


@end

NS_ASSUME_NONNULL_END
