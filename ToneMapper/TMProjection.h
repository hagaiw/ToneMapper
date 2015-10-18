//
//  TMProjection.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Value class, represents a projection \c GLKMatrix4, to be used as a uniform variable.
@interface TMProjection : NSObject

/// Initialize with the given \c GLKMatrix4 matrix.
- (instancetype)initWithMatrix:(GLKMatrix4)matrix;

/// The projection matrix.
@property (readonly, nonatomic) GLKMatrix4 matrix;

@end

NS_ASSUME_NONNULL_END
