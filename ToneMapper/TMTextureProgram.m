//
//  TMTextureProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/12/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureProgram.h"

@interface TMTextureProgram ()

/// The \TMProgram wrapped by this class.
@property (strong, nonatomic) TMProgram *program;

@end

@implementation TMTextureProgram

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithProgram:(TMProgram *)program {
  if (self = [super init]) {
    self.program = program;
    _textureUniform = [program.handlesForUniforms handleForKey:kTextureUniform];
    _projectionUniform = [program.handlesForUniforms handleForKey:kProjectionUniform];
    _textureCoordAttribute = [program.handlesForAttributes handleForKey:kTextureCoordinateAttribute];
    _positionAttribute = [program.handlesForAttributes handleForKey:kPositionAttribute];
  }
  return self;
}

#pragma mark -
#pragma mark OpenGL Binding
#pragma mark -

- (void)use {
  [self.program useProgram];
}

@end
