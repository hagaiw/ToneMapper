//
//  TMMatrixProjection.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMProjection.h"

@interface TMMatrixProjection : NSObject <TMProjection>

- (instancetype)initWithMatrix:(GLKMatrix4)matrix;

@end
