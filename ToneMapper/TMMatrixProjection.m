//
//  TMMatrixProjection.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMMatrixProjection.h"

@interface TMMatrixProjection ()

@property (nonatomic) GLKMatrix4 matrix;

@end

@implementation TMMatrixProjection

- (instancetype)initWithMatrix:(GLKMatrix4)matrix {
  if (self = [super init]) {
    self.matrix = matrix;
  }
  return self;
}

@end
