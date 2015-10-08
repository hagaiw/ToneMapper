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

@interface TMViewController ()

@property (strong, nonatomic) TMGLHandler *openGLHandler;

@end

@implementation TMViewController

- (void)viewDidLoad {
  // Load Context
}

- (void)viewDidAppear:(BOOL)animated {
  
  // Init programs
  // Init geometry
  // Init
  
  
  if (!self.openGLHandler) {
    
    GLKView *glkView = [[GLKView alloc] initWithFrame:[self.view bounds]];
    glkView.delegate = self;
    self.view = glkView;
    
    // workspace
    NSArray *workspaceAttributes = @[@"Position", @"TexCoordIn"];
    NSArray *workspaceUniforms = @[@"Texture", @"Projection"];
    TMProgramData *workspaceProgramData = [[TMProgramData alloc]
                                           initWithAttributes:workspaceAttributes
                                                     uniforms:workspaceUniforms
                                             vertexShaderName:@"workspaceVertexShader"
                                           fragmentShaderName:@"workspaceFragmentShader"];
    
    // texture
    NSArray *textureAttributes = @[@"Position", @"TexCoordIn"];
    NSArray *textureUniforms = @[@"Texture", @"Projection"];
    TMProgramData *textureProgramData = [[TMProgramData alloc]
                                           initWithAttributes:textureAttributes
                                           uniforms:textureUniforms
                                           vertexShaderName:@"textureVertexShader"
                                           fragmentShaderName:@"textureFragmentShader"];
    
    self.openGLHandler = [[TMGLHandler alloc] initWithGLKView:glkView
                                         workspaceProgramData:workspaceProgramData
                                           textureProgramData:textureProgramData];
    NSString *imagePath = @"lightricks";
    NSString *imageType = @".png";
    [self.openGLHandler setImageWithName:imagePath type:imageType];
  }
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self.openGLHandler drawInRect:self.view.frame];
}

- (void)switchImage {
  NSString *imagePath = @"xp";
  NSString *imageType = @".jpg";
  [self.openGLHandler setImageWithName:imagePath type:imageType];
  GLKView *view = (GLKView *)self.view;
  [view display];
}

- (void)saveImage {
  [self.openGLHandler saveImage];
}

@end
