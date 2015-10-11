//
//  TMAspectFixProjection.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMAspectFixProjection.h"

@interface TMAspectFixProjection ()

@property (nonatomic) GLKMatrix4 projectionMatrix;

@end

@implementation TMAspectFixProjection

- (instancetype)initWithTexture:(TMTexture *)texture displaySize:(CGSize)displaySize {
  if (self = [super init]) {
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
    self.projectionMatrix = GLKMatrix4Scale(GLKMatrix4Identity, xRatio, yRatio, 1.0);
  }
  return self;
}

-(GLKMatrix4)matrix {
  return self.projectionMatrix;
}

@end
