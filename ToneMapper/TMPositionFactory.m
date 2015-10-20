//
//  TMPositionFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/20/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMPositionFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMPositionFactory

/// The default scale factor used when no scale is specified.
static const GLfloat kDefaultScale = 1.0;

- (TMPosition *)defaultPosition {
  return [self positionWithTranslation:CGPointZero scale:kDefaultScale];
}

- (TMPosition *)positionWithTranslation:(CGPoint)translation {
  return [self positionWithTranslation:translation scale:kDefaultScale];
}

- (TMPosition *)positionWithScale:(GLfloat)scale {
  return [self positionWithTranslation:CGPointZero scale:scale];
}

- (TMPosition *)positionWithTranslation:(CGPoint)trasnlation scale:(GLfloat)scale {
  return [[TMPosition alloc] initWithTranslation:trasnlation scale:scale];
}


@end

NS_ASSUME_NONNULL_END
