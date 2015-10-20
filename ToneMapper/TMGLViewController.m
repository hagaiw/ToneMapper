//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGLViewController.h"
#import "TMTexture.h"
#import "TMGeometryFactory.h"
#import "TMProgramFactory.h"
#import "TMTextureProcessorFactory.h"
#import "TMPositionFactory.h"
#import "TMTextureFrameBuffer.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMTextureDisplay.h"


NS_ASSUME_NONNULL_BEGIN

@interface TMGLViewController ()

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

/// A factory object used to produce \c TMPrograms.
@property (strong, nonatomic) TMProgramFactory *programFactory;

// A factory object used to produce \c TMTexturedGeometries.
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

// A factory object used to produce \c TMTextureProcessors.
@property (strong, nonatomic) TMTextureProcessorFactory *processorFactory;

// A factory object used to produce \c TMPositions.
@property (strong, nonatomic) TMPositionFactory *positionFactory;

/// The \c GLKView used by this \c UIViewController.
@property (strong, nonatomic) GLKView *glkView;

/// The current openGL context;
@property (strong, nonatomic) EAGLContext *context;

/// Indicates whether the \c processor needs to be applied to \c inputTexture.
@property (nonatomic) BOOL textureNeedsProcessing;

@end

@implementation TMGLViewController

/// The value of bitsPerComponent to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerComponent = 8;

/// The value of bitsPerPixel to use in \c saveProcessedTexture when calling CGImageCreate.
static const int kBitsPerPixel = 32;

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.programFactory = [TMProgramFactory new];
  self.geometryFactory = [TMGeometryFactory new];
  self.processorFactory = [TMTextureProcessorFactory new];
  self.positionFactory = [TMPositionFactory new];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  
  self.textureNeedsProcessing = false;
  self.texturePosition = [self.positionFactory defaultPosition];
  self.tempTexturePosition = self.texturePosition;
  self.processor = [self.processorFactory
                    processorWithProgram:[self.programFactory passThroughWithProjection]];
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
                                    program:[self.programFactory passThroughWithProjection]
                                   geometry:[self.geometryFactory quadGeometry]];
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
  [self.display displayTexture:self.processedTexture position:self.texturePosition];
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
  TMPosition *positionDelta = [self.positionFactory positionWithTranslation:translation];
  [self updateTexturePositionWithPosition:positionDelta gestureEnded:movementEnded];
}

- (void)zoomImageByScale:(GLfloat)scale zoomLocation:(CGPoint)zoomLocation
               zoomEnded:(BOOL)zoomEnded {
  TMPosition *positionDelta = [self.positionFactory positionWithScale:scale];
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
  UIImage *image = [self imageFromProcessor:self.processor];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

// Taken from: http://www.bit-101.com/blog/?p=1861
-(UIImage *) imageFromProcessor:(TMTextureProcessor *)processor {
  
  TMTexture *texture = [processor processTexture:self.inputTexture];
  
  NSInteger myDataLength = texture.size.width * texture.size.height * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, texture.size.width, texture.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
  
  // prep the ingredients
  int bytesPerRow = 4 * texture.size.width;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(texture.size.width, texture.size.height, kBitsPerComponent,
                                          kBitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo,
                                          provider, NULL, NO, renderingIntent);
  
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
