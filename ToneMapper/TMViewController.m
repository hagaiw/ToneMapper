//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMViewController.h"
#import "TMGLHandler.h"
#import "TMImageProgram.h"

@interface TMViewController ()

@property (strong, nonatomic) TMGLHandler *openGLHandler;

@end

@implementation TMViewController


- (void)viewDidLoad {
  if (!self.openGLHandler) {
    self.openGLHandler = [[TMGLHandler alloc] init];
    NSString *imagePath = @"lightricks";
    [self.openGLHandler setProgram:[self initialProgramWithImage:imagePath]];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.context = self.openGLHandler.context;
  view.delegate = self;
  self.view = view;
  [self.openGLHandler setViewFrame:self.view.frame];
}

- (TMImageProgram *)initialProgramWithImage:(NSString *)imagePath {
  NSArray *attributes = @[@"Position", @"TexCoordIn"];
  NSArray *uniforms = @[@"Texture", @"Projection"];
  TMShaderBundle *shaderBundle = [[TMShaderBundle alloc] initWithVertexShader:@"vertex" fragmentShader:@"fragment" attributes:attributes uniforms:uniforms];
  return [[TMImageProgram alloc] initWithShaderBundle:shaderBundle image:imagePath];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  [self.openGLHandler drawInRect:self.view.frame];
}

- (void)switchImage {
  NSString *imagePath = @"enlight";
  [self.openGLHandler setProgram:[self initialProgramWithImage:imagePath]];
  GLKView *view = (GLKView *)self.view;
  [view display];
}

- (void)saveImage {
  [self.openGLHandler saveImage];
}

@end
