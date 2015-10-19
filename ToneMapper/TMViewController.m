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

/// The current processor used by the processing pipeline.
@property (strong, nonatomic) TMTextureProcessor *processor;

/// The current display used to output the result of the processor.
@property (strong, nonatomic) TMTextureDisplay *display;

/// The \c TMTexture inputed by the processor.
@property (strong, nonatomic) TMTexture *inputTexture;

/// The \c TMTexture resulting from applying the processor to \c inputTexture.
@property (strong, nonatomic) TMTexture *processedTexture;

/// The position of the currently displayed \c TMTexture on screen.
@property (strong, nonatomic) TMPosition *texturePosition;

/// A \c TMPosition used to calculate correct scale and translation transformations during ongoing
/// transformations.
@property (strong, nonatomic) TMPosition *tempTexturePosition;

/// A factory object used to produce \c TMProgram.
@property (strong, nonatomic) TMProgramFactory *programFactory;

/// The \c GLKView used by this \c UIViewController.
@property (strong, nonatomic) GLKView *glkView;

/// The current openGL context;
@property (strong, nonatomic) EAGLContext *context;

/// Indicates whether the \c processor needs to be applied to \c inputTexture.
@property (nonatomic) BOOL textureNeedsProcessing;

@end

@implementation TMViewController

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.programFactory = [TMProgramFactory new];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  
  self.textureNeedsProcessing = false;
  self.texturePosition = [[TMPosition alloc] initWithTranslation:CGPointMake(0.0, 0.0) scale:1.0];
  self.tempTexturePosition = self.texturePosition;
  self.processor = [[TMTextureProcessorFactory new]
                    processorWithProgram:[self.programFactory textureProcessingProgram]];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!self.glkView) {
    self.glkView = [GLKView new];
    self.glkView.delegate = self;
    self.glkView.context = self.context;
    self.glkView.opaque = NO;
    self.glkView.frame = self.view.frame;
    [self.view addSubview:self.glkView];
  }
  self.display = [[TMTextureDisplay alloc]
                        initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc]
                                             initWithGLKView:self.glkView]
                                    program:[self.programFactory textureDisplayProgram]
                                   geometry:[[TMTexturedGeometry alloc]
                                             initWithTexturedVertices:
                                               [TMQuadTexturedVertices new]]];
}

#pragma mark -
#pragma mark GLKView Delegate
#pragma mark -

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.2, 0.0, 0.2, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  if(self.textureNeedsProcessing) {
    self.processedTexture = [self.processor processAndFlipTexture:self.inputTexture];
    self.textureNeedsProcessing = false;
  }
  [self.display displayTexture:self.processedTexture displayData:self.texturePosition];
}

#pragma mark -
#pragma mark User Interaction
#pragma mark -

- (void)loadTextureFromImage:(UIImage *)image {
  self.inputTexture = [[TMTexture alloc] initWithImage:image];
  self.textureNeedsProcessing = true;
  [self.glkView setNeedsDisplay];
}

- (void)moveTextureWithTranslation:(CGPoint)translation movementEnded:(BOOL)movementEnded {
  TMPosition *positionDelta = [[TMPosition alloc] initWithTranslation:translation scale:1.0];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:movementEnded];
}

- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
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
  [self.glkView setNeedsDisplay];
}

-(void)saveProcessedTexture {
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

- (NSUInteger)maxTextureSize {
  int maxTextureSize;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &maxTextureSize);
  return (NSUInteger)maxTextureSize;
}

@end

NS_ASSUME_NONNULL_END
