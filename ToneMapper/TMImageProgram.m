//
//  TMImageProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMImageProgram.h"


@interface TMImageProgram ()

@property (readwrite, strong, nonatomic) HandleDictionary *handlesForAttributes;
@property (readwrite, strong, nonatomic) HandleDictionary *handlesForUniforms;

@end

@implementation TMImageProgram

- (instancetype)initWithProgramHandle:(GLuint)programHandle
                      handlesForAttributes:(HandleDictionary *)handlesForAttributes
                     handlesForUniforms:(HandleDictionary *)handlesForUniforms {
  if (self = [super init]) {
    self.program = programHandle;
    self.handlesForAttributes = handlesForAttributes;
    self.handlesForUniforms = handlesForUniforms;
  }
  return self;
}

@end
