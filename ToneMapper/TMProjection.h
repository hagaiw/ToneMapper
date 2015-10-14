//
//  TMProjection.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface TMProjection : NSObject

- (instancetype)initWithMatrix:(GLKMatrix4)matrix;
@property (readonly, nonatomic) GLKMatrix4 matrix;

@end
