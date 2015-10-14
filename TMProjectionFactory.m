//
//  TMProjectionFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProjectionFactory.h"

@implementation TMProjectionFactory

- (TMProjection *)projectionWithMatrix:(GLKMatrix4)matrix {
  return [[TMProjection alloc] initWithMatrix:matrix];
}

- (TMProjection *)identityProjection {
  return [self projectionWithMatrix:GLKMatrix4Identity];
}

- (TMProjection *)projectionByMultiplyingLeft:(TMProjection *)left
                                        right:(TMProjection *)right {
  return [self projectionWithMatrix:GLKMatrix4Multiply(left.matrix, right.matrix)];
}

- (TMProjection *)projectionFitSize:(CGSize)origin inSize:(CGSize)target {
  GLfloat targetRatio = target.height / target.width;
  GLfloat originRatio = origin.height / origin.width;
  GLfloat fitRatio = 1.0;
  if (targetRatio > originRatio) {
    fitRatio = target.width / origin.width;
  } else {
    fitRatio = target.height / origin.height;
  }
  GLfloat xRatio = fitRatio * origin.width / target.width;
  GLfloat yRatio = fitRatio * origin.height / target.height;
  return [self projectionWithMatrix:GLKMatrix4Scale(GLKMatrix4Identity, xRatio, yRatio, 1.0)];
}

- (TMProjection *)translationProjectionWithX:(GLfloat)x y:(GLfloat)y {
  return [self projectionWithMatrix:GLKMatrix4Translate(GLKMatrix4Identity, x, y, 0.0)];
}

- (TMProjection *)scaleProjectionWithScale:(GLfloat)scale {
  return [self projectionWithMatrix:GLKMatrix4Scale(GLKMatrix4Identity, scale, scale, 1.0)];
}

- (TMProjection *)verticalFlipProjection {
  return [self projectionWithMatrix:GLKMatrix4Scale(GLKMatrix4Identity, 1.0, -1.0, 1.0)];
}



@end
