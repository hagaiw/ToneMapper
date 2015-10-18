//
//  TMProjectionFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A factory calss the produces \TMProjection objects.
@interface TMProjectionFactory : NSObject

/// Returns a \TMProjection that fits an object of size \c origin inside an object of size \c target.
- (GLKMatrix4)projectionFitSize:(CGSize)origin inSize:(CGSize)target;

/// Returns a \TMProjection resulting from multiplying \c left by \c right.
- (GLKMatrix4)projectionByMultiplyingLeft:(GLKMatrix4)left
                                        right:(GLKMatrix4)right;

/// Returns the identity projection.
- (GLKMatrix4)identityProjection;

/// Returns a \TMProjection that that mirros along the vertical (y) axis.
- (GLKMatrix4)verticalMirrorProjection;

/// Returns a \TMProjection which translates by \c x and \c y.
- (GLKMatrix4)translationProjectionWithX:(GLfloat)x y:(GLfloat)y;

/// Returns a \TMProjection which scales the x and y axis by \c scale.
- (GLKMatrix4)scaleProjectionWithScale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
