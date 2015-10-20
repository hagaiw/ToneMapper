//
//  TMPositionFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/20/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMPositionFactory : NSObject

/// Returns the default \c TMPosition.
- (TMPosition *)defaultPosition;

/// Returns the default \c TMPosition with the given \c translation.
- (TMPosition *)positionWithTranslation:(CGPoint)translation;

/// Returns the default \c TMPosition with the given \c scale.
- (TMPosition *)positionWithScale:(GLfloat)scale;

/// Returns a \c TMPosition with the given \c translation.
- (TMPosition *)positionWithTranslation:(CGPoint)trasnlation scale:(GLfloat)scale;

@end

NS_ASSUME_NONNULL_END
