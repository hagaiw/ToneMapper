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
#import "TMGeometry.h"
//
#import "TMQuadVertices.h"
//
#import "TMTexture.h"
#import "TMTextureFrameBuffer.h"

@interface TMViewController ()

@property (strong, nonatomic) TMGLHandler *openGLHandler;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) TMProgram *textureProgram;
@property (strong, nonatomic) TMProgram *workspaceProgram;

@property (strong, nonatomic) TMTexture *imageTexture;

@property (strong, nonatomic) TMQuadVertices *quadVertices;
@property (strong, nonatomic) TMGeometry *quadGeometry;



@property (strong, nonatomic) TMTextureFrameBuffer *textureFrameBuffer;

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
  
  // init glkView
  GLKView *glkView = [[GLKView alloc] initWithFrame:[self.view bounds]];
  glkView.delegate = self;
  glkView.context = self.context;
  glkView.frame = self.view.frame;
  self.view = glkView;
  
  
  // init programs:
  NSArray *workspaceAttributes = @[@"Position", @"TexCoordIn"];
  NSArray *workspaceUniforms = @[@"Texture", @"Projection"];
  NSString *workspaceVertexShaderName = @"workspaceVertexShader";
  NSString *workspaceFragmentShaderName = @"workspaceFragmentShader";
  
  self.workspaceProgram = [[TMProgram alloc] initWithAttributes:workspaceAttributes
                                                     uniforms:workspaceUniforms
                                             vertexShaderName:workspaceVertexShaderName
                                           fragmentShaderName:workspaceFragmentShaderName];
  
  NSArray *textureAttributes = @[@"Position", @"TexCoordIn"];
  NSArray *textureUniforms = @[@"Texture", @"Projection"];
  NSString *textureVertexShaderName = @"textureVertexShader";
  NSString *textureFragmentShaderName = @"textureFragmentShader";
  
  self.textureProgram = [[TMProgram alloc] initWithAttributes:textureAttributes
                                                     uniforms:textureUniforms
                                             vertexShaderName:textureVertexShaderName
                                           fragmentShaderName:textureFragmentShaderName];
  
  
  // init geometry
  self.quadVertices = [[TMQuadVertices alloc] init];
  self.quadGeometry = [[TMGeometry alloc] initGeometryWithVertices:self.quadVertices];
  
  // init framebuffer
  NSString *imageName = @"xp";
  NSString *imageType = @".jpg";
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
  self.imageTexture = [[TMTexture alloc] initWithImagePath:imagePath];
  
  self.textureFrameBuffer = [[TMTextureFrameBuffer alloc] initWithSourceTexture:self.imageTexture];
  
  
  
  
  [self.quadGeometry bindGeometry];
  glVertexAttribPointer([self.workspaceProgram.handlesForUniforms handleForKey:@"Position"], 3, GL_FLOAT, GL_FALSE, self.quadVertices.sizeOfVertice, 0);
   glVertexAttribPointer([self.workspaceProgram.handlesForUniforms handleForKey:@"TexCoordIn"], 2, GL_FLOAT, GL_FALSE, self.quadVertices.sizeOfVertice, (GLvoid*) (sizeof(float) * 3));
   
  
  
  
  [self.imageTexture bind];
  glUniform1i([self.workspaceProgram.handlesForUniforms handleForKey:@"Texture"], 0);
  glUniformMatrix4fv([self.workspaceProgram.handlesForUniforms handleForKey:@"Projection"], 1, 0, GLKMatrix4Identity.m);
  
  
  [self.textureProgram useProgram];
  [glkView bindDrawable];
  
  glClearColor(0.0, 0.8, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  //glViewport(0, 0, self.view.frame.size.width*2, self.view.frame.size.height*2);
  glDrawElements(GL_TRIANGLES, 4, GL_UNSIGNED_BYTE, 0);
  [glkView display];
  
  
//  if (!self.openGLHandler) {
//
//    // workspace
//    
//    TMProgramData *workspaceProgramData = [[TMProgramData alloc]
//                                           initWithAttributes:workspaceAttributes
//                                                     uniforms:workspaceUniforms
//                                             vertexShaderName:@"workspaceVertexShader"
//                                           fragmentShaderName:@"workspaceFragmentShader"];
//    
//    // texture
//    
//    TMProgramData *textureProgramData = [[TMProgramData alloc]
//                                           initWithAttributes:textureAttributes
//                                           uniforms:textureUniforms
//                                           vertexShaderName:@"textureVertexShader"
//                                           fragmentShaderName:@"textureFragmentShader"];
//    
//    self.openGLHandler = [[TMGLHandler alloc] initWithGLKView:self.view
//                                         workspaceProgramData:workspaceProgramData
//                                           textureProgramData:textureProgramData];
//    NSString *imagePath = @"lightricks";
//    NSString *imageType = @".png";
//    [self.openGLHandler setImageWithName:imagePath type:imageType];
//  }
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  
  // Set Geometry
  [self.quadGeometry bindGeometry];

  glEnableVertexAttribArray([self.workspaceProgram.handlesForAttributes handleForKey:@"Position"]);
  glEnableVertexAttribArray([self.workspaceProgram.handlesForAttributes handleForKey:@"TexCoordIn"]);
  
  glVertexAttribPointer([self.workspaceProgram.handlesForAttributes handleForKey:@"Position"], 3, GL_FLOAT, GL_FALSE, self.quadVertices.sizeOfVertice, 0);
  glVertexAttribPointer([self.workspaceProgram.handlesForAttributes handleForKey:@"TexCoordIn"], 2, GL_FLOAT, GL_FALSE, self.quadVertices.sizeOfVertice, (GLvoid*) (sizeof(float) * 3));
  /////////
  
  
  [self.textureProgram useProgram];
  [self.textureFrameBuffer bind];
  [self.imageTexture bind];
  glUniform1i([self.workspaceProgram.handlesForUniforms handleForKey:@"Texture"], 0);
  glUniformMatrix4fv([self.workspaceProgram.handlesForUniforms handleForKey:@"Projection"], 1, 0, GLKMatrix4Identity.m);
  glViewport(0, 0, self.imageTexture.width, self.imageTexture.height);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
  
  [self.workspaceProgram useProgram];
  [self.textureFrameBuffer.texture bind];
  [view bindDrawable];
  glUniform1i([self.workspaceProgram.handlesForUniforms handleForKey:@"Texture"], 0);
  glUniformMatrix4fv([self.workspaceProgram.handlesForUniforms handleForKey:@"Projection"], 1, 0, [self ratioFixMatrixForTextureInfo:self.textureFrameBuffer.texture displaySize:rect.size].m);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, 0);
}

- (GLKMatrix4)ratioFixMatrixForTextureInfo:(TMTexture *)texture
                               displaySize:(CGSize)displaySize {
  GLfloat displayRatio = displaySize.height / displaySize.width;
  GLfloat imageRatio = texture.height / texture.width;
  GLfloat fitRatio = 1.0;
  if (displayRatio > imageRatio) {
    fitRatio = displaySize.width / texture.width;
  } else {
    fitRatio = texture.height / texture.height;
  }
  GLfloat xRatio = fitRatio * texture.width / displaySize.width;
  GLfloat yRatio = fitRatio * texture.height / displaySize.height;
  return GLKMatrix4Scale(GLKMatrix4Identity, xRatio, yRatio, 1.0);
}

- (void)switchImage {
  NSString *imageName = @"lightricks";
  NSString *imageType = @".png";
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
  self.imageTexture = [[TMTexture alloc] initWithImagePath:imagePath];
  self.textureFrameBuffer = [[TMTextureFrameBuffer alloc] initWithSourceTexture:self.imageTexture];
  [(GLKView *)self.view display];
}

- (void)saveImage {
  [self.openGLHandler saveImage];
}

@end
