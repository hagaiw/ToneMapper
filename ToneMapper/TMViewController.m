//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMViewController.h"
#import "TMGLHandler.h"

#import "TMProgramData.h"
#import "TMImageProgram.h"

#import "TMProgram.h"
#import "TMTexturedGeometry.h"
//
#import "TMQuadTexturedVertices.h"
//
#import "TMTexture.h"
#import "TMTextureFrameBuffer.h"

#import "TMTextureDrawer.h"
#import "TMTextureProgram.h"

#import "TMGLKViewFrameBuffer.h"

#import "TMProjectionFactory.h"

#import "TMProgramFactory.h"

#import "TMManager.h"
#import "TMTextureProcessorFactory.h"
#import "TMTextureDisplayer.h"

@interface TMViewController ()

@property (strong, nonatomic) TMManager *manager;
@property (strong, nonatomic) TMTextureProcessor *processor;
@property (strong, nonatomic) TMTextureDisplayer *mainDisplayer;
@property (strong, nonatomic) TMTextureDisplayer *tempDisplayer;
@property (strong, nonatomic) TMTexture *imageTexture;

@property (strong, nonatomic) EAGLContext *context;


@end

@implementation TMViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self initGLKView];

  self.mainDisplayer = [[TMTextureDisplayer alloc] initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc] initWithGLKView:(GLKView *)self.view]];
  self.tempDisplayer = self.mainDisplayer;

  
  NSString *imageName = @"xp";
  NSString *imageType = @".jpg";
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
  UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
  self.imageTexture = [[TMTexture alloc] initWithImage:image];
  self.processor = [[TMTextureProcessorFactory new] processorWithTexture:self.imageTexture];
  self.manager = [TMManager new];

  [(GLKView *)self.view setNeedsDisplay];
}

- (void)initGLKView {
  GLKView *glkView = [[GLKView alloc] initWithFrame:[self.view bounds]];
  glkView.delegate = self;
  glkView.context = self.context;
  glkView.frame = self.view.frame;
  glkView.opaque = NO;
  self.view = glkView;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  
  glClearColor(0.0, 0.8, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  self.manager.processor = self.processor;
  self.manager.displayer = self.mainDisplayer;
  [self.manager processTexture];
}

- (void)switchImage:(UIImage *)image {
  TMTexture *imageTexture = [[TMTexture alloc] initWithImage:image];
  self.processor = [self.processor processorWithTexture:imageTexture];
  self.mainDisplayer = [[TMTextureDisplayer alloc] initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc] initWithGLKView:(GLKView *)self.view]];
  self.tempDisplayer = self.mainDisplayer;
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)moveImageByX:(GLfloat)x y:(GLfloat)y movementEnded:(BOOL)movementEnded {
  self.mainDisplayer = [self.tempDisplayer displayerWithTranslationDeltaX:x y:y];
  if (movementEnded) {
    self.tempDisplayer = self.mainDisplayer;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)zoomImageByScale:(GLfloat)scale positionX:(GLfloat)positionX positionY:(GLfloat)positionY
               zoomEnded:(BOOL)zoomEnded {
  self.mainDisplayer = [self.tempDisplayer displayerWithTranslationDeltaScale:scale scalePositionX:positionX y:positionY];
  
  if (zoomEnded) {
    self.tempDisplayer = self.mainDisplayer;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)saveImage {
  [self.manager saveImage];
}


@end
