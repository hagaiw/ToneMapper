//
//  TMTextureParameter.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/14/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMScalarProgramParameter.h"

@implementation TMScalarProgramParameter

- (instancetype)initWithName:(NSString *)name value:(GLfloat)value {
  if (self = [super init]) {
    _name = name;
    _value = value;
  }
  return self;
}

@end
