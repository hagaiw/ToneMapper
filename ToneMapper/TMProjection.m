//
//  TMProjection.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProjection.h"


@implementation TMProjection

@synthesize matrix = _matrix;

- (instancetype)initWithMatrix:(GLKMatrix4)matrix {
  if (self = [super init]) {
    _matrix = matrix;
  }
  return self;
}

@end
