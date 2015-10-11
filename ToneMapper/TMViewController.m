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

#import "TMDrawer.h"

#import "TMGLKViewFrameBuffer.h"

#import "TMMatrixProjection.h"
#import "TMAspectFixProjection.h"

@interface TMViewController ()

@property (strong, nonatomic) TMGLHandler *openGLHandler;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) TMProgram *textureProgram;
@property (strong, nonatomic) TMProgram *workspaceProgram;

@property (strong, nonatomic) TMTexture *imageTexture;

@property (strong, nonatomic) TMTexturedGeometry *quadGeometry;

@property (strong, nonatomic) TMDrawer *textureDrawer;
@property (strong, nonatomic) TMDrawer *screenDrawer;

@property (strong, nonatomic) TMTextureFrameBuffer *textureFrameBuffer;

@property (strong, nonatomic) id<TMProjection> workspaceProjection;
@property (strong, nonatomic) id<TMProjection> baseWorkspaceProjection;

@end

@implementation TMViewController




- (void)viewDidLoad {
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
}

- (void)viewDidAppear:(BOOL)animated {
  [self initGLKView];
  
  
  // Workspace Program:
  NSArray *workspaceAttributes = @[@"Position", @"TexCoordIn"];
  NSArray *workspaceUniforms = @[@"Texture", @"Projection"];
  NSString *workspaceVertexShaderName = @"workspaceVertexShader";
  NSString *workspaceFragmentShaderName = @"workspaceFragmentShader";
  self.workspaceProgram = [[TMProgram alloc] initWithAttributes:workspaceAttributes
                                                     uniforms:workspaceUniforms
                                             vertexShaderName:workspaceVertexShaderName
                                           fragmentShaderName:workspaceFragmentShaderName];
  
  // Texture Program:
  NSArray *textureAttributes = @[@"Position", @"TexCoordIn"];
  NSArray *textureUniforms = @[@"Texture", @"Projection"];
  NSString *textureVertexShaderName = @"textureVertexShader";
  NSString *textureFragmentShaderName = @"textureFragmentShader";
  self.textureProgram = [[TMProgram alloc] initWithAttributes:textureAttributes
                                                     uniforms:textureUniforms
                                             vertexShaderName:textureVertexShaderName
                                           fragmentShaderName:textureFragmentShaderName];
  
  // init geometry
  self.quadGeometry = [[TMTexturedGeometry alloc] initWithTexturedVertices:[TMQuadTexturedVertices new]];
  [self.quadGeometry bind];
  
  // init framebuffer
  NSString *imageName = @"xp";
  NSString *imageType = @".jpg";
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
  self.imageTexture = [[TMTexture alloc] initWithImagePath:imagePath];
  self.textureFrameBuffer = [[TMTextureFrameBuffer alloc] initWithSourceTexture:self.imageTexture];

  
  // texture
  [self.imageTexture bind];
  glUniform1i([self.workspaceProgram.handlesForUniforms handleForKey:@"Texture"], 0);
  glUniformMatrix4fv([self.workspaceProgram.handlesForUniforms handleForKey:@"Projection"], 1, 0, GLKMatrix4Identity.m);
  
  
  [self.textureProgram useProgram];
  [(GLKView *)self.view bindDrawable];
  
  glClearColor(0.0, 0.8, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  
  self.baseWorkspaceProjection = [[TMMatrixProjection alloc] initWithMatrix:GLKMatrix4Identity];
  self.workspaceProjection = self.baseWorkspaceProjection;
  
  [(GLKView *)self.view setNeedsDisplay];
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  
  glClearColor(0.0, 0.8, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  id<TMProjection> yReverseProjection = [[TMMatrixProjection alloc] initWithMatrix:GLKMatrix4Scale(GLKMatrix4Identity, 1.0, -1.0, 1.0)];
  self.textureDrawer = [[TMDrawer alloc] initWithProgram:self.textureProgram
                                        texturedGeometry:self.quadGeometry
                                             frameBuffer:self.textureFrameBuffer
                                                 texture:self.imageTexture
                                              projection:yReverseProjection];
  
  id<TMProjection> aspectRatioProjection = [[TMAspectFixProjection alloc] initWithTexture:self.textureFrameBuffer.texture displaySize:rect.size];
  
  id<TMProjection> currentProjection = [[TMMatrixProjection alloc] initWithMatrix:GLKMatrix4Multiply([self.workspaceProjection matrix],[aspectRatioProjection matrix])];
  
  self.screenDrawer = [[TMDrawer alloc] initWithProgram:self.workspaceProgram
                                       texturedGeometry:self.quadGeometry
                                            frameBuffer:[[TMGLKViewFrameBuffer alloc] initWithGLKView:(GLKView *)self.view]
                                                texture:self.textureFrameBuffer.texture
                                             projection:currentProjection];
  [self.textureDrawer draw];
  [self.screenDrawer draw];
}

- (void)initGLKView {
  GLKView *glkView = [[GLKView alloc] initWithFrame:[self.view bounds]];
  glkView.delegate = self;
  glkView.context = self.context;
  glkView.frame = self.view.frame;
  self.view = glkView;
}

- (void)switchImage {
  NSString *imageName = @"lightricks";
  NSString *imageType = @".png";
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
//  self.imageTexture = [[TMTexture alloc] initWithImagePath:imagePath];
//  self.textureFrameBuffer = [[TMTextureFrameBuffer alloc] initWithSourceTexture:self.imageTexture];
  
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)moveImageByX:(GLfloat)x y:(GLfloat)y movementEnded:(BOOL)movementEnded {
  self.workspaceProjection = [[TMMatrixProjection alloc] initWithMatrix:GLKMatrix4Translate([self.baseWorkspaceProjection matrix], x, y, 0.0)];
  if (movementEnded) {
    self.baseWorkspaceProjection = self.workspaceProjection;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)zoomImageToScale:(GLfloat)scale zoomEnded:(BOOL)zoomEnded {
  self.workspaceProjection = [[TMMatrixProjection alloc] initWithMatrix:GLKMatrix4Scale([self.baseWorkspaceProjection matrix], scale, scale, 1.0)];
  
  if (zoomEnded) {
    self.baseWorkspaceProjection = self.workspaceProjection;
  }
  [(GLKView *)self.view setNeedsDisplay];
}

- (void)saveImage {
  [self.openGLHandler saveImage];
}

@end
