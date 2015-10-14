//
//  TMTextureProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/12/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureProgram.h"

@interface TMTextureProgram ()

@property (strong, nonatomic) TMProgram *program;

@end

@implementation TMTextureProgram

- (instancetype)initWithProgram:(TMProgram *)program
           textureUniformString:(NSString *)textureUniform
        projectionUniformString:(NSString *)projectionUniform
    textureCoordAttributeString:(NSString *)textureCoordAttribute
        positionAttributeString:(NSString *)positionAttribute {
  if (self = [super init]) {
    self.program = program;
    _textureUniform = [program.handlesForUniforms handleForKey:textureUniform];
    _projectionUniform = [program.handlesForUniforms handleForKey:projectionUniform];
    _textureCoordAttribute = [program.handlesForAttributes handleForKey:textureCoordAttribute];
    _positionAttribute = [program.handlesForAttributes handleForKey:positionAttribute];
  }
  return self;
}

- (void)use {
  [self.program useProgram];
}

@end
