//
//  TMAspectFixProjection.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMProjection.h"
#import "TMTexture.h"

@interface TMAspectFixProjection : NSObject <TMProjection>

- (instancetype)initWithTexture:(TMTexture *)texture displaySize:(CGSize)displaySize;

@end
