//
//  TMProjectionFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProjection.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A factory calss the produces \TMProjection objects.
@interface TMProjectionFactory : NSObject

/// Returns a \TMProjection with the given \GLKMatrix4 matrix.
- (TMProjection *)projectionWithMatrix:(GLKMatrix4)matrix;

/// Returns a \TMProjection that fits an object of size \c origin inside an object of size \c target.
- (TMProjection *)projectionFitSize:(CGSize)origin inSize:(CGSize)target;

/// Returns a \TMProjection resulting from multiplying \c left by \c right.
- (TMProjection *)projectionByMultiplyingLeft:(TMProjection *)left
                                        right:(TMProjection *)right;

/// Returns the identity projection.
- (TMProjection *)identityProjection;

/// Returns a \TMProjection that that mirros along the vertical (y) axis.
- (TMProjection *)verticalMirrorProjection;

/// Returns a \TMProjection which translates by \c x and \c y.
- (TMProjection *)translationProjectionWithX:(GLfloat)x y:(GLfloat)y;

/// Returns a \TMProjection which scales the x and y axis by \c scale.
- (TMProjection *)scaleProjectionWithScale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
