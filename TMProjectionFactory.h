//
//  TMProjectionFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMProjection.h"

@interface TMProjectionFactory : NSObject

- (TMProjection *)projectionWithMatrix:(GLKMatrix4)matrix;
- (TMProjection *)projectionFitSize:(CGSize)origin inSize:(CGSize)target;
- (TMProjection *)projectionByMultiplyingLeft:(TMProjection *)left
                                        right:(TMProjection *)right;
- (TMProjection *)identityProjection;
- (TMProjection *)verticalFlipProjection;
- (TMProjection *)translationProjectionWithX:(GLfloat)x y:(GLfloat)y;
- (TMProjection *)scaleProjectionWithScale:(GLfloat)scale;

@end
