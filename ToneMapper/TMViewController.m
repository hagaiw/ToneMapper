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
#import "TMPipelineManager.h"
#import "TMTextureProcessorFactory.h"
#import "TMTextureDisplayer.h"

@interface TMViewController ()

@property (strong, nonatomic) TMPipelineManager *manager;
@property (strong, nonatomic) TMTextureProcessor *processor;
@property (strong, nonatomic) TMTextureDisplayer *mainDisplayer;
@property (strong, nonatomic) TMTextureDisplayer *tempDisplayer;
@property (strong, nonatomic) TMTexture *imageTexture;

@property (strong, nonatomic) EAGLContext *context;


@end

@implementation TMViewController

static NSString * const kTextureVertexShader = @"textureVertexShader";
static NSString * const kTextureFragmentShader = @"textureFragmentShader";

- (void)viewDidLoad {
  [super viewDidLoad];
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  
  self.manager = [TMPipelineManager new];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self initGLKView];
  self.mainDisplayer = [[TMTextureDisplayer alloc] initWithFrameBuffer:[[TMGLKViewFrameBuffer alloc] initWithGLKView:(GLKView *)self.view]];
  self.tempDisplayer = self.mainDisplayer;
  self.manager.displayer = self.mainDisplayer;
  
  
  TMTextureProgram *program = [[TMProgramFactory new] textureProgramWithVertexShaderName:kTextureVertexShader fragmentShaderName:kTextureFragmentShader textureUniformName:kTextureUniform projectionUniformName:kProjectionUniform positionAttributeName:kPositionAttribute textureCoordName:kTextureCoordinateAttribute];
  
  self.manager.processor = [[TMTextureProcessorFactory new] processorWithProgram:program];
  
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
  [self.manager setDisplayer:self.mainDisplayer];
  [self.manager processTexture];
  [self.manager displayProcessedTexture];
}

- (void)switchImage:(UIImage *)image {
  self.manager.inputTexture = [[TMTexture alloc] initWithImage:image];
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
  self.mainDisplayer = [self.tempDisplayer displayerWithTranslationDeltaScale:scale
                                                                   scalePositionX:positionX
                                                                                y:positionY];
  if (zoomEnded) {
    self.tempDisplayer = self.mainDisplayer;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)saveImage {
  [self.manager saveImage];
}


@end
